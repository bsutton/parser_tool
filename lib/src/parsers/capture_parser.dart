part of '../parsers.dart';

class CaptureParser extends Parser<String> {
  final Parser parser;

  CaptureParser(this.parser, {String? source}) : super(source: source);

  @override
  bool fastParse(ParseState state) {
    return parser.fastParse(state);
  }

  @override
  ParseResult<String>? parse(ParseState state) {
    final start = state.pos;
    if (parser.fastParse(state)) {
      final result = state.source.substring(start, state.pos);
      return ParseResult(result);
    }
  }
}
