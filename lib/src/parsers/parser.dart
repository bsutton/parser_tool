part of '../parsers.dart';

const preferInline = pragma('vm:prefer-inline');

class DummyParser<E> extends Parser<E> {
  @override
  bool fastParse(ParseState state) {
    throw UnsupportedError('fastParse');
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    throw UnsupportedError('parse');
  }
}

abstract class Parser<E> {
  final String? source;

  Parser({this.source});

  bool fastParse(ParseState state);

  RepeaterParser<E> getRepeater(int min, int max, {String? source}) {
    return GeneralRepeaterParser(min, max, this, source: source);
  }

  ParseResult<E>? parse(ParseState state);

  @override
  String toString() {
    if (source != null) {
      return source!;
    }

    return '$runtimeType';
  }
}
