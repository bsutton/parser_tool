part of '../../expressions.dart';

class LocationalTransformerExpression<I, O> extends SingleExpression<I, O> {
  final O Function(String source, int start, int end, I result) transform;

  LocationalTransformerExpression(Expression<I> expression, this.transform)
      : super(expression);

  @override
  ExpressionKind get kind => ExpressionKind.location;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitLocationalTransformer(this);
  }

  @override
  String toString() => '$expression';

  @override
  void visitChildren<R>(ExpressionVisitor<R> visitor) {
    expression.accept(visitor);
  }
}
