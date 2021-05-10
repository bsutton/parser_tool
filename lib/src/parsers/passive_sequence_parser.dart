part of '../parsers.dart';

class PassiveSequenceParser extends Parser {
  final List<Parser> parsers;

  PassiveSequenceParser(this.parsers, {String? source}) : super(source: source);

  @override
  bool fastParse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    if (parsers.length == 2) {
      if (parsers[0].fastParse(state)) {
        if (parsers[1].fastParse(state)) {
          return true;
        }
      }

      state.pos = pos;
      state.ch = ch;
      return false;
    } else if (parsers.length == 3) {
      if (parsers[0].fastParse(state)) {
        if (parsers[1].fastParse(state)) {
          if (parsers[2].fastParse(state)) {
            return true;
          }
        }
      }

      state.pos = pos;
      state.ch = ch;
      return false;
    } else if (parsers.length == 4) {
      if (parsers[0].fastParse(state)) {
        if (parsers[1].fastParse(state)) {
          if (parsers[2].fastParse(state)) {
            if (parsers[3].fastParse(state)) {
              return true;
            }
          }
        }
      }

      state.pos = pos;
      state.ch = ch;
      return false;
    } else {
      for (var i = 0; i < parsers.length; i++) {
        final parser = parsers[i];
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
  ParseResult? parse(ParseState state) {
    if (fastParse(state)) {
      return const ParseResult(null);
    }
  }
}
