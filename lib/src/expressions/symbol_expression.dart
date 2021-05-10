part of '../../expressions.dart';

class NonterminalSymbol<E> extends SymbolExpression<E> {
  @override
  ExpressionKind get kind => ExpressionKind.nonterminal;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitNonterminalSymbol(this);
  }

  @override
  void visitChildren<R>(ExpressionVisitor<R> visitor) {
    //
  }
}

class SubterminalSymbol<E> extends SymbolExpression<E> {
  @override
  ExpressionKind get kind => ExpressionKind.subterminal;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSubterminalSymbol(this);
  }

  @override
  void visitChildren<R>(ExpressionVisitor<R> visitor) {
    //
  }
}

abstract class SymbolExpression<E> extends Expression<E> {
  OrderedChoiceExpression<E> expression = OrderedChoiceExpression();

  @override
  String toString() {
    final rule = expression.rule;
    return rule == null ? 'Unresolved' : '$rule';
  }
}

class TerminalSymbol<E> extends SymbolExpression<E> {
  @override
  ExpressionKind get kind => ExpressionKind.terminal;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitTerminalSymbol(this);
  }

  @override
  void visitChildren<R>(ExpressionVisitor<R> visitor) {
    //
  }
}
