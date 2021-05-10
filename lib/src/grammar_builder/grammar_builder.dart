part of '../../grammar_builder.dart';

class GrammarBuilder extends ExpressionVisitor<Expression> {
  final Map<ProductionRule, List<SymbolExpression>> _callers = {};

  final Map<OrderedChoiceExpression, OrderedChoiceExpression> _processed = {};

  final Map<ProductionRuleExpression, ProductionRule> _rules = {};

  Grammar<E> build<E>(Nonterminal<E> expression) {
    _processed.clear();
    _rules.clear();
    expression.accept(this);
    final rule = _rules[expression] as NonterminalRule<E>;
    for (final rule in _callers.keys) {
      final expression = rule.expression;
      final callers = _callers[rule]!;
      for (final caller in callers) {
        caller.expression = expression;
      }
    }

    final grammar = Grammar(_rules.values.toList(), rule);
    final expressionInitializer = ExpressionInitializer();
    expressionInitializer.initialize(grammar);
    final grammarChecker = GrammarChecker();
    grammarChecker.check(grammar);
    final grammarInitializer = GrammarInitializer();
    grammarInitializer.initialize(grammar);
    final invocationsResolver = InvocationsResolver();
    invocationsResolver.resolve(grammar);
    return grammar;
  }

  @override
  Expression visitAndPredicate(AndPredicateExpression node) {
    final child = node.expression;
    final result = child.accept(this);
    return AndPredicateExpression(result);
  }

  @override
  Expression visitAnyCharacter(AnyCharacterExpression node) {
    return AnyCharacterExpression();
  }

  @override
  Expression visitCapture(CaptureExpression node) {
    final child = node.expression;
    final result = child.accept(this);
    return CaptureExpression(result);
  }

  @override
  Expression visitCharacterClass(CharacterClassExpression node) {
    final list = <List<int>>[];
    for (final group in node.ranges.groups) {
      list.add([group.start, group.end]);
    }

    return CharacterClassExpression(list);
  }

  @override
  Expression visitLiteral(LiteralExpression node) {
    return LiteralExpression(node.text);
  }

  @override
  Expression visitLocationalTransformer<I, O>(
      LocationalTransformerExpression<I, O> node) {
    final child = node.expression;
    final result = child.accept(this) as Expression<I>;
    return LocationalTransformerExpression<I, O>(result, node.transform);
  }

  @override
  Expression visitNonterminal<E>(Nonterminal<E> node) {
    var rule = _rules[node] as NonterminalRule<E>?;
    if (rule == null) {
      rule = NonterminalRule<E>(node.name);
      _rules[node] = rule;
      final expression =
          visitOrderedChoice<E>(node) as OrderedChoiceExpression<E>;
      rule.expression = expression;
      expression.rule = rule;
    }

    final symbol = NonterminalSymbol<E>();
    _addCaller(rule, symbol);
    return symbol;
  }

  @override
  Expression visitNonterminalSymbol<E>(NonterminalSymbol<E> node) {
    throw UnsupportedError('visitNonterminalSymbol');
  }

  @override
  Expression visitNotPredicate(NotPredicateExpression node) {
    final child = node.expression;
    final result = child.accept(this);
    return NotPredicateExpression(result);
  }

  @override
  Expression visitOneOrMore<E>(OneOrMoreExpression<E> node) {
    final child = node.expression;
    final result = child.accept(this) as Expression<E>;
    return OneOrMoreExpression<E>(result);
  }

  @override
  Expression visitOptional<E>(OptionalExpression<E> node) {
    final child = node.expression;
    final result = child.accept(this) as Expression<E>;
    return OptionalExpression<E>(result);
  }

  @override
  Expression visitOrderedChoice<E>(OrderedChoiceExpression<E> node) {
    if (_processed.containsKey(node)) {
      return _processed[node]!;
    }

    final choice = OrderedChoiceExpression<E>();
    _processed[node] = choice;
    final expressions = choice.expressions;
    for (final expression in node.expressions) {
      final result = expression.accept(this) as SequenceExpression<E>;
      expressions.add(result);
    }

    return choice;
  }

