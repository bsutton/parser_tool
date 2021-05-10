part of '../../expressions.dart';

class OptionalExpression<E> extends SuffixExpression<E, E?> {
  @override
  final String suffix = '?';

  OptionalExpression(Expression<E> expression) : super(expression);

  @override
  ExpressionKind get kind => ExpressionKind.optional;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitOptional(this);
  }
}
