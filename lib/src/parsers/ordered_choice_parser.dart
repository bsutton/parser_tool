part of '../parsers.dart';

@preferInline
int _getState(List<int> ranges, int ch) {
  final n = ranges.length >> 1;
  var s = -1;
  if (n == 1) {
    if (ch >= ranges[0] && ch <= ranges[1]) {
      s = 0;
    }
  } else if (n == 2) {
    if (ch >= ranges[0] && ch <= ranges[3]) {
      if (ch <= ranges[1]) {
        s = 0;
      } else if (ch >= ranges[2]) {
        s = 1;
      }
    }
  } else if (n == 3) {
    if (ch >= ranges[0] && ch <= ranges[1]) {
      s = 0;
    } else if (ch >= ranges[2] && ch <= ranges[3]) {
      s = 1;
    } else if (ch >= ranges[4] && ch <= ranges[5]) {
      s = 2;
    }
  } else if (n == 4) {
    if (ch >= ranges[0] && ch <= ranges[7]) {
      if (ch <= ranges[1]) {
        s = 0;
      } else if (ch >= ranges[6]) {
        s = 3;
      } else if (ch >= ranges[2] && ch <= ranges[5]) {
        if (ch <= ranges[3]) {
          s = 1;
        } else if (ch >= ranges[4]) {
          s = 2;
        }
      }
    }
  } else {
    var low = 0;
    var high = n - 1;
    while (low <= high) {
      final mid = (low + high) >> 1;
      final i = mid << 1;
      if (ch > ranges[i + 1]) {
        low = mid + 1;
      } else {
        if (ch >= ranges[i]) {
          s = mid;
          break;
        }

        if (high == mid) {
          break;
        }

        high = mid;
      }
    }
  }

  return s;
}

class OrderedChoiceParser<E> extends Parser<E> {
  final int length;

  final List<Parser<E>> parsers;

  OrderedChoiceParser(this.parsers, {String? source})
      : length = parsers.length,
        super(source: source);

  @override
  bool fastParse(ParseState state) {
    for (var i = 0; i < length; i++) {
      final parser = parsers[i];
      if (parser.fastParse(state)) {
        return true;
      }
    }

    return false;
  }

  @override
  OrderedChoiceRepeaterParser<E> getRepeater(int min, int max,
      {String? source}) {
    return OrderedChoiceRepeaterParser(min, max, parsers, source: source);
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    for (var i = 0; i < length; i++) {
      final parser = parsers[i];
      final result = parser.parse(state);
      if (result != null) {
        return result;
      }
    }
  }
}

class OrderedChoiceRepeaterParser<E> extends RepeaterParser<E> {
  final int length;

  final List<Parser<E>> parsers;

  OrderedChoiceRepeaterParser(int min, int max, this.parsers, {String? source})
      : length = parsers.length,
        super(min, max, source: source);

  @override
  bool fastParse(ParseState state) {
    var count = 0;
    loop:
    while (count < max) {
      for (var i = 0; i < length; i++) {
        final parser = parsers[i];
        if (parser.fastParse(state)) {
          count++;
          continue loop;
        }
      }

      break;
    }

    return count >= max;
  }

  @override
  ParseResult<List<E>>? parse(ParseState state) {
    final list = <E>[];
    loop:
    while (list.length < max) {
      for (var i = 0; i < length; i++) {
        final parser = parsers[i];
        final result = parser.parse(state);
        if (result != null) {
          list.add(result.value);
          continue loop;
        }
      }

      break;
    }

    if (list.length >= min) {
      return ParseResult(list);
    }
  }
}

class PredictiveOrderedChoiceParser<E> extends Parser<E> {
  final List<Parser<E>> parsers;

  final List<int> ranges;

  final List<List<int>> transitions;

  PredictiveOrderedChoiceParser(this.parsers, this.ranges, this.transitions,
      {String? source})
      : super(source: source);

  @override
  bool fastParse(ParseState state) {
    final s = _getState(ranges, state.ch);
    if (s >= 0) {
      final states = transitions[s];
      if (states.length == 1) {
        final index = states[0];
        final parser = parsers[index];
        return parser.fastParse(state);
      } else {
        for (var j = 0; j < states.length; j++) {
          final index = states[j];
          final parser = parsers[index];
          if (parser.fastParse(state)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  @override
  PredictiveOrderedChoiceRepeaterParser<E> getRepeater(int min, int max,
      {String? source}) {
    return PredictiveOrderedChoiceRepeaterParser(
        min, max, parsers, ranges, transitions,
        source: source);
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    final s = _getState(ranges, state.ch);
    if (s >= 0) {
      final states = transitions[s];
      if (states.length == 1) {
        final index = states[0];
        final parser = parsers[index];
        return parser.parse(state);
      } else {
        for (var j = 0; j < states.length; j++) {
          final index = states[j];
          final parser = parsers[index];
          final result = parser.parse(state);
          if (result != null) {
            return result;
          }
        }
      }
    }
  }
}

class PredictiveOrderedChoiceRepeaterParser<E> extends RepeaterParser<E> {
  final List<Parser<E>> parsers;

  final List<int> ranges;

  final List<List<int>> transitions;

  PredictiveOrderedChoiceRepeaterParser(
      int min, int max, this.parsers, this.ranges, this.transitions,
      {String? source})
      : super(min, max, source: source);

  @override
  bool fastParse(ParseState state) {
    var count = 0;
    loop:
    while (count < max) {
      final s = _getState(ranges, state.ch);
      if (s >= 0) {
        final states = transitions[s];
        if (states.length == 1) {
          final index = states[0];
          final parser = parsers[index];
          if (!parser.fastParse(state)) {
            break;
          }
        } else {
          for (var j = 0; j < states.length; j++) {
            final index = states[j];
            final parser = parsers[index];
            if (!parser.fastParse(state)) {
              break loop;
            }
          }
        }
      } else {
        break;
      }

      count++;
    }

    return count >= min;
  }

  @override
  ParseResult<List<E>>? parse(ParseState state) {
    final list = <E>[];
    loop:
    while (list.length < max) {
      final s = _getState(ranges, state.ch);
      if (s >= 0) {
        final states = transitions[s];
        if (states.length == 1) {
          final index = states[0];
          final parser = parsers[index];
          final result = parser.parse(state);
          if (result == null) {
            break;
          }

          list.add(result.value);
        } else {
          for (var j = 0; j < states.length; j++) {
            final index = states[j];
            final parser = parsers[index];
            final result = parser.parse(state);
            if (result == null) {
              break loop;
            }

            list.add(result.value);
          }
        }
      } else {
        break;
      }
    }

    if (list.length >= min) {
      return ParseResult(list);
    }
  }
}
