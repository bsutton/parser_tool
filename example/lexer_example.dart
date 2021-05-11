import 'package:parser_tool/grammar.dart';
import 'package:parser_tool/grammar_builder.dart';
import 'package:parser_tool/grammar_compiler.dart';
import 'package:parser_tool/grammar_helpers.dart';

/// Demonstrates using a parser for tokenization (as a lexer)
void main() {
  final source = ' [ : ] , 1 99 ';
  final state = ParseState(source);
  final tokens = lexer.parse(state);
  if (tokens == null) {
    final failPos = state.failPos;
    throw FormatException('Syntax error', source, failPos);
  }

  print(tokens.value);
}

final grammar = _buildLexer();

final lexer = _compileLexer(grammar);

Grammar<List<Token>> _buildLexer() {
  final _ws = Subterminal('ws');

  Subterminal<Token> token(String name, TokenKind kind) {
    final terminal = Subterminal<Token>(name);
    terminal <<
        seqf(literal(name), [_ws]).locate((src, start, end, r) {
          return Token(
              kind: kind, name: name, source: name, start: start, end: end);
        });

    return terminal;
  }

  Subterminal<Token> tokenEx(
      String name, TokenKind kind, Expression expression) {
    final terminal = Subterminal<Token>(name);
    terminal <<
        seqf(capture(expression), [_ws]).locate((src, start, end, r) {
          return Token(
              kind: kind, name: name, source: r, start: start, end: end);
        });

    return terminal;
  }

  // Nonterminals
  final tokenizer = Nonterminal<List<Token>>('tokenizer');

  // Terminals
  final $eof = Terminal('end of file');
  final $leadingSpaces = Terminal('leading spaces');
  final $tokens = Terminal<List<Token>>('tokens');

  // Subterminals
  final _token = Subterminal<Token>('token');

  // Nonterminals
  tokenizer << seqm([$leadingSpaces], $tokens, [$eof]);

  // Terminals
  $eof << not(any());
  $leadingSpaces << _ws;
  $tokens << rep(_token);

  // Subterminals
  _token << token(',', TokenKind.comma);
  _token << token('[', TokenKind.lbracket);
  _token << token(']', TokenKind.lbracket);
  _token << token(':', TokenKind.semicolon);
  _token <<
      tokenEx('integer', TokenKind.integer, cap(rep1('0-9'.r)))
          .map((r) => ValueToken.from(r, int.parse(r.source)));

  _ws << rep(r' \n\r\t'.r);

  final builder = GrammarBuilder();
  return builder.build(tokenizer);
}

Parser<E> _compileLexer<E>(Grammar<E> grammar) {
  final compiler = GrammarCompiler<E>();
  return compiler.compile(grammar);
}

class Token {
  final int end;

  final TokenKind kind;

  final String name;

  final String source;

  final int start;

  Token(
      {required this.end,
      required this.kind,
      required this.name,
      required this.source,
      required this.start});

  @override
  String toString() => name;
}

enum TokenKind { comma, integer, lbracket, rbracket, semicolon, string }

class ValueToken<E> extends Token {
  final E value;

  ValueToken(this.value,
      {required int end,
      required TokenKind kind,
      required String name,
      required String source,
      required int start})
      : super(end: end, kind: kind, name: name, source: source, start: start);

  ValueToken.from(Token other, E value)
      : this(value,
            end: other.end,
            kind: other.kind,
            name: other.name,
            start: other.start,
            source: other.source);
}
