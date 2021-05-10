part of '../../expressions.dart';

class SequenceMiddleResultExpression<E> extends SequenceExpression<E> {
  final List<Expression> after;

  final List<Expression> before;

  final Expression<E> expression;

  SequenceMiddleResultExpression(this.before, this.expression, this.after)
      : super(UnmodifiableListView([...before, expression, ...after])) {
    if (before.isEmpty) {
      throw ArgumentError.value(before, 'before', 'Must not be empty');
    }

    if (after.isEmpty) {
      throw ArgumentError.value(after, 'after', 'Must not be empty');
    }
  }

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSequenceMiddleResult(this);
  }
}
