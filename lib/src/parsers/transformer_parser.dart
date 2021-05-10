part of '../parsers.dart';

class FixedResultTransformerParser<E> extends Parser<E> {
  final Parser parser;

  final ParseResult<E> result;

  FixedResultTransformerParser(this.parser, E result, {String? source})
      : result = ParseResult(result),
        super(source: source);

  @override
  @preferInline
  bool fastParse(ParseState state) {
    return parser.fastParse(state);
  }

  @override
  @preferInline
  ParseResult<E>? parse(ParseState state) {
    if (parser.fastParse(state)) {
      return result;
    }
  }
}

class LocationalTransformerParser<I, O> extends Parser<O> {
  final Parser<I> parser;

  final O Function(String source, int start, int end, I result) transform;

  LocationalTransformerParser(this.parser, this.transform, {String? source})
      : super(source: source);

  @override
  @preferInline
  bool fastParse(ParseState state) {
    parser.fastParse(state);
    return true;
  }

  @override
  LocationalTransformerRepeaterParser<I, O> getRepeater(int min, int max,
      {String? source}) {
    return LocationalTransformerRepeaterParser(min, max, parser, transform,
        source: source);
  }

  @override
  @preferInline
  ParseResult<O>? parse(ParseState state) {
    final start = state.pos;
    final result = parser.parse(state);
    if (result != null) {
      final r = transform(state.source, start, state.pos, result.value);
      return ParseResult(r);
    }
  }
}

class LocationalTransformerRepeaterParser<I, O> extends RepeaterParser<O> {
  final Parser<I> parser;

  final O Function(String source, int start, int end, I result) transform;

  LocationalTransformerRepeaterParser(
      int min, int max, this.parser, this.transform,
      {String? source})
      : super(min, max, source: source);

  @override
  bool fastParse(ParseState state) {
    var count = 0;
    while (count < max) {
      if (!parser.fastParse(state)) {
        break;
      }

      count++;
    }

    return count >= min;
  }

  @override
  ParseResult<List<O>>? parse(ParseState state) {
    final start = state.pos;
    final r1 = parser.parse(state);
    if (r1 != null) {
      final r2 = transform(state.source, start, state.pos, r1.value);
      final list = [r2];
      while (list.length < max) {
        final start = state.pos;
        final r1 = parser.parse(state);
        if (r1 == null) {
          break;
        }

        final r2 = transform(state.source, start, state.pos, r1.value);
        list.add(r2);
      }

      if (list.length >= min) {
        return ParseResult(list);
      }

      return null;
    }

    if (min == 0) {
      return const ParseResult([]);
    }
  }
}

class TransformerParser<I, O> extends Parser<O> {
  final Parser<I> parser;

  final O Function(I result) transform;

  TransformerParser(this.parser, this.transform, {String? source})
      : super(source: source);

  @override
  @preferInline
  bool fastParse(ParseState state) {
    parser.fastParse(state);
    return true;
  }

  @override
  TransformerRepeaterParser<I, O> getRepeater(int min, int max,
      {String? source}) {
    return TransformerRepeaterParser(min, max, parser, transform,
        source: source);
  }

  @override
  @preferInline
  ParseResult<O>? parse(ParseState state) {
    final result = parser.parse(state);
    if (result != null) {
      final r = transform(result.value);
      return ParseResult(r);
    }
  }
}

class TransformerRepeaterParser<I, O> extends RepeaterParser<O> {
  final Parser<I> parser;

  final O Function(I result) transform;

  TransformerRepeaterParser(int min, int max, this.parser, this.transform,
      {String? source})
      : super(min, max, source: source);

  @override
  bool fastParse(ParseState state) {
    var count = 0;
    while (count < max) {
      if (!parser.fastParse(state)) {
        break;
      }

      count++;
    }

    return count >= min;
  }

  @override
  ParseResult<List<O>>? parse(ParseState state) {
    final r1 = parser.parse(state);
    if (r1 != null) {
      final r2 = transform(r1.value);
      final list = [r2];
      while (list.length < max) {
        final r1 = parser.parse(state);
        if (r1 == null) {
          break;
        }

        final r2 = transform(r1.value);
        list.add(r2);
      }

      if (list.length >= min) {
        return ParseResult(list);
      }

      return null;
    }

    if (min == 0) {
      return const ParseResult([]);
    }
  }
}
