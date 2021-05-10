part of '../../grammar_printer.dart';

class GrammarPrinter extends RecursiveExpressionVisitor<void> {
  final Set<Expression> _processed = {};

  final Set<ProductionRule> rules = {};

  void print(Grammar grammar, StringSink sink) {
    _processed.clear();
    rules.clear();
    final start = grammar.start;
    rules.add(start);
    start.expression.accept(this);
    final nonterminals =
        rules.where((e) => e.kind == ProductionRuleKind.nonterminal);
    final terminals = rules.where((e) => e.kind == ProductionRuleKind.terminal);
    final subterminals =
        rules.where((e) => e.kind == ProductionRuleKind.subterminal);

    sink.writeln('# Nonterminals');
    for (final rule in nonterminals) {
      _printRule(rule, sink);
    }

    sink.writeln('# Terminals');
    for (final rule in terminals) {
      _printRule(rule, sink);
    }
    sink.writeln('# Subterminals');
    for (final rule in subterminals) {
      _printRule(rule, sink);
    }
  }

  @override
  void visitNonterminalSymbol<E>(NonterminalSymbol<E> node) {
    _visitSymbol(node);
  }

  @override
  void visitOrderedChoice<E>(OrderedChoiceExpression<E> node) {
    if (!_processed.add(node)) {
      return;
    }

    super.visitOrderedChoice(node);
  }

  @override
  void visitSubterminalSymbol<E>(SubterminalSymbol<E> node) {
    _visitSymbol(node);
  }

  @override
  void visitTerminalSymbol<E>(TerminalSymbol<E> node) {
    _visitSymbol(node);
  }

  void _printRule(ProductionRule rule, StringSink sink) {
    sink.write(rule);
    sink.writeln(' =');
    final expression = rule.expression;
    final expressions = expression.expressions;
    for (var i = 0; i < expressions.length; i++) {
      final child = expressions[i];
      if (i == 0) {
        sink.write('  ');
      } else {
        sink.write('  / ');
      }

      sink.writeln(child);
    }

    sink.writeln('  ;');
    sink.writeln();
  }

  void _visitSymbol(SymbolExpression node) {
    rules.add(node.expression.rule!);
    node.expression.accept(this);
  }
}
