part of '../../expressions.dart';

abstract class ExpressionVisitor<R> {
  R visitAndPredicate(AndPredicateExpression node);

  R visitAnyCharacter(AnyCharacterExpression node);

  R visitCapture(CaptureExpression node);

  R visitCharacterClass(CharacterClassExpression node);

  R visitLiteral(LiteralExpression node);

  R visitLocationalTransformer<I, O>(
      LocationalTransformerExpression<I, O> node);

  R visitNonterminal<E>(Nonterminal<E> node);

  R visitNonterminalSymbol<E>(NonterminalSymbol<E> node);

  R visitNotPredicate(NotPredicateExpression node);

  R visitOneOrMore<E>(OneOrMoreExpression<E> node);

  R visitOptional<E>(OptionalExpression<E> node);

  R visitOrderedChoice<E>(OrderedChoiceExpression<E> node);

  R visitPassiveSequence(PassiveSequenceExpression node);

  R visitSequence2<E1, E2>(Sequence2Expression<E1, E2> node);

  R visitSequence3<E1, E2, E3>(Sequence3Expression<E1, E2, E3> node);

  R visitSequence4<E1, E2, E3, E4>(Sequence4Expression<E1, E2, E3, E4> node);

  R visitSequence5<E1, E2, E3, E4, E5>(
      Sequence5Expression<E1, E2, E3, E4, E5> node);

  R visitSequence6<E1, E2, E3, E4, E5, E6>(
      Sequence6Expression<E1, E2, E3, E4, E5, E6> node);

  R visitSequence7<E1, E2, E3, E4, E5, E6, E7>(
      Sequence7Expression<E1, E2, E3, E4, E5, E6, E7> node);

  R visitSequenceFirstLastResult<E1, E2>(
      SequenceFirstLastResultExpression<E1, E2> node);

  R visitSequenceFirstResult<E>(SequenceFirstResultExpression<E> node);

  R visitSequenceFixedResult<E>(SequenceFixedResultExpression<E> node);

  R visitSequenceLastResult<E>(SequenceLastResultExpression<E> node);

  R visitSequenceMiddleResult<E>(SequenceMiddleResultExpression<E> node);

  R visitSubterminal<E>(Subterminal<E> node);

  R visitSubterminalSymbol<E>(SubterminalSymbol<E> node);

  R visitTerminal<E>(Terminal<E> node);

  R visitTerminalSymbol<E>(TerminalSymbol<E> node);

  R visitTransformer<I, O>(TransformerExpression<I, O> node);

  R visitZeroOrMore<E>(ZeroOrMoreExpression<E> node);
}

class RecursiveExpressionVisitor<R> extends ExpressionVisitor<R?> {
  @override
  R? visitAndPredicate(AndPredicateExpression node) => _visitExpression(node);

  @override
  R? visitAnyCharacter(AnyCharacterExpression node) => _visitExpression(node);

  @override
  R? visitCapture(CaptureExpression node) => _visitExpression(node);

  @override
  R? visitCharacterClass(CharacterClassExpression node) =>
      _visitExpression(node);

  @override
  R? visitLiteral(LiteralExpression node) => _visitExpression(node);

  @override
  R? visitLocationalTransformer<I, O>(
          LocationalTransformerExpression<I, O> node) =>
      _visitExpression(node);

  @override
  R? visitNonterminal<E>(Nonterminal<E> node) => _visitExpression(node);

  @override
  R? visitNonterminalSymbol<E>(NonterminalSymbol<E> node) =>
      _visitExpression(node);

  @override
  R? visitNotPredicate(NotPredicateExpression node) => _visitExpression(node);

  @override
  R? visitOneOrMore<E>(OneOrMoreExpression<E> node) => _visitExpression(node);

  @override
  R? visitOptional<E>(OptionalExpression<E> node) => _visitExpression(node);

  @override
  R? visitOrderedChoice<E>(OrderedChoiceExpression<E> node) =>
      _visitExpression(node);

  @override
  R? visitPassiveSequence(PassiveSequenceExpression node) =>
      _visitExpression(node);

  @override
  R? visitSequence2<E1, E2>(Sequence2Expression<E1, E2> node) =>
      _visitExpression(node);

  @override
  R? visitSequence3<E1, E2, E3>(Sequence3Expression<E1, E2, E3> node) =>
      _visitExpression(node);

  @override
  R? visitSequence4<E1, E2, E3, E4>(Sequence4Expression<E1, E2, E3, E4> node) =>
      _visitExpression(node);

  @override
  R? visitSequence5<E1, E2, E3, E4, E5>(
          Sequence5Expression<E1, E2, E3, E4, E5> node) =>
      _visitExpression(node);

  @override
  R? visitSequence6<E1, E2, E3, E4, E5, E6>(
          Sequence6Expression<E1, E2, E3, E4, E5, E6> node) =>
      _visitExpression(node);

  @override
  R? visitSequence7<E1, E2, E3, E4, E5, E6, E7>(
          Sequence7Expression<E1, E2, E3, E4, E5, E6, E7> node) =>
      _visitExpression(node);

  @override
  R? visitSequenceFirstLastResult<E1, E2>(
          SequenceFirstLastResultExpression<E1, E2> node) =>
      _visitExpression(node);

  @override
  R? visitSequenceFirstResult<E>(SequenceFirstResultExpression<E> node) =>
      _visitExpression(node);

  @override
  R? visitSequenceFixedResult<E>(SequenceFixedResultExpression<E> node) =>
      _visitExpression(node);

  @override
  R? visitSequenceLastResult<E>(SequenceLastResultExpression<E> node) =>
      _visitExpression(node);

  @override
  R? visitSequenceMiddleResult<E>(SequenceMiddleResultExpression<E> node) =>
      _visitExpression(node);

  @override
  R? visitSubterminal<E>(Subterminal<E> node) => _visitExpression(node);

  @override
  R? visitSubterminalSymbol<E>(SubterminalSymbol<E> node) =>
      _visitExpression(node);

  @override
  R? visitTerminal<E>(Terminal<E> node) => _visitExpression(node);

  @override
  R? visitTerminalSymbol<E>(TerminalSymbol<E> node) => _visitExpression(node);

  @override
  R? visitTransformer<I, O>(TransformerExpression<I, O> node) =>
      _visitExpression(node);

  @override
  R? visitZeroOrMore<E>(ZeroOrMoreExpression<E> node) => _visitExpression(node);

  R? _visitExpression(Expression node) {
    node.visitChildren(this);
  }
}
