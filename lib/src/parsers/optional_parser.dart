part of '../parsers.dart';

class OptionalParser<E> extends Parser<E?> {
  final Parser<E> parser;

  OptionalParser(this.parser, {String? source}) : super(source: source);

  @override
  bool fastParse(ParseState state) {
    parser.fastParse(state);
    return true;
  }

  @override
  ParseResult<E?>? parse(ParseState state) {
    final result = parser.parse(state);
    if (result == null) {
      return const ParseResult(null);
    }

    return result;
  }
}
