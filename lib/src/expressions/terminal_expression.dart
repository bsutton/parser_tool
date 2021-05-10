part of '../../expressions.dart';

class Terminal<E> extends ProductionRuleExpression<E> {
  Terminal(String name) : super(name);

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitTerminal(this);
  }
}
