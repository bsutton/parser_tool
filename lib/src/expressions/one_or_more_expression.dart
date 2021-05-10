part of '../../expressions.dart';

class OneOrMoreExpression<E> extends SuffixExpression<E, List<E>> {
  @override
  final String suffix = '+';

  OneOrMoreExpression(Expression<E> expression) : super(expression);

  @override
  ExpressionKind get kind => ExpressionKind.oneOrMore;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitOneOrMore(this);
  }
}
