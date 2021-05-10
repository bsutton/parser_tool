part of '../../expressions.dart';

abstract class ProductionRuleExpression<T> extends OrderedChoiceExpression<T> {
  final String name;

  ProductionRuleExpression(this.name);

  @override
  String toString() => name;
}
