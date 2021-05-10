part of '../../grammar.dart';

class NonterminalRule<E> extends ProductionRule<E> {
  NonterminalRule(String name) : super(name);

  @override
  ProductionRuleKind get kind => ProductionRuleKind.nonterminal;
}

abstract class ProductionRule<E> {
  final Set<ProductionRule> allCallees = {};

  final Set<SymbolExpression> allCallers = {};

  final Set<ProductionRule> directCallees = {};

  final Set<SymbolExpression> directCallers = {};

  OrderedChoiceExpression<E> expression = OrderedChoiceExpression();

  final String name;

  ProductionRule(this.name);

  ProductionRuleKind get kind;

  @override
  String toString() => name;
}

enum ProductionRuleKind { nonterminal, terminal, subterminal }

class SubterminalRule<E> extends ProductionRule<E> {
  SubterminalRule(String name) : super('@$name');

  @override
  ProductionRuleKind get kind => ProductionRuleKind.subterminal;
}

class TerminalRule<E> extends ProductionRule<E> {
  TerminalRule(String name) : super('\'$name\'');

  @override
  ProductionRuleKind get kind => ProductionRuleKind.terminal;
}
