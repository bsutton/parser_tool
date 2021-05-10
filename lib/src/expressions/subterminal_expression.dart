part of '../../expressions.dart';

class Subterminal<E> extends ProductionRuleExpression<E> {
  Subterminal(String name) : super(name);

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSubterminal(this);
  }
}
