part of '../../grammar_builder.dart';

class OptionalExpressionResolver extends GrammarResolver {
  @override
  void visitAndPredicate(AndPredicateExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, false);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _setIsOptional(node, false);
  }

  @override
  void visitCapture(CaptureExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    _setIsOptional(node, false);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    _setIsOptional(node, false);
  }

  @override
  void visitLocationalTransformer<I, O>(
      LocationalTransformerExpression<I, O> node) {
    _visitSingle(node);
  }

  @override
  void visitNonterminal<E>(Nonterminal<E> node) {
    throw UnimplementedError('visitNonterminal');
  }

  @override
  void visitNonterminalSymbol<E>(NonterminalSymbol<E> node) {
    _visitSymbol(node);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, false);
  }

  @override
  void visitOneOrMore<E>(OneOrMoreExpression<E> node) {
    _visitSingle(node);
  }

  @override
  void visitOptional<E>(OptionalExpression<E> node) {
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, true);
  }

  @override
  void visitOrderedChoice<E>(OrderedChoiceExpression<E> node) {
    final expressions = node.expressions;
    final length = expressions.length;
    for (var i = 0; i < length; i++) {
      final child = expressions[i];
      child.accept(this);
    }

    final isOptional = expressions.where((e) => e.isOptional).isNotEmpty;
    _setIsOptional(node, isOptional);
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
    throw UnimplementedError('visitSubterminal');
  }

  @override
  void visitSubterminalSymbol<E>(SubterminalSymbol<E> node) {
    _visitSymbol(node);
  }

  @override
  void visitTerminal<E>(Terminal<E> node) {
    throw UnimplementedError('visitTerminal');
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
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, true);
  }

  void _setIsOptional(Expression node, bool isOptional) {
    if (node.isOptional != isOptional) {
      _hasModifications = true;
      node.isOptional = isOptional;
    }
  }

  void _visitSequence<E>(SequenceExpression<E> node) {
    final expressions = node.expressions;
    final length = expressions.length;
    for (var i = 0; i < length; i++) {
      final child = expressions[i];
      child.accept(this);
    }

    final isOptional = expressions.where((e) => e.isOptional).length == length;
    _setIsOptional(node, isOptional);
  }

  void _visitSingle(SingleExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, child.isOptional);
  }

  void _visitSymbol(SymbolExpression node) {
    final expression = node.expression;
    _setIsOptional(node, expression.isOptional);
  }
}
