part of '../../expressions.dart';

abstract class Expression<E> {
  static const int eof = maxUnicode + 1;

  static const int maxUnicode = 0x10ffff;

  static final SparseBoolList allCharacters = SparseBoolList()
    ..addGroup(GroupedRangeList(0, maxUnicode, true))
    ..freeze();

  static final SparseBoolList allCharactersWithEof = SparseBoolList()
    ..addGroup(GroupedRangeList(0, eof, true))
    ..freeze();

  bool isOptional = false;

  ProductionRule? rule;

  final SparseBoolList startCharacters = SparseBoolList();

  final Set<TerminalRule> startTerminals = {};

  ExpressionKind get kind;

  R accept<R>(ExpressionVisitor<R> visitor);

  TransformerExpression<E, O> map<O>(O Function(E) f) {
    return TransformerExpression(this, f);
  }

  void visitChildren<R>(ExpressionVisitor<R> visitor);

  static String quote(Expression expression,
      {String prefix = '', String suffix = ''}) {
    var result = '$expression';
    if (expression is SequenceExpression) {
      if (expression.expressions.length > 1) {
        result = '($result)';
      }
    } else if (expression is OrderedChoiceExpression) {
      if (expression.expressions.length > 1) {
        result = '($result)';
      }
    }

    return '$prefix$result$suffix';
  }
}

enum ExpressionKind {
  andPredicate,
  anyCharater,
  capture,
  characterClass,
  literal,
  location,
  nonterminal,
  notPredicate,
  oneOrMore,
  orderedChoice,
  optional,
  passive,
  sequence,
  subterminal,
  terminal,
  transformer,
  zeroOrMore
}
