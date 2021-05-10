part of '../parsers.dart';

class AnyCharacterParser extends Parser<int> {
  AnyCharacterParser({String? source}) : super(source: source);

  @override
  bool fastParse(ParseState state) {
    if (state.pos < state.length) {
      ParseState.nextChar(state);
      return true;
    }

    return false;
  }

  @override
  ParseResult<int>? parse(ParseState state) {
    if (state.pos < state.length) {
      final ch = state.ch;
      ParseState.nextChar(state);
      return ParseResult(ch);
    }
  }
}
