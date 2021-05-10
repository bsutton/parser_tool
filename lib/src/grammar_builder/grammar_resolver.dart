part of '../../grammar_builder.dart';

abstract class GrammarResolver extends ExpressionVisitor<void> {
  bool _hasModifications = false;

  void resolve(Grammar grammar) {
    final rules = grammar.rules;
    _hasModifications = true;
    while (_hasModifications) {
      _hasModifications = false;
      for (final rule in rules) {
        final expression = rule.expression;
        expression.accept(this);
      }
    }
  }
}
