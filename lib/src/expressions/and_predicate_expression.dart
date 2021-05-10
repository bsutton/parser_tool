part of '../../expressions.dart';

class AndPredicateExpression extends PrefixExpression {
  @override
  final String prefix = '&';

  AndPredicateExpression(Expression expression) : super(expression);

  @override
  ExpressionKind get kind => ExpressionKind.andPredicate;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitAndPredicate(this);
  }
}
