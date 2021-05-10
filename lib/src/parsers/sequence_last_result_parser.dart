part of '../parsers.dart';

class SequenceLastResultParser<E> extends Parser<E> {
  final List<Parser> before;

  final Parser<E> parser;

  SequenceLastResultParser(this.before, this.parser, {String? source})
      : super(source: source);

  @override
  bool fastParse(ParseState state) => _fastParse(state, before, parser);

  @override
  SequenceLastResultRepeaterParser<E> getRepeater(int min, int max,
      {String? source}) {
    return SequenceLastResultRepeaterParser(min, max, before, parser,
        source: source);
  }

  @override
  ParseResult<E>? parse(ParseState state) => _parse(state, before, parser);

  @preferInline
  static bool _fastParse<E>(
      ParseState state, List<Parser> before, Parser<E> parser) {
    final ch = state.ch;
    final pos = state.pos;
    if (before.length == 1) {
      final parser = before[0];
      if (!parser.fastParse(state)) {
        state.pos = pos;
        state.ch = ch;
        return false;
      }
    } else {
      for (var i = 0; i < before.length; i++) {
        final parser = before[i];
        if (!parser.fastParse(state)) {
          state.pos = pos;
          state.ch = ch;
          return false;
        }
      }
    }

    if (parser.fastParse(state)) {
      return true;
    }

    state.pos = pos;
    state.ch = ch;
    return false;
  }

  @preferInline
  static ParseResult<E>? _parse<E>(
      ParseState state, List<Parser> before, Parser<E> parser) {
    final ch = state.ch;
    final pos = state.pos;
    if (before.length == 1) {
      final parser = before[0];
      if (!parser.fastParse(state)) {
        state.pos = pos;
        state.ch = ch;
        return null;
      }
    } else {
      for (var i = 0; i < before.length; i++) {
        final parser = before[i];
        if (!parser.fastParse(state)) {
          state.pos = pos;
          state.ch = ch;
          return null;
        }
      }
    }

    final result = parser.parse(state);
    if (result != null) {
      return result;
    }

    state.pos = pos;
    state.ch = ch;
  }
}

class SequenceLastResultRepeaterParser<E> extends RepeaterParser<E> {
  final List<Parser> before;

  final Parser<E> parser;

  SequenceLastResultRepeaterParser(int min, int max, this.before, this.parser,
      {String? source})
      : super(min, max, source: source);

  @override
  bool fastParse(ParseState state) {
    var count = 0;
    while (count < max) {
      if (!SequenceLastResultParser._fastParse(state, before, parser)) {
        break;
      }

      count++;
    }

    return count >= min;
  }

  @override
  ParseResult<List<E>>? parse(ParseState state) {
    final result = SequenceLastResultParser._parse(state, before, parser);
    if (result != null) {
      final list = [result.value];
      while (list.length < max) {
        final result = SequenceLastResultParser._parse(state, before, parser);
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
