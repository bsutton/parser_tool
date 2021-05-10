part of '../parsers.dart';

class NotPredicateParser extends Parser {
  final Parser parser;

  NotPredicateParser(this.parser, {String? source}) : super(source: source);

  @override
  bool fastParse(ParseState state) {
    return !parser.fastParse(DummyParseState(state));
  }

  @override
  ParseResult? parse(ParseState state) {
    if (!parser.fastParse(DummyParseState(state))) {
      return const ParseResult(null);
    }
  }
}
