part of '../../expressions.dart';

class OrderedChoiceExpression<E> extends Expression<E> {
  final List<SequenceExpression<E>> expressions = [];

  @override
  ExpressionKind get kind => ExpressionKind.orderedChoice;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitOrderedChoice(this);
  }

  @override
  String toString() {
    return expressions.map((e) => '$e').join(' / ');
  }

  @override
  void visitChildren<R>(ExpressionVisitor<R> visitor) {
    for (var i = 0; i < expressions.length; i++) {
      final child = expressions[i];
      child.accept(visitor);
    }
  }
}
