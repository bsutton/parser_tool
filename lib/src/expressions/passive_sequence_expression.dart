part of '../../expressions.dart';

class PassiveSequenceExpression extends SequenceExpression {
  PassiveSequenceExpression(List<Expression> expressions)
      : super(UnmodifiableListView(expressions));

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitPassiveSequence(this);
  }
}
