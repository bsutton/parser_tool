part of '../parsers.dart';

class CharacterParser extends Parser<int> {
  final int character;

  final ParseResult<int> result;

  CharacterParser(this.character, {String? source})
      : result = ParseResult(character),
        super(source: source);

  @override
  bool fastParse(ParseState state) {
    final ch = state.ch;
    if (ch == character) {
      ParseState.nextChar(state);
      return true;
    }

    return false;
  }

  @override
  CharacterRepeaterParser getRepeater(int min, int max, {String? source}) {
    return CharacterRepeaterParser(min, max, character, source: source);
  }

  @override
  ParseResult<int>? parse(ParseState state) {
    final ch = state.ch;
    if (ch == character) {
      ParseState.nextChar(state);
      return result;
    }
  }
}

class CharacterRepeaterParser extends RepeaterParser<int> {
  final int character;

  final ParseResult<int> result;

  CharacterRepeaterParser(int min, int max, this.character, {String? source})
      : result = ParseResult(character),
        super(min, max, source: source);

  @override
  bool fastParse(ParseState state) {
    var ch = state.ch;
    var count = 0;
    while (count < max) {
      if (ch != character) {
        break;
      }

      ch = ParseState.nextChar(state);
      count++;
    }

    return count >= min;
  }

  @override
  ParseResult<List<int>>? parse(ParseState state) {
    var ch = state.ch;
    if (ch == character) {
      final list = [ch];
      ch = ParseState.nextChar(state);
      while (list.length < max) {
        if (ch != character) {
          break;
        }

        list.add(ch);
        ch = ParseState.nextChar(state);
      }

      if (list.length >= min) {
        return ParseResult(list);
      }

      return null;
    }

    if (min == 0) {
      return const ParseResult([]);
    }
  }
}

class CharactersParser extends Parser<int> {
  final Uint32List characters;

  final int maxCharacter;

  CharactersParser(this.characters, {String? source})
      : maxCharacter = characters.last,
        super(source: source);

  @override
  bool fastParse(ParseState state) {
    final ch = state.ch;
    if (ch <= maxCharacter) {
      for (var i = 0; i < characters.length; i++) {
        if (ch == characters[i]) {
          ParseState.nextChar(state);
          return true;
        }
      }
    }

    return false;
  }

  @override
  CharactersRepeaterParser getRepeater(int min, int max, {String? source}) {
    return CharactersRepeaterParser(min, max, characters, source: source);
  }

  @override
  ParseResult<int>? parse(ParseState state) {
    final ch = state.ch;
    if (ch <= maxCharacter) {
      for (var i = 0; i < characters.length; i++) {
        if (ch == characters[i]) {
          ParseState.nextChar(state);
          return ParseResult(ch);
        }
      }
    }
  }
}

class CharactersRepeaterParser extends RepeaterParser<int> {
  final Uint32List characters;

  final int maxCharacter;

  CharactersRepeaterParser(int min, int max, this.characters, {String? source})
      : maxCharacter = characters.last,
        super(min, max, source: source);

  @override
  bool fastParse(ParseState state) {
    var ch = state.ch;
    var count = 0;
    loop:
    while (count < max) {
      if (ch > maxCharacter) {
        break;
      }

      if (characters.length == 2) {
        if (ch == characters[0] || ch == characters[1]) {
          ch = ParseState.nextChar(state);
          count++;
          continue loop;
        }

        break;
      } else if (characters.length == 3) {
        if (ch == characters[0] || ch == characters[1] || ch == characters[2]) {
          ch = ParseState.nextChar(state);
          count++;
          continue loop;
        }

        break;
      } else if (characters.length == 4) {
        if (ch == characters[0] ||
            ch == characters[1] ||
            ch == characters[2] ||
            ch == characters[3]) {
          ch = ParseState.nextChar(state);
          count++;
          continue loop;
        }

        break;
      } else {
        for (var i = 0; i < characters.length; i++) {
          if (ch == characters[i]) {
            ch = ParseState.nextChar(state);
            count++;
            continue loop;
          }
        }
      }

      break;
    }

    return count >= min;
  }

