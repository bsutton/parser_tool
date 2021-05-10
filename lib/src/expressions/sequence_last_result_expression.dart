part of '../../expressions.dart';

class SequenceLastResultExpression<E> extends SequenceExpression<E> {
  final List<Expression> before;

  final Expression<E> expression;

  SequenceLastResultExpression(this.before, this.expression)
      : super(UnmodifiableListView([...before, expression])) {
    if (before.isEmpty) {
      throw ArgumentError.value(before, 'before', 'Must not be empty');
    }
  }

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSequenceLastResult(this);
  }
}
