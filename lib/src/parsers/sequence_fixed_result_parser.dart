part of '../parsers.dart';

class SequenceFixedResultParser<E> extends Parser<E> {
  final List<Parser> parsers;

  final ParseResult<E> result;

  SequenceFixedResultParser(this.parsers, E result, {String? source})
      : result = ParseResult(result),
        super(source: source);

  @override
  bool fastParse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    for (var i = 0; i < parsers.length; i++) {
      final parser = parsers[i];
      if (!parser.fastParse(state)) {
        state.pos = pos;
        state.ch = ch;
        return false;
      }
    }

    return true;
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    for (var i = 0; i < parsers.length; i++) {
      final parser = parsers[i];
      if (!parser.fastParse(state)) {
        state.pos = pos;
        state.ch = ch;
        return null;
      }
    }

    return result;
  }
}
