part of '../../expressions.dart';

abstract class SingleExpression<I, O> extends Expression<O> {
  final Expression<I> expression;

  SingleExpression(this.expression);

  @override
  void visitChildren<R>(ExpressionVisitor<R> visitor) {
    expression.accept(visitor);
  }
}
