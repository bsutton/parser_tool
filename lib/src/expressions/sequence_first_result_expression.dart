part of '../../expressions.dart';

class SequenceFirstResultExpression<E> extends SequenceExpression<E> {
  final List<Expression> after;

  final Expression<E> expression;

  SequenceFirstResultExpression(this.expression, this.after)
      : super(UnmodifiableListView([expression, ...after]));

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSequenceFirstResult(this);
  }
}
