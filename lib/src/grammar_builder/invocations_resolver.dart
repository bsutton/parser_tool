part of '../../grammar_builder.dart';

class InvocationsResolver extends RecursiveExpressionVisitor {
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

  @override
  void visitNonterminalSymbol<E>(NonterminalSymbol<E> node) {
    _visit(node);
  }

  @override
  void visitSubterminalSymbol<E>(SubterminalSymbol<E> node) {
    _visit(node);
  }

  @override
  void visitTerminalSymbol<E>(TerminalSymbol<E> node) {
    _visit(node);
  }

  void _add<T>(Set<T> data, Iterable<T> elements) {
    for (final element in elements) {
      if (data.add(element)) {
        _hasModifications = true;
      }
    }
  }

  void _addCallees(
      ProductionRule rule, Iterable<ProductionRule> rules, bool direct) {
    if (direct) {
      _add(rule.directCallees, rules);
    }

    _add(rule.allCallees, rules);
  }

  void _addCallers(
      ProductionRule rule, Iterable<SymbolExpression> rules, bool direct) {
    if (direct) {
      _add(rule.directCallers, rules);
    }

    _add(rule.allCallers, rules);
  }

  void _visit(SymbolExpression node) {
    final caller = node;
    final callerRule = node.rule!;
    final calleeRule = node.expression.rule!;
    _addCallers(calleeRule, [caller], true);
    _addCallees(callerRule, [calleeRule], true);
    _addCallers(calleeRule, callerRule.allCallers, false);
    _addCallees(callerRule, calleeRule.allCallees, false);
  }
}