  @override
  ParseResult<List<int>>? parse(ParseState state) {
    var ch = state.ch;
    if (ch <= maxCharacter && characters.contains(ch)) {
      final list = [ch];
      ch = ParseState.nextChar(state);
      loop:
      while (list.length < max) {
        if (ch > maxCharacter) {
          break;
        }

        if (characters.length == 2) {
          if (ch == characters[0] || ch == characters[1]) {
            list.add(ch);
            ch = ParseState.nextChar(state);
            continue loop;
          }

          break;
        } else if (characters.length == 3) {
          if (ch == characters[0] ||
              ch == characters[1] ||
              ch == characters[2]) {
            list.add(ch);
            ch = ParseState.nextChar(state);
            continue loop;
          }

          break;
        } else if (characters.length == 4) {
          if (ch == characters[0] ||
              ch == characters[1] ||
              ch == characters[2] ||
              ch == characters[3]) {
            list.add(ch);
            ch = ParseState.nextChar(state);
            continue loop;
          }

          break;
        } else {
          for (var i = 0; i < characters.length; i++) {
            if (ch == characters[i]) {
              list.add(ch);
              ch = ParseState.nextChar(state);
              continue loop;
            }
          }
        }

        break;
      }

      if (list.length >= min) {
        return ParseResult(list);
      }

      return null;
    }

    if (min == 0) {
      return const ParseResult([]);
    }
  }
}

class CheckedCharacterParser extends Parser<int> {
  final int character;

  final ParseResult<int> result;

  CheckedCharacterParser(this.character, {String? source})
      : result = ParseResult(character),
        super(source: source);

  @override
  bool fastParse(ParseState state) {
    ParseState.nextChar(state);
    return true;
  }

  @override
  ParseResult<int>? parse(ParseState state) {
    ParseState.nextChar(state);
    return result;
  }
}

class CheckedCharactersParser extends Parser<int> {
  final Uint32List characters;

  final int maxCharacter;

  CheckedCharactersParser(this.characters, {String? source})
      : maxCharacter = characters.last,
        super(source: source);

  @override
  bool fastParse(ParseState state) {
    ParseState.nextChar(state);
    return true;
  }

  @override
  ParseResult<int>? parse(ParseState state) {
    final ch = state.ch;
    ParseState.nextChar(state);
    return ParseResult(ch);
  }
}

class CheckedRangesParser extends Parser<int> {
  final Uint32List ranges;

  CheckedRangesParser(this.ranges, {String? source}) : super(source: source);

  @override
  bool fastParse(ParseState state) {
    ParseState.nextChar(state);
    return true;
  }

  @override
  ParseResult<int>? parse(ParseState state) {
    final ch = state.ch;
    ParseState.nextChar(state);
    return ParseResult(ch);
  }
}

class RangesParser extends Parser<int> {
  final Uint32List ranges;

  RangesParser(this.ranges, {String? source}) : super(source: source);

  @override
  bool fastParse(ParseState state) {
    final ch = state.ch;
    for (var i = 0; i < ranges.length; i += 2) {
      if (ranges[i] <= ch) {
        if (ranges[i + 1] >= ch) {
          ParseState.nextChar(state);
          return true;
        }
      } else {
        break;
      }
    }

    return false;
  }

  @override
  RangesRepeaterParser getRepeater(int min, int max, {String? source}) {
    return RangesRepeaterParser(min, max, ranges, source: source);
  }

  @override
  ParseResult<int>? parse(ParseState state) {
    final c = state.ch;
    for (var i = 0; i < ranges.length; i += 2) {
      if (ranges[i] <= c) {
        if (ranges[i + 1] >= c) {
          ParseState.nextChar(state);
          return ParseResult(c);
        }
      } else {
        break;
      }
    }
  }
}

class RangesRepeaterParser extends RepeaterParser<int> {
  final Uint32List ranges;

  RangesRepeaterParser(int min, int max, this.ranges, {String? source})
      : super(min, max, source: source);

  @override
  bool fastParse(ParseState state) {
    var count = 0;
    while (count < max) {
      if (!_parse(state, state.ch)) {
        break;
      }

      count++;
    }

    return count >= min;
  }

  @override
  ParseResult<List<int>>? parse(ParseState state) {
    final ch = state.ch;
    if (_parse(state, ch)) {
      final list = [ch];
      while (list.length < max) {
        final ch = state.ch;
        if (!_parse(state, ch)) {
          break;
        }

        list.add(ch);
      }

      if (list.length >= min) {
        return ParseResult(list);
      }
    }

    if (min == 0) {
      return const ParseResult([]);
    }
  }

  bool _parse(ParseState state, int ch) {
    for (var i = 0; i < ranges.length; i += 2) {
      if (ranges[i] <= ch) {
        if (ranges[i + 1] >= ch) {
          ParseState.nextChar(state);
          return true;
        }
      } else {
        break;
      }
    }

    return false;
  }
}
