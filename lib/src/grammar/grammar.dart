part of '../../grammar.dart';

class Grammar<E> {
  final NonterminalRule<E> start;

  final List<ProductionRule> rules;

  Grammar(this.rules, this.start);
}
