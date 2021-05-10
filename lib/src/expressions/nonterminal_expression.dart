part of '../../expressions.dart';

class Nonterminal<E> extends ProductionRuleExpression<E> {
  Nonterminal(String name) : super(name);

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitNonterminal(this);
  }
}
