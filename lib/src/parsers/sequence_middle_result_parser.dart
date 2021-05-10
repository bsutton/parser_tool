part of '../parsers.dart';

class SequenceMiddleResultParser<E> extends Parser<E> {
  final List<Parser> after;

  final List<Parser> before;

  final Parser<E> parser;

  SequenceMiddleResultParser(this.before, this.parser, this.after,
      {String? source})
      : super(source: source);

  @override
  bool fastParse(ParseState state) {
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

    if (!parser.fastParse(state)) {
      state.pos = pos;
      state.ch = ch;
      return false;
    }

    if (after.length == 1) {
      final parser = after[0];
      if (!parser.fastParse(state)) {
        state.pos = pos;
        state.ch = ch;
        return false;
      }
    } else {
      for (var i = 0; i < after.length; i++) {
        final parser = after[i];
        if (!parser.fastParse(state)) {
          state.pos = pos;
          state.ch = ch;
          return false;
        }
      }
    }

    return true;
  }

  @override
  ParseResult<E>? parse(ParseState state) {
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
    if (result == null) {
      state.pos = pos;
      state.ch = ch;
      return null;
    }

    if (after.length == 1) {
      final parser = after[0];
      if (!parser.fastParse(state)) {
        state.pos = pos;
        state.ch = ch;
        return null;
      }
    } else {
      for (var i = 0; i < after.length; i++) {
        final parser = after[i];
        if (!parser.fastParse(state)) {
          state.pos = pos;
          state.ch = ch;
          return null;
        }
      }
    }

    return result;
  }
}
