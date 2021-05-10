part of '../parsers.dart';

class GeneralRepeaterParser<E> extends RepeaterParser<E> {
  final Parser<E> parser;

  GeneralRepeaterParser(int min, int max, this.parser, {String? source})
      : super(min, max, source: source);

  @override
  bool fastParse(ParseState state) {
    var count = 0;
    while (count < max) {
      if (!parser.fastParse(state)) {
        break;
      }

      count++;
    }

    return count >= min;
  }

  @override
  ParseResult<List<E>>? parse(ParseState state) {
    final result = parser.parse(state);
    if (result != null) {
      final list = [result.value];
      while (list.length < max) {
        final result = parser.parse(state);
        if (result == null) {
          break;
        }

        list.add(result.value);
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

abstract class RepeaterParser<E> extends Parser<List<E>> {
  static const int maxValue = 0xffffffff;

  final int max;

  final int min;

  RepeaterParser(this.min, this.max, {String? source}) : super(source: source) {
    RangeError.checkValidRange(min, max, maxValue);
    if (max == 0) {
      throw ArgumentError.value(max, 'max', 'Must be greater than 0');
    }
  }
}
