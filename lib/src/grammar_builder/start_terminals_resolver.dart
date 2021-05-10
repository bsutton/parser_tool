part of '../../grammar_builder.dart';

class ExpressionStartTerminalsResolver extends GrammarResolver {
  @override
  void visitAndPredicate(AndPredicateExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitCapture(CaptureExpression node) {
    final child = node.expression;
    child.accept(this);
    _addTerminals(node, child.startTerminals);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitLocationalTransformer<I, O>(
      LocationalTransformerExpression<I, O> node) {
    final child = node.expression;
    child.accept(this);
    _addTerminals(node, child.startTerminals);
  }

  @override
  void visitNonterminal<E>(Nonterminal<E> node) {
    throw UnsupportedError('visitNonterminal');
  }

  @override
  void visitNonterminalSymbol<E>(NonterminalSymbol<E> node) {
    final expression = node.expression;
    _addTerminals(node, expression.startTerminals);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitOneOrMore<E>(OneOrMoreExpression<E> node) {
    final child = node.expression;
    child.accept(this);
    _addTerminals(node, child.startTerminals);
  }

  @override
  void visitOptional<E>(OptionalExpression<E> node) {
    final child = node.expression;
    child.accept(this);
    _addTerminals(node, child.startTerminals);
  }

  @override
  void visitOrderedChoice<E>(OrderedChoiceExpression<E> node) {
    final expressions = node.expressions;
    final length = expressions.length;
    for (var i = 0; i < length; i++) {
      final child = expressions[i];
      child.accept(this);
      _addTerminals(node, child.startTerminals);
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
    //
  }

  @override
  void visitTerminal<E>(Terminal<E> node) {
    throw UnsupportedError('visitTerminal');
  }

  @override
  void visitTerminalSymbol<E>(TerminalSymbol<E> node) {
    final expression = node.expression;
    final rule = expression.rule!;
    _addTerminals(node, [rule as TerminalRule]);
  }

  @override
  void visitTransformer<I, O>(TransformerExpression<I, O> node) {
    final child = node.expression;
    child.accept(this);
    _addTerminals(node, child.startTerminals);
  }

  @override
  void visitZeroOrMore<E>(ZeroOrMoreExpression<E> node) {
    final child = node.expression;
    child.accept(this);
    _addTerminals(node, child.startTerminals);
  }

  void _addTerminals(Expression node, Iterable<TerminalRule> terminals) {
    final startTerminals = node.startTerminals;
    for (final terminal in terminals) {
      if (startTerminals.add(terminal)) {
        _hasModifications = true;
      }
    }
  }

  void _visitSequence(SequenceExpression node) {
    final expressions = node.expressions;
    final length = expressions.length;
    var skip = false;
    for (var i = 0; i < length; i++) {
      final child = expressions[i];
      child.accept(this);
      if (!skip && !child.isOptional) {
        _addTerminals(node, child.startTerminals);
      }

      if (!child.isOptional) {
        skip = true;
      }
    }
  }
}
