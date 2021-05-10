// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_final_locals
// ignore_for_file: constant_identifier_names

num parseNumber(String source) {
  // It is intended only to compare the performance of the PEG2 parser and the Dart VM parser
  // Based on https://github.com/dart-lang/sdk/blob/master/sdk/lib/_internal/vm/lib/convert_patch.dart

  const POWERS_OF_TEN = [
    1.0, // 0
    10.0,
    100.0,
    1000.0,
    10000.0,
    100000.0, // 5
    1000000.0,
    10000000.0,
    100000000.0,
    1000000000.0,
    10000000000.0, // 10
    100000000000.0,
    1000000000000.0,
    10000000000000.0,
    100000000000000.0,
    1000000000000000.0, // 15
    10000000000000000.0,
    100000000000000000.0,
    1000000000000000000.0,
    10000000000000000000.0,
    100000000000000000000.0, // 20
    1000000000000000000000.0,
    10000000000000000000000.0,
  ];

  const MINUS = 45;
  const DECIMALPOINT = 46;
  const CHAR_0 = 48;
  const CHAR_e = 101;

  int getChar(int pos) {
    return source.codeUnitAt(pos);
  }

  final length = source.length;
  var position = 0;
  var char = getChar(0);

  // Also called on any unexpected character.
  // Format:
  //  '-'?('0'|[1-9][0-9]*)('.'[0-9]+)?([eE][+-]?[0-9]+)?
  // Collects an int value while parsing. Used for both an integer literal,
  // and the exponent part of a double literal.
  // Stored as negative to ensure we can represent -2^63.
  int intValue = 0;
  double doubleValue = 0.0; // Collect double value while parsing.
  // 1 if there is no leading -, -1 if there is.
  int sign = 1;
  bool isDouble = false;
  // Break this block when the end of the number literal is reached.
  // At that time, position points to the next character, and isDouble
  // is set if the literal contains a decimal point or an exponential.
  if (char == MINUS) {
    sign = -1;
    position++;
    //if (position == length) return beginChunkNumber(NUM_SIGN, start);
    char = getChar(position);
  }
  int digit = char ^ CHAR_0;
  if (digit > 9) {
    if (sign < 0) {
      //fail(position, "Missing expected digit");
    } else {
      // If it doesn't even start out as a numeral.
      //fail(position);
    }
  }
  if (digit == 0) {
    position++;
    if (position == length) {
      return 0;
    }
    char = getChar(position);
    digit = char ^ CHAR_0;
    // If starting with zero, next character must not be digit.
    //if (digit <= 9) fail(position);
  } else {
    int digitCount = 0;
    do {
      if (digitCount >= 18) {
        // Check for overflow.
        // Is 1 if digit is 8 or 9 and sign == 0, or digit is 9 and sign < 0;
        int highDigit = digit >> 3;
        if (sign < 0) highDigit &= digit;
        if (digitCount == 19 || intValue - highDigit < -922337203685477580) {
          isDouble = true;
          // Big value that we know is not trusted to be exact later,
          // forcing reparsing using `double.parse`.
          doubleValue = 9223372036854775808.0;
        }
      }
      intValue = 10 * intValue - digit;
      digitCount++;
      position++;
      if (position == length) {
        break;
      }
      char = getChar(position);
      digit = char ^ CHAR_0;
    } while (digit <= 9);
  }
  if (char == DECIMALPOINT) {
    if (!isDouble) {
      isDouble = true;
      doubleValue = (intValue == 0) ? 0.0 : -intValue.toDouble();
    }
    intValue = 0;
    position++;
    //if (position == length) return beginChunkNumber(NUM_DOT, start);
    char = getChar(position);
    digit = char ^ CHAR_0;
    //if (digit > 9) fail(position);
    do {
      doubleValue = 10.0 * doubleValue + digit;
      intValue -= 1;
      position++;
      if (position == length) {
        return doubleValue;
      }
      char = getChar(position);
      digit = char ^ CHAR_0;
    } while (digit <= 9);
  }
  if ((char | 0x20) == CHAR_e) {
    if (!isDouble) {
      isDouble = true;
      doubleValue = (intValue == 0) ? 0.0 : -intValue.toDouble();
      intValue = 0;
    }
    position++;
    //if (position == length) return beginChunkNumber(NUM_E, start);
    char = getChar(position);
    int expSign = 1;
    int exponent = 0;
    if (((char + 1) | 2) == 0x2e /*+ or -*/) {
      expSign = 0x2C - char; // -1 for MINUS, +1 for PLUS
      position++;
      //if (position == length) return beginChunkNumber(NUM_E_SIGN, start);
      char = getChar(position);
    }
    digit = char ^ CHAR_0;
    if (digit > 9) {
      //fail(position, "Missing expected digit");
    }
    bool exponentOverflow = false;
    do {
      exponent = 10 * exponent + digit;
      if (exponent > 400) exponentOverflow = true;
      position++;
      if (position == length) {
        break;
      }
      char = getChar(position);
      digit = char ^ CHAR_0;
    } while (digit <= 9);
    if (exponentOverflow) {
      if (doubleValue == 0.0 || expSign < 0) {
        return sign < 0 ? -0.0 : 0.0;
      } else {
        return sign < 0 ? double.negativeInfinity : double.infinity;
      }
    }
    intValue += expSign * exponent;
  }
  if (!isDouble) {
    int bitFlag = -(sign + 1) >> 1; // 0 if sign == -1, -1 if sign == 1
    // Negate if bitFlag is -1 by doing ~intValue + 1
    return (intValue ^ bitFlag) - bitFlag;
  }
  // Double values at or above this value (2 ** 53) may have lost precision.
  // Only trust results that are below this value.
  const double maxExactDouble = 9007199254740992.0;
  if (doubleValue < maxExactDouble) {
    int exponent = intValue;
    double signedMantissa = doubleValue * sign;
    if (exponent >= -22) {
      if (exponent < 0) {
        return signedMantissa / POWERS_OF_TEN[-exponent];
      }
      if (exponent == 0) {
        return signedMantissa;
      }
      if (exponent <= 22) {
        return signedMantissa * POWERS_OF_TEN[exponent];
      }
    }
  }
  // If the value is outside the range +/-maxExactDouble or
  // exponent is outside the range +/-22, then we can't trust simple double
  // arithmetic to get the exact result, so we use the system double parsing.
  return double.parse(source);
}