  @override
  Expression visitPassiveSequence(PassiveSequenceExpression node) {
    final expressions = <Expression>[];
    for (final expression in node.expressions) {
      final result = expression.accept(this);
      expressions.add(result);
    }

    return PassiveSequenceExpression(expressions);
  }

  @override
  Expression visitSequence2<E1, E2>(Sequence2Expression<E1, E2> node) {
    final e1 = node.e1.accept(this) as Expression<E1>;
    final e2 = node.e2.accept(this) as Expression<E2>;
    return Sequence2Expression<E1, E2>(e1, e2);
  }

  @override
  Expression visitSequence3<E1, E2, E3>(Sequence3Expression<E1, E2, E3> node) {
    final e1 = node.e1.accept(this) as Expression<E1>;
    final e2 = node.e2.accept(this) as Expression<E2>;
    final e3 = node.e3.accept(this) as Expression<E3>;
    return Sequence3Expression<E1, E2, E3>(e1, e2, e3);
  }

  @override
  Expression visitSequence4<E1, E2, E3, E4>(
      Sequence4Expression<E1, E2, E3, E4> node) {
    final e1 = node.e1.accept(this) as Expression<E1>;
    final e2 = node.e2.accept(this) as Expression<E2>;
    final e3 = node.e3.accept(this) as Expression<E3>;
    final e4 = node.e4.accept(this) as Expression<E4>;
    return Sequence4Expression<E1, E2, E3, E4>(e1, e2, e3, e4);
  }

  @override
  Expression visitSequence5<E1, E2, E3, E4, E5>(
      Sequence5Expression<E1, E2, E3, E4, E5> node) {
    final e1 = node.e1.accept(this) as Expression<E1>;
    final e2 = node.e2.accept(this) as Expression<E2>;
    final e3 = node.e3.accept(this) as Expression<E3>;
    final e4 = node.e4.accept(this) as Expression<E4>;
    final e5 = node.e5.accept(this) as Expression<E5>;
    return Sequence5Expression<E1, E2, E3, E4, E5>(e1, e2, e3, e4, e5);
  }

  @override
  Expression visitSequence6<E1, E2, E3, E4, E5, E6>(
      Sequence6Expression<E1, E2, E3, E4, E5, E6> node) {
    final e1 = node.e1.accept(this) as Expression<E1>;
    final e2 = node.e2.accept(this) as Expression<E2>;
    final e3 = node.e3.accept(this) as Expression<E3>;
    final e4 = node.e4.accept(this) as Expression<E4>;
    final e5 = node.e5.accept(this) as Expression<E5>;
    final e6 = node.e6.accept(this) as Expression<E6>;
    return Sequence6Expression<E1, E2, E3, E4, E5, E6>(e1, e2, e3, e4, e5, e6);
  }

  @override
  Expression visitSequence7<E1, E2, E3, E4, E5, E6, E7>(
      Sequence7Expression<E1, E2, E3, E4, E5, E6, E7> node) {
    final e1 = node.e1.accept(this) as Expression<E1>;
    final e2 = node.e2.accept(this) as Expression<E2>;
    final e3 = node.e3.accept(this) as Expression<E3>;
    final e4 = node.e4.accept(this) as Expression<E4>;
    final e5 = node.e5.accept(this) as Expression<E5>;
    final e6 = node.e6.accept(this) as Expression<E6>;
    final e7 = node.e7.accept(this) as Expression<E7>;
    return Sequence7Expression<E1, E2, E3, E4, E5, E6, E7>(
        e1, e2, e3, e4, e5, e6, e7);
  }

