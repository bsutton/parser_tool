part of '../../expressions.dart';

class SequenceFirstLastResultExpression<E1, E2>
    extends SequenceExpression<Tuple2<E1, E2>> {
  final Expression<E1> first;

  final Expression<E2> last;

  final List<Expression> middle;

  SequenceFirstLastResultExpression(this.first, this.middle, this.last)
      : super(UnmodifiableListView([first, ...middle, last])) {
    if (middle.isEmpty) {
      throw ArgumentError.value(middle, 'middle', 'Must not be empty');
    }
  }

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSequenceFirstLastResult(this);
  }
}
