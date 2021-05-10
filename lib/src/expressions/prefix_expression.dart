part of '../../expressions.dart';

abstract class PrefixExpression<I, O> extends SingleExpression<I, O> {
  PrefixExpression(Expression<I> expression) : super(expression);

  String get prefix;

  @override
  String toString() {
    return Expression.quote(expression, prefix: prefix);
  }
}
