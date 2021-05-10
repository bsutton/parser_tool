part of '../../expressions.dart';

class NotPredicateExpression extends PrefixExpression {
  @override
  final String prefix = '!';

  NotPredicateExpression(Expression expression) : super(expression);

  @override
  ExpressionKind get kind => ExpressionKind.notPredicate;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitNotPredicate(this);
  }
}
