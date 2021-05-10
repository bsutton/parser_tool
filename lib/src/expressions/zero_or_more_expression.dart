part of '../../expressions.dart';

class ZeroOrMoreExpression<E> extends SuffixExpression<E, List<E>> {
  @override
  final String suffix = '*';

  ZeroOrMoreExpression(Expression<E> expression) : super(expression);

  @override
  ExpressionKind get kind => ExpressionKind.zeroOrMore;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitZeroOrMore(this);
  }
}
