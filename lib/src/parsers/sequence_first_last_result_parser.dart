part of '../parsers.dart';

class SequenceFirstLastResultParser<E1, E2> extends Parser<Tuple2<E1, E2>> {
  final Parser<E1> first;

  final Parser<E2> last;

  final List<Parser> middle;

  SequenceFirstLastResultParser(this.first, this.middle, this.last,
      {String? source})
      : super(source: source);

  @override
  bool fastParse(ParseState state) => _fastParse(state, first, middle, last);

  @override
  SequenceFirstLastResultRepeaterParser<E1, E2> getRepeater(int min, int max,
      {String? source}) {
    return SequenceFirstLastResultRepeaterParser(min, max, first, middle, last,
        source: source);
  }

  @override
  ParseResult<Tuple2<E1, E2>>? parse(ParseState state) =>
      _parse(state, first, middle, last);

  @preferInline
  static bool _fastParse<E1, E2>(ParseState state, Parser<E1> first,
      List<Parser> middle, Parser<E2> last) {
    final ch = state.ch;
    final pos = state.pos;
    if (first.fastParse(state)) {
      if (middle.length == 1) {
        final parser = middle[0];
        if (!parser.fastParse(state)) {
          state.pos = pos;
          state.ch = ch;
          return false;
        }
      } else {
        for (var i = 0; i < middle.length; i++) {
          final parser = middle[i];
          if (!parser.fastParse(state)) {
            state.pos = pos;
            state.ch = ch;
            return false;
          }
        }
      }

      if (last.fastParse(state)) {
        return true;
      }
    }

    state.pos = pos;
    state.ch = ch;
    return false;
  }

  @preferInline
  static ParseResult<Tuple2<E1, E2>>? _parse<E1, E2>(ParseState state,
      Parser<E1> first, List<Parser> middle, Parser<E2> last) {
    final ch = state.ch;
    final pos = state.pos;
    final r1 = first.parse(state);
    if (r1 != null) {
      if (middle.length == 1) {
        final parser = middle[0];
        if (!parser.fastParse(state)) {
          state.pos = pos;
          state.ch = ch;
          return null;
        }
      } else {
        for (var i = 0; i < middle.length; i++) {
          final parser = middle[i];
          if (!parser.fastParse(state)) {
            state.pos = pos;
            state.ch = ch;
            return null;
          }
        }
      }

      final r2 = last.parse(state);
      if (r2 != null) {
        return ParseResult(Tuple2(r1.value, r2.value));
      }
    }

    state.pos = pos;
    state.ch = ch;
  }
}

class SequenceFirstLastResultRepeaterParser<E1, E2>
    extends RepeaterParser<Tuple2<E1, E2>> {
  final Parser<E1> first;

  final Parser<E2> last;

  final List<Parser> middle;

  SequenceFirstLastResultRepeaterParser(
      int min, int max, this.first, this.middle, this.last,
      {String? source})
      : super(min, max, source: source);

  @override
  bool fastParse(ParseState state) {
    var count = 0;
    while (count < max) {
      if (!SequenceFirstLastResultParser._fastParse(
          state, first, middle, last)) {
        break;
      }

      count++;
    }

    return count >= min;
  }

  @override
  ParseResult<List<Tuple2<E1, E2>>>? parse(ParseState state) {
    final result =
        SequenceFirstLastResultParser._parse(state, first, middle, last);
    if (result != null) {
      final list = [result.value];
      while (list.length < max) {
        final result =
            SequenceFirstLastResultParser._parse(state, first, middle, last);
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
