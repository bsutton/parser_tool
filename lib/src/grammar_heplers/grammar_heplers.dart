part of '../../grammar_heplers.dart';

OrderedChoiceExpression<E> alt<E>(List<Expression<E>> expressions) {
  final sequences = <SequenceExpression<E>>[];
  for (final expression in expressions) {
    if (expression is SequenceExpression<E>) {
      sequences.add(expression);
    } else {
      final sequence = SequenceFirstResultExpression(expression, const []);
      sequences.add(sequence);
    }
  }

  final orderedChoice = OrderedChoiceExpression<E>();
  orderedChoice.expressions.addAll(sequences);
  return orderedChoice;
}

AndPredicateExpression and(Expression expression) {
  return AndPredicateExpression(expression);
}

AnyCharacterExpression any() {
  return AnyCharacterExpression();
}

CaptureExpression cap(Expression expression) => capture(expression);

CaptureExpression capture(Expression expression) =>
    CaptureExpression(expression);

CharacterClassExpression char(int c) => CharacterClassExpression([
      [c, c]
    ]);

CharacterClassExpression chr(int c) => char(c);

LiteralExpression lit(String text) => literal(text);

LiteralExpression literal(String text) => LiteralExpression(text);

LocationalTransformerExpression<I, O> locate<I, O>(Expression<I> expression,
    O Function(String source, int start, int end, I result) action) {
  return LocationalTransformerExpression(expression, action);
}

NotPredicateExpression not(Expression expression) =>
    NotPredicateExpression(expression);

CharacterClassExpression range(String ranges) {
  final parser = RangesParser();
  final result = parser.parse(ranges);
  if (!parser.ok) {
    throw FormatException('Invalid ranges expression', ranges);
  }

  return CharacterClassExpression(result!);
}

Expression<List<E>> rep<E>(Expression<E> expression) {
  return ZeroOrMoreExpression(expression);
}

Expression<List<E>> rep1<E>(Expression<E> expression) {
  return OneOrMoreExpression(expression);
}

Expression<List<E>> repsep<E>(Expression<E> expression, Expression sep) {
  final t = seql([sep], expression).star;
  return seq2(expression, t).map((r) => [r.$1, ...r.$2]);
}

CharacterClassExpression rng(String ranges) => range(ranges);

PassiveSequenceExpression seq(List<Expression> expressions) {
  return PassiveSequenceExpression(expressions);
}

Sequence2Expression<E1, E2> seq2<E1, E2>(Expression<E1> e1, Expression<E2> e2) {
  return Sequence2Expression(e1, e2);
}

Sequence3Expression<E1, E2, E3> seq3<E1, E2, E3>(
    Expression<E1> e1, Expression<E2> e2, Expression<E3> e3) {
  return Sequence3Expression(e1, e2, e3);
}

Sequence4Expression<E1, E2, E3, E4> seq4<E1, E2, E3, E4>(Expression<E1> e1,
    Expression<E2> e2, Expression<E3> e3, Expression<E4> e4) {
  return Sequence4Expression(e1, e2, e3, e4);
}

Sequence5Expression<E1, E2, E3, E4, E5> seq5<E1, E2, E3, E4, E5>(
    Expression<E1> e1,
    Expression<E2> e2,
    Expression<E3> e3,
    Expression<E4> e4,
    Expression<E5> e5) {
  return Sequence5Expression(e1, e2, e3, e4, e5);
}

Sequence6Expression<E1, E2, E3, E4, E5, E6> seq6<E1, E2, E3, E4, E5, E6>(
    Expression<E1> e1,
    Expression<E2> e2,
    Expression<E3> e3,
    Expression<E4> e4,
    Expression<E5> e5,
    Expression<E6> e6) {
  return Sequence6Expression(e1, e2, e3, e4, e5, e6);
}

Sequence7Expression<E1, E2, E3, E4, E5, E6, E7>
    seq7<E, E1, E2, E3, E4, E5, E6, E7>(
        Expression<E1> e1,
        Expression<E2> e2,
        Expression<E3> e3,
        Expression<E4> e4,
        Expression<E5> e5,
        Expression<E6> e6,
        Expression<E7> e7) {
  return Sequence7Expression(e1, e2, e3, e4, e5, e6, e7);
}

SequenceFirstResultExpression<E> seqf<E>(Expression<E> e,
    [List<Expression> after = const []]) {
  return SequenceFirstResultExpression(e, after);
}

SequenceFirstLastResultExpression<E1, E2> seqfl<E1, E2>(
  Expression<E1> first,
  List<Expression> middle,
  Expression<E2> last,
) {
  return SequenceFirstLastResultExpression(first, middle, last);
}

SequenceLastResultExpression<E> seql<E>(
    List<Expression> before, Expression<E> e) {
  return SequenceLastResultExpression(before, e);
}

SequenceMiddleResultExpression<E> seqm<E>(
    List<Expression> before, Expression<E> e, List<Expression> after) {
  return SequenceMiddleResultExpression(before, e, after);
}

SequenceFixedResultExpression<E> seqr<E>(
    List<Expression> expressions, E result) {
  return SequenceFixedResultExpression(expressions, result);
}

extension ExpressionExt<E> on Expression<E> {
  Sequence2Expression<E, dynamic> operator <<(Expression expression) {
    return Sequence2Expression(this, expression);
  }

  LocationalTransformerExpression<E, O> locate<O>(
      O Function(String source, int start, int end, E result) action) {
    return LocationalTransformerExpression(this, action);
  }

  OptionalExpression<E> get opt => OptionalExpression(this);

  OneOrMoreExpression<E> get plus => OneOrMoreExpression(this);

  ZeroOrMoreExpression<E> get star => ZeroOrMoreExpression(this);
}

extension ProductionRuleExt<E> on ProductionRuleExpression<E> {
  ProductionRuleExpression<E> operator <<(Expression<E> expression) {
    if (expression is SequenceExpression<E>) {
      expressions.add(expression);
    } else {
      final sequence = SequenceFirstResultExpression(expression, const []);
      expressions.add(sequence);
    }

    return this;
  }
}

extension StringExt<E> on String {
  CharacterClassExpression get r {
    return range(this);
  }
}
