part of '../parsers.dart';

class DummyParseState extends ParseState {
  DummyParseState(ParseState state) : super(state.source, init: false) {
    ch = state.ch;
    pos = state.pos;
  }

  @override
  void fail(String name, int pos) {
    return;
  }
}

class ParseState {
  static const int eof = 1114112;

  int ch = 0;

  int failPos = 0;

  List<String> failures = [];

  final int length;

  int pos = 0;

  final String source;

  ParseState(this.source, {bool init = true}) : length = source.length {
    if (init) {
      getChar(this, 0);
    }
  }

  FormatException buildError({String? quote = '\''}) {
    quote ??= '';
    final sink = StringBuffer();
    final expected = getExpected();
    if (expected.isNotEmpty) {
      sink.write('Expected ');
      sink.write(expected.map((e) => e).join(', '));
    } else {
      sink.write('Unexpected ');
      if (failPos < pos) {
        sink.write('character');
      } else {
        sink.write('end of file');
      }
    }

    return FormatException(sink.toString(), source, failPos);
  }

  void enter(ProductionRuleParser parser) {
    return;
  }

  @pragma('vm:prefer-inline')
  void fail(String name, int pos) {
    if (failPos > pos) {
      return;
    }

    if (failPos < pos) {
      failPos = pos;
      failures = [];
    }

    failures.add(name);
  }

  @pragma('vm:prefer-inline')
  void failAll(List<String> names, int pos) {
    if (failPos > pos) {
      return;
    }

    if (failPos < pos) {
      failPos = pos;
      failures = [];
    }

    failures.addAll(names);
  }

  List<String> getExpected() {
    final result = Set<String>.from(failures).toList();
    result.sort();
    return result;
  }

  void leave(ProductionRuleParser parser, result) {
    return;
  }

  @override
  String toString() {
    final sink = StringBuffer();
    sink.write(pos);
    sink.write(':');
    if (pos < length) {
      var rest = length - pos;
      rest = rest > 24 ? 24 : rest;
      sink.write(source.substring(pos, pos + rest));
    }

    return sink.toString();
  }

  @preferInline
  static int getChar(ParseState state, int pos) {
    if (pos < state.length) {
      final ch = state.source.codeUnitAt(pos);
      state.ch = ch;
      if (ch < 0xD800) {
        return ch;
      }

      return getChar32(state, pos);
    }

    return state.ch = eof;
  }

  @preferInline
  static int getChar32(ParseState state, int pos) {
    var ch = state.ch;
    final source = state.source;
    if (ch >= 0xD800 && ch <= 0xDBFF) {
      if (pos + 1 < source.length) {
        final ch2 = source.codeUnitAt(pos + 1);
        if (ch2 >= 0xDC00 && ch2 <= 0xDFFF) {
          ch = ((ch - 0xD800) << 10) + (ch2 - 0xDC00) + 0x10000;
        } else {
          throw FormatException('Unpaired high surrogate', source, pos);
        }
      } else {
        throw FormatException('The source has been exhausted', source, pos);
      }
    } else {
      if (ch >= 0xDC00 && ch <= 0xDFFF) {
        throw FormatException(
            'UTF-16 surrogate values are illegal in UTF-32', source, pos);
      }
    }

    return state.ch = ch;
  }

  @preferInline
  static int nextChar(ParseState state) {
    var ch = state.ch;
    var pos = state.pos;
    pos += ch <= 0xffff ? 1 : 2;
    state.pos = pos;
    if (pos < state.length) {
      ch = state.source.codeUnitAt(pos);
      state.ch = ch;
      if (ch < 0xD800) {
        return ch;
      }

      return getChar32(state, pos);
    }

    return state.ch = eof;
  }
}
