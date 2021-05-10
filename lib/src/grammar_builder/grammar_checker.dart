part of '../../grammar_builder.dart';

class GrammarChecker extends RecursiveExpressionVisitor<void> {
  Set<Expression> _processed = {};

  void check<E>(Grammar<E> grammar) {
    _processed = {};
    final start = grammar.start;
    final expression = start.expression;
    expression.accept(this);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _checkPlacement(node, false, [ProductionRuleKind.nonterminal], node);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    _checkPlacement(node, false, [ProductionRuleKind.nonterminal], node);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    _checkPlacement(node, false, [ProductionRuleKind.nonterminal], node);
  }

  @override
  void visitNonterminalSymbol<E>(NonterminalSymbol<E> node) {
    _checkPlacement(node, false,
        [ProductionRuleKind.subterminal, ProductionRuleKind.terminal], node);
    _checkPlacement(node, true, [ProductionRuleKind.nonterminal, null], node);
    _visitSymbol(node);
  }

  @override
  void visitOrderedChoice<E>(OrderedChoiceExpression<E> node) {
    if (!_processed.add(node)) {
      return;
    }

    final expressions = node.expressions;
    if (expressions.isEmpty) {
      throw StateError('Ordered choice does not contain any expression: $node');
    }

    for (var i = 0; i < expressions.length; i++) {
      final child = expressions[i];
      child.accept(this);
    }
  }

  @override
  void visitSubterminalSymbol<E>(SubterminalSymbol<E> node) {
    _checkPlacement(node, false, [ProductionRuleKind.nonterminal], node);
    _checkPlacement(node, true,
        [ProductionRuleKind.subterminal, ProductionRuleKind.terminal], node);
    _visitSymbol(node);
  }

  @override
  void visitTerminalSymbol<E>(TerminalSymbol<E> node) {
    _checkPlacement(node, true, [ProductionRuleKind.nonterminal], node);
    _visitSymbol(node);
  }

  void _checkPlacement(Expression node, bool inside,
      List<ProductionRuleKind?> placements, Expression expression) {
    final rule = node.rule;
    final contains = placements.contains(rule);
    if (inside && contains) {
      return;
    } else if (!contains) {
      return;
    }

    final sink = StringBuffer();
    sink.write('Expression ');
    sink.write(expression);

    sink.write('cannot be placed inside a ');
    switch (rule!.kind) {
      case ProductionRuleKind.nonterminal:
        sink.write('nonterminal ');
        break;
      case ProductionRuleKind.subterminal:
        sink.write('subterminal ');
        break;
      case ProductionRuleKind.terminal:
        sink.write('terminal ');
        break;
    }

    sink.write('production rule ');
    sink.write(rule.name);
  }

  void _visitSymbol(SymbolExpression node) {
    final expression = node.expression;
    final rule = expression.rule!;
    final expressions = expression.expressions;
    if (expressions.isEmpty) {
      throw StateError(
          '${rule.runtimeType} \'${rule.name}\' does not contain any expression');
    }

    visitOrderedChoice(expression);
  }
}
