part of '../parsers.dart';

class SequenceFirstResultParser<E> extends Parser<E> {
  final List<Parser> after;

  final Parser<E> parser;

  SequenceFirstResultParser(this.parser, this.after, {String? source})
      : super(source: source);

  @override
  bool fastParse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    if (parser.fastParse(state)) {
      if (after.length == 1) {
        final parser = after[0];
        if (!parser.fastParse(state)) {
          state.pos = pos;
          state.ch = ch;
          return false;
        }
      } else if (after.isNotEmpty) {
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

    state.pos = pos;
    state.ch = ch;
    return false;
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    final result = parser.parse(state);
    if (result != null) {
      if (after.length == 1) {
        final parser = after[0];
        if (!parser.fastParse(state)) {
          state.pos = pos;
          state.ch = ch;
          return null;
        }
      } else if (after.isNotEmpty) {
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

    state.pos = pos;
    state.ch = ch;
  }
}
