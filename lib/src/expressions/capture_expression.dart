part of '../../expressions.dart';

class CaptureExpression extends Expression<String> {
  final Expression expression;

  CaptureExpression(this.expression);

  @override
  ExpressionKind get kind => ExpressionKind.optional;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitCapture(this);
  }

  @override
  String toString() {
    return Expression.quote(expression, prefix: '<', suffix: '>');
  }

  @override
  void visitChildren<R>(ExpressionVisitor<R> visitor) {
    expression.accept(visitor);
  }
}
