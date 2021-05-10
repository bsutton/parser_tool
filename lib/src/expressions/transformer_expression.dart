part of '../../expressions.dart';

class TransformerExpression<I, O> extends SingleExpression<I, O> {
  final O Function(I result) transform;

  TransformerExpression(Expression<I> expression, this.transform)
      : super(expression);

  @override
  ExpressionKind get kind => ExpressionKind.transformer;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitTransformer(this);
  }

  @override
  String toString() => '$expression';
}