  @override
  Expression visitSequenceFirstLastResult<E1, E2>(
      SequenceFirstLastResultExpression<E1, E2> node) {
    final first = node.first.accept(this) as Expression<E1>;
    final middle = <Expression>[];
    for (final expression in node.middle) {
      final result = expression.accept(this);
      middle.add(result);
    }

    final last = node.last.accept(this) as Expression<E2>;
    return SequenceFirstLastResultExpression<E1, E2>(first, middle, last);
  }

  @override
  Expression visitSequenceFirstResult<E>(
      SequenceFirstResultExpression<E> node) {
    final expression = node.expression.accept(this) as Expression<E>;
    final after = <Expression>[];
    for (final expression in node.after) {
      final result = expression.accept(this);
      after.add(result);
    }

    return SequenceFirstResultExpression<E>(expression, after);
  }

  @override
  Expression visitSequenceFixedResult<E>(
      SequenceFixedResultExpression<E> node) {
    final expressions = <Expression>[];
    for (final expression in node.expressions) {
      final result = expression.accept(this);
      expressions.add(result);
    }

    return SequenceFixedResultExpression<E>(expressions, node.result);
  }

  @override
  Expression visitSequenceLastResult<E>(SequenceLastResultExpression<E> node) {
    final before = <Expression>[];
    for (final expression in node.before) {
      final result = expression.accept(this);
      before.add(result);
    }

    final expression = node.expression.accept(this) as Expression<E>;
    return SequenceLastResultExpression<E>(before, expression);
  }

  @override
  Expression visitSequenceMiddleResult<E>(
      SequenceMiddleResultExpression<E> node) {
    final before = <Expression>[];
    for (final expression in node.before) {
      final result = expression.accept(this);
      before.add(result);
    }

    final expression = node.expression.accept(this) as Expression<E>;
    final after = <Expression>[];
    for (final expression in node.after) {
      final result = expression.accept(this);
      after.add(result);
    }

    return SequenceMiddleResultExpression<E>(before, expression, after);
  }

  @override
  Expression visitSubterminal<E>(Subterminal<E> node) {
    var rule = _rules[node] as SubterminalRule<E>?;
    if (rule == null) {
      rule = SubterminalRule<E>(node.name);
      _rules[node] = rule;
      final expression =
          visitOrderedChoice<E>(node) as OrderedChoiceExpression<E>;
      rule.expression = expression;
      expression.rule = rule;
    }

    final symbol = SubterminalSymbol<E>();
    _addCaller(rule, symbol);
    return symbol;
  }

  @override
  Expression visitSubterminalSymbol<E>(SubterminalSymbol<E> node) {
    throw UnsupportedError('visitSubterminalSymbol');
  }

  @override
  Expression visitTerminal<E>(Terminal<E> node) {
    var rule = _rules[node] as TerminalRule<E>?;
    if (rule == null) {
      rule = TerminalRule<E>(node.name);
      _rules[node] = rule;
      final expression =
          visitOrderedChoice<E>(node) as OrderedChoiceExpression<E>;
      rule.expression = expression;
      expression.rule = rule;
    }

    final symbol = TerminalSymbol<E>();
    _addCaller(rule, symbol);
    return symbol;
  }

  @override
  Expression visitTerminalSymbol<E>(TerminalSymbol<E> node) {
    throw UnsupportedError('visitTerminalSymbol');
  }

  @override
  Expression visitTransformer<I, O>(TransformerExpression<I, O> node) {
    final child = node.expression;
    final result = child.accept(this) as Expression<I>;
    return TransformerExpression<I, O>(result, node.transform);
  }

  @override
  Expression visitZeroOrMore<E>(ZeroOrMoreExpression<E> node) {
    final child = node.expression;
    final result = child.accept(this) as Expression<E>;
    return ZeroOrMoreExpression<E>(result);
  }

  void _addCaller(ProductionRule rule, SymbolExpression symbol) {
    var list = _callers[rule];
    if (list == null) {
      list = [];
      _callers[rule] = list;
    }

    list.add(symbol);
  }
}
