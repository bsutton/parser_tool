part of '../../grammar_builder.dart';

class ExpressionInitializer extends ExpressionVisitor<void> {
  bool _hasModifications = false;

  void initialize(Grammar grammar) {
    final rules = grammar.rules;
    _hasModifications = true;
    while (_hasModifications) {
      _hasModifications = false;
      for (final rule in rules) {
        final expression = rule.expression;
        _setRule(expression, rule);
        expression.accept(this);
      }
    }
  }

  @override
  void visitAndPredicate(AndPredicateExpression node) {
    _visitSingle(node);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    //
  }

  @override
  void visitCapture(CaptureExpression node) {
    final child = node.expression;
    _setRule(child, node.rule);
    child.accept(this);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    //
  }

  @override
  void visitLiteral(LiteralExpression node) {
    //
  }

  @override
  void visitLocationalTransformer<I, O>(
      LocationalTransformerExpression<I, O> node) {
    _visitSingle(node);
  }

  @override
  void visitNonterminal<E>(Nonterminal<E> node) {
    throw UnsupportedError('visitNonterminal');
  }

  @override
  void visitNonterminalSymbol<E>(NonterminalSymbol<E> node) {
    _visitSymbol(node);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    _visitSingle(node);
  }

  @override
  void visitOneOrMore<E>(OneOrMoreExpression<E> node) {
    _visitSingle(node);
  }

  @override
  void visitOptional<E>(OptionalExpression<E> node) {
    _visitSingle(node);
  }

  @override
  void visitOrderedChoice<E>(OrderedChoiceExpression<E> node) {
    final rule = node.rule;
    final expressions = node.expressions;
    for (var i = 0; i < expressions.length; i++) {
      final child = expressions[i];
      _setRule(child, rule);
      child.accept(this);
    }
  }

  @override
  void visitPassiveSequence(PassiveSequenceExpression node) {
    _visitSequence(node);
  }

  @override
  void visitSequence2<E1, E2>(Sequence2Expression<E1, E2> node) {
    _visitSequence(node);
  }

  @override
  void visitSequence3<E1, E2, E3>(Sequence3Expression<E1, E2, E3> node) {
    _visitSequence(node);
  }

  @override
  void visitSequence4<E1, E2, E3, E4>(
      Sequence4Expression<E1, E2, E3, E4> node) {
    _visitSequence(node);
  }

  @override
  void visitSequence5<E1, E2, E3, E4, E5>(
      Sequence5Expression<E1, E2, E3, E4, E5> node) {
    _visitSequence(node);
  }

  @override
  void visitSequence6<E1, E2, E3, E4, E5, E6>(
      Sequence6Expression<E1, E2, E3, E4, E5, E6> node) {
    _visitSequence(node);
  }

  @override
  void visitSequence7<E1, E2, E3, E4, E5, E6, E7>(
      Sequence7Expression<E1, E2, E3, E4, E5, E6, E7> node) {
    _visitSequence(node);
  }

  @override
  void visitSequenceFirstLastResult<E1, E2>(
      SequenceFirstLastResultExpression<E1, E2> node) {
    _visitSequence(node);
  }

  @override
  void visitSequenceFirstResult<E>(SequenceFirstResultExpression<E> node) {
    _visitSequence(node);
  }

  @override
  void visitSequenceFixedResult<E>(SequenceFixedResultExpression<E> node) {
    _visitSequence(node);
  }

  @override
  void visitSequenceLastResult<E>(SequenceLastResultExpression<E> node) {
    _visitSequence(node);
  }

  @override
  void visitSequenceMiddleResult<E>(SequenceMiddleResultExpression<E> node) {
    _visitSequence(node);
  }

  @override
  void visitSubterminal<E>(Subterminal<E> node) {
    throw UnsupportedError('visitSubterminal');
  }

  @override
  void visitSubterminalSymbol<E>(SubterminalSymbol<E> node) {
    _visitSymbol(node);
  }

  @override
  void visitTerminal<E>(Terminal<E> node) {
    throw UnsupportedError('visitTerminal');
  }

  @override
  void visitTerminalSymbol<E>(TerminalSymbol<E> node) {
    _visitSymbol(node);
  }

  @override
  void visitTransformer<I, O>(TransformerExpression<I, O> node) {
    _visitSingle(node);
  }

  @override
  void visitZeroOrMore<E>(ZeroOrMoreExpression<E> node) {
    _visitSingle(node);
  }

  void _setRule(Expression node, ProductionRule? rule) {
    if (node.rule != rule) {
      _hasModifications = true;
      node.rule = rule;
    }
  }

  void _visitSequence(SequenceExpression node) {
    final rule = node.rule;
    final expressions = node.expressions;
    for (var i = 0; i < expressions.length; i++) {
      final child = expressions[i];
      _setRule(child, rule);
      child.accept(this);
    }
  }

  void _visitSingle(SingleExpression node) {
    final rule = node.rule;
    final child = node.expression;
    _setRule(child, rule);
    child.accept(this);
  }

  void _visitSymbol(SymbolExpression node) {
    //
  }
}
