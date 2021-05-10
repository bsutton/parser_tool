part of '../../expressions.dart';

abstract class SuffixExpression<I, O> extends SingleExpression<I, O> {
  SuffixExpression(Expression<I> expression) : super(expression);

  String get suffix;

  @override
  String toString() {
    return Expression.quote(expression, suffix: suffix);
  }
}
