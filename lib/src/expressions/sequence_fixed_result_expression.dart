part of '../../expressions.dart';

class SequenceFixedResultExpression<E> extends SequenceExpression<E> {
  final E result;

  SequenceFixedResultExpression(List<Expression> expressions, this.result)
      : super(UnmodifiableListView(expressions));

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSequenceFixedResult(this);
  }
}
