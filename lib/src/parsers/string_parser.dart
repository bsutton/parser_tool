part of '../parsers.dart';

class CheckedShortStringParser extends Parser<String> {
  final int ch;

  final ParseResult<String> result;

  final String string;

  CheckedShortStringParser(this.string, this.ch, {String? source})
      : result = ParseResult(string),
        super(source: source);

  @override
  @preferInline
  bool fastParse(ParseState state) {
    ParseState.nextChar(state);
    return true;
  }

  @override
  @preferInline
  ParseResult<String>? parse(ParseState state) {
    ParseState.nextChar(state);
    return result;
  }
}

class EmptyStringParser extends Parser<String> {
  EmptyStringParser({String? source}) : super(source: source);

  @override
  @preferInline
  bool fastParse(ParseState state) {
    return true;
  }

  @override
  @preferInline
  ParseResult<String>? parse(ParseState state) {
    return const ParseResult('');
  }
}

class LongStringParser extends Parser<String> {
  final int ch;

  final int length;

  final ParseResult<String> result;

  final String string;

  LongStringParser(this.string, {String? source})
      : length = string.length,
        ch = string.codeUnitAt(0),
        result = ParseResult(string),
        super(source: source);

  @override
  @preferInline
  bool fastParse(ParseState state) {
    if (state.ch == ch) {
      if (state.source.startsWith(string, state.pos)) {
        state.pos += length;
        ParseState.getChar(state, state.pos);
        return true;
      }
    }

    return false;
  }

  @override
  @preferInline
  ParseResult<String>? parse(ParseState state) {
    if (state.ch == ch) {
      if (state.source.startsWith(string, state.pos)) {
        state.pos += length;
        ParseState.getChar(state, state.pos);
        return result;
      }
    }
  }
}

class ShortStringParser extends Parser<String> {
  final int ch;

  final ParseResult<String> result;

  final String string;

  ShortStringParser(this.string, this.ch, {String? source})
      : result = ParseResult(string),
        super(source: source);

  @override
  @preferInline
  bool fastParse(ParseState state) {
    if (state.ch == ch) {
      ParseState.nextChar(state);
      return true;
    }

    return false;
  }

  @override
  @preferInline
  ParseResult<String>? parse(ParseState state) {
    if (state.ch == ch) {
      ParseState.nextChar(state);
      return result;
    }
  }
}
