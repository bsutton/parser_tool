part of '../parsers.dart';

class NonterminalDebugParser<E> extends NonterminalParser<E> {
  NonterminalDebugParser(Parser<E> parser, String name, {String? source})
      : super(parser, name, source: source);

  @override
  bool fastParse(ParseState state) {
    state.enter(this);
    final result = super.fastParse(state);
    state.leave(this, result);
    return result;
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    state.enter(this);
    final result = super.parse(state);
    state.leave(this, result);
    return result;
  }
}

class NonterminalParser<E> extends ProductionRuleParser<E> {
  NonterminalParser(Parser<E> parser, String name, {String? source})
      : super(parser, name, source: source);

  @override
  bool fastParse(ParseState state) {
    return parser.fastParse(state);
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    return parser.parse(state);
  }
}

class PredictiveNonterminalDebugParser<E>
    extends PredictiveNonterminalParser<E> {
  PredictiveNonterminalDebugParser(
      Parser<E> parser, String name, List<String> temianals,
      {String? source})
      : super(parser, name, temianals, source: source);

  @override
  bool fastParse(ParseState state) {
    state.enter(this);
    final result = super.fastParse(state);
    state.leave(this, result);
    return result;
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    state.enter(this);
    final result = super.parse(state);
    state.leave(this, result);
    return result;
  }
}

class PredictiveNonterminalParser<E> extends NonterminalParser<E> {
  final List<String> terminals;

  PredictiveNonterminalParser(Parser<E> parser, String name, this.terminals,
      {String? source})
      : super(parser, name, source: source);

  @override
  bool fastParse(ParseState state) {
    if (!parser.fastParse(state)) {
      state.failAll(terminals, state.pos);
      return false;
    }

    return true;
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    final result = parser.parse(state);
    if (result == null) {
      state.failAll(terminals, state.pos);
      return null;
    }

    return result;
  }
}

abstract class ProductionRuleParser<E> extends Parser<E> {
  Parser<E> parser;

  final String name;

  ProductionRuleParser(this.parser, this.name, {String? source})
      : super(source: source);
}

class SubterminalDebugParser<E> extends SubterminalParser<E> {
  SubterminalDebugParser(Parser<E> parser, String name, {String? source})
      : super(parser, name, source: source);

  @override
  bool fastParse(ParseState state) {
    state.enter(this);
    final result = super.fastParse(state);
    state.leave(this, result);
    return result;
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    state.enter(this);
    final result = super.parse(state);
    state.leave(this, result);
    return result;
  }
}

class SubterminalParser<E> extends ProductionRuleParser<E> {
  SubterminalParser(Parser<E> parser, String name, {String? source})
      : super(parser, name, source: source);

  @override
  bool fastParse(ParseState state) {
    return parser.fastParse(state);
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    return parser.parse(state);
  }
}

class TerminalDebugParser<E> extends TerminalParser<E> {
  TerminalDebugParser(Parser<E> parser, String name, {String? source})
      : super(parser, name, source: source);

  @override
  bool fastParse(ParseState state) {
    state.enter(this);
    final result = super.fastParse(state);
    state.leave(this, result);
    return result;
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    state.enter(this);
    final result = super.parse(state);
    state.leave(this, result);
    return result;
  }
}

class TerminalParser<E> extends ProductionRuleParser<E> {
  TerminalParser(Parser<E> parser, String name, {String? source})
      : super(parser, name, source: source);

  @override
  bool fastParse(ParseState state) {
    if (!parser.fastParse(state)) {
      state.fail(name, state.pos);
      return false;
    }

    return true;
  }

  @override
  ParseResult<E>? parse(ParseState state) {
    final result = parser.parse(state);
    if (result == null) {
      state.fail(name, state.pos);
    }

    return result;
  }
}
