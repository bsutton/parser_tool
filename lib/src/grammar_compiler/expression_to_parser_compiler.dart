part of '../../grammar_compiler.dart';

class ExpressionToParserCompiler extends ExpressionVisitor<Parser> {
  final Set<Expression> heads = {};

  final GrammarCompilerOptions options;

  final Map<SymbolExpression, Parser> rules = {};

  ExpressionToParserCompiler(this.options);

  Parser<E> compile<E>(Expression<E> expression) {
    return expression.accept(this) as Parser<E>;
  }

  @override
  Parser visitAndPredicate(AndPredicateExpression node) {
    final child = node.expression;
    final parser = child.accept(this);
    return AndPredicateParser(parser, source: '$node');
  }

  @override
  Parser visitAnyCharacter(AnyCharacterExpression node) {
    return AnyCharacterParser(source: '$node');
  }

  @override
  Parser visitCapture(CaptureExpression node) {
    final child = node.expression;
    final parser = child.accept(this);
    return CaptureParser(parser, source: '$node');
  }

  @override
  Parser visitCharacterClass(CharacterClassExpression node) {
    final source = '$node';
    final ranges = node.ranges;
    final groups = ranges.groups;
    if (groups.length == 1) {
      final group = groups.first;
      final start = group.start;
      final end = group.end;
      if (start == end) {
        if (heads.contains(node)) {
          return CheckedCharacterParser(start, source: source);
        } else {
          return CharacterParser(start, source: source);
        }
      }

      final list = Uint32List(2);
      list[0] = start;
      list[1] = end;
      if (heads.contains(node)) {
        return CheckedRangesParser(list, source: source);
      } else {
        return RangesParser(list, source: source);
      }
    } else {
      var count = 0;
      for (final group in groups) {
        final start = group.start;
        final end = group.end;
        count += end - start;
      }

      if (count <= 8) {
        final chars = <int>[];
        for (final group in groups) {
          final start = group.start;
          final end = group.end;
          if (start == end) {
            chars.add(start);
          } else {
            for (var i = start; i <= end; i++) {
              chars.add(i);
            }
          }
        }

        final list = Uint32List(chars.length);
        for (var i = 0; i < chars.length; i++) {
          list[i] = chars[i];
        }

        if (heads.contains(node)) {
          return CheckedCharactersParser(list, source: source);
        } else {
          return CharactersParser(list, source: source);
        }
      }

      final ranges = <int>[];
      for (final group in groups) {
        final start = group.start;
        final end = group.end;
        ranges.add(start);
        ranges.add(end);
      }

      final list = Uint32List(ranges.length);
      for (var i = 0; i < ranges.length; i++) {
        list[i] = ranges[i];
      }

      if (heads.contains(node)) {
        return CheckedRangesParser(list, source: source);
      } else {
        return RangesParser(list, source: source);
      }
    }
  }

  @override
  Parser visitLiteral(LiteralExpression node) {
    final source = '$node';
    final text = node.text;
    if (text.isEmpty) {
      return EmptyStringParser(source: source);
    } else if (text.length == 1) {
      final ch = text.codeUnitAt(0);
      if (heads.contains(node)) {
        return CheckedShortStringParser(text, ch, source: source);
      } else {
        return ShortStringParser(text, ch, source: source);
      }
    } else {
      return LongStringParser(text, source: source);
    }
  }

  @override
  Parser visitLocationalTransformer<I, O>(
      LocationalTransformerExpression<I, O> node) {
    final child = node.expression;
    final parser = child.accept(this) as Parser<I>;
    return LocationalTransformerParser<I, O>(parser, node.transform,
        source: '$node');
  }

  @override
  Parser visitNonterminal<E>(Nonterminal<E> node) {
    throw UnsupportedError('visitNonterminal');
  }

  @override
  Parser visitNonterminalSymbol<E>(NonterminalSymbol<E> node) {
    final expression = node.expression;
    final rule = expression.rule!;
    final name = rule.name;
    NonterminalParser<E> getParser() {
      final parser = DummyParser<E>();
      if (options.predict) {
        final terminals = node.startTerminals.map((e) => e.name).toList();
        if (options.debug) {
          return PredictiveNonterminalDebugParser<E>(parser, name, terminals,
              source: '$node');
        } else {
          return PredictiveNonterminalParser<E>(parser, name, terminals,
              source: '$node');
        }
      } else {
        if (options.debug) {
          return NonterminalDebugParser<E>(parser, name, source: '$node');
        } else {
          return NonterminalParser<E>(parser, name, source: '$node');
        }
      }
    }

    if (rules.containsKey(node)) {
      return rules[node]!;
    }

    final parser = getParser();
    rules[node] = parser;
    final child = visitOrderedChoice(expression) as Parser<E>;
    parser.parser = child;
    if (options.debug) {
      rules[node] = parser;
      return parser;
    } else {
      if (child is OrderedChoiceParser) {
        rules[node] = parser;
        return parser;
      } else {
        rules[node] = child;
        return child;
      }
    }
  }

  @override
  Parser visitNotPredicate(NotPredicateExpression node) {
    final child = node.expression;
    final parser = child.accept(this);
    return NotPredicateParser(parser, source: '$node');
  }

  @override
  Parser visitOneOrMore<E>(OneOrMoreExpression<E> node) {
    final child = node.expression;
    final parser = child.accept(this) as Parser<E>;
    return parser.getRepeater(1, RepeaterParser.maxValue, source: '$node');
  }

  @override
  Parser visitOptional<E>(OptionalExpression<E> node) {
    final child = node.expression;
    final parser = child.accept(this) as Parser<E>;
    return OptionalParser<E>(parser, source: '$node');
  }

  @override
  Parser visitOrderedChoice<E>(OrderedChoiceExpression<E> node) {
    final expressions = node.expressions;
    if (expressions.length == 1) {
      final child = expressions.first;
      return child.accept(this);
    }

    if (!options.predict) {
      final parsers = <Parser<E>>[];
      for (var i = 0; i < expressions.length; i++) {
        final child = expressions[i];
        final parser = child.accept(this) as Parser<E>;
        parsers.add(parser);
      }

      return OrderedChoiceParser<E>(parsers);
    }

    final states = <List<int>>[];
    final stateCharacters = <SparseBoolList>[];
    _computeTransitions(expressions, states, stateCharacters);
    final temp = SparseList<List<int>>();
    for (var i = 0; i < states.length; i++) {
      final foo = states[i];
      for (final src in stateCharacters[i].groups) {
        final allSpace = temp.getAllSpace(src);
        for (final dest in allSpace) {
          var key = dest.key;
          key ??= [];
          for (var j = 0; j < foo.length; j++) {
            final state = foo[j];
            if (!key.contains(state)) {
              key.add(state);
            }
          }

          final group = GroupedRangeList<List<int>>(dest.start, dest.end, key);
          temp.addGroup(group);
        }
      }
    }

    final ranges = Uint32List(temp.groupCount * 2);
    final transitions = <List<int>>[];
    var index = 0;
    for (final group in temp.groups) {
      ranges[index++] = group.start;
      ranges[index++] = group.end;
      transitions.add(group.key);
    }

    Expression getHead(Expression expression) {
      if (expression is SequenceExpression) {
        final expressions = expression.expressions;
        final first = expressions.first;
        return getHead(first);
      } else if (expression is OrderedChoiceExpression) {
        final expressions = expression.expressions;
        if (expressions.length == 1) {
          final first = expressions.first;
          return getHead(first);
        }
      } else if (expression is TransformerExpression) {
        final child = expression.expression;
        return getHead(child);
      } else if (expression is LocationalTransformerExpression) {
        final child = expression.expression;
        return getHead(child);
      } else if (expression is SymbolExpression) {
        final child = expression.expression;
        return getHead(child);
      } else if (expression is CaptureExpression) {
        final child = expression.expression;
        return getHead(child);
      }

      return expression;
    }

    final parsers = <Parser<E>>[];
    for (var i = 0; i < expressions.length; i++) {
      final child = expressions[i];
      final head = getHead(child);
      final rule = head.rule!;
      if (rule.directCallers.length == 1) {
        heads.add(head);
      }

      final parser = child.accept(this) as Parser<E>;
      parsers.add(parser);
    }

    return PredictiveOrderedChoiceParser<E>(parsers, ranges, transitions,
        source: '$node');
  }

  @override
  Parser visitPassiveSequence(PassiveSequenceExpression node) {
    final expressions = node.expressions;
    if (expressions.length == 1) {
      final child = expressions.first;
      final parser = child.accept(this);
      return parser;
    }

    final parsers = <Parser>[];
    for (var i = 0; i < expressions.length; i++) {
      final child = expressions[i];
      final parser = child.accept(this);
      parsers.add(parser);
    }

    return PassiveSequenceParser(parsers, source: '$node');
  }

  @override
  Parser visitSequence2<E1, E2>(Sequence2Expression<E1, E2> node) {
    final e1 = node.e1.accept(this) as Parser<E1>;
    final e2 = node.e2.accept(this) as Parser<E2>;
    return Sequence2Parser(e1, e2, source: '$node');
  }

  @override
  Parser visitSequence3<E1, E2, E3>(Sequence3Expression<E1, E2, E3> node) {
    final e1 = node.e1.accept(this) as Parser<E1>;
    final e2 = node.e2.accept(this) as Parser<E2>;
    final e3 = node.e3.accept(this) as Parser<E3>;
    return Sequence3Parser(e1, e2, e3, source: '$node');
  }

  @override
  Parser visitSequence4<E1, E2, E3, E4>(
      Sequence4Expression<E1, E2, E3, E4> node) {
    final e1 = node.e1.accept(this) as Parser<E1>;
    final e2 = node.e2.accept(this) as Parser<E2>;
    final e3 = node.e3.accept(this) as Parser<E3>;
    final e4 = node.e4.accept(this) as Parser<E4>;
    return Sequence4Parser(e1, e2, e3, e4, source: '$node');
  }

  @override
  Parser visitSequence5<E1, E2, E3, E4, E5>(
      Sequence5Expression<E1, E2, E3, E4, E5> node) {
    final e1 = node.e1.accept(this) as Parser<E1>;
    final e2 = node.e2.accept(this) as Parser<E2>;
    final e3 = node.e3.accept(this) as Parser<E3>;
    final e4 = node.e4.accept(this) as Parser<E4>;
    final e5 = node.e5.accept(this) as Parser<E5>;
    return Sequence5Parser(e1, e2, e3, e4, e5, source: '$node');
  }

  @override
  Parser visitSequence6<E1, E2, E3, E4, E5, E6>(
      Sequence6Expression<E1, E2, E3, E4, E5, E6> node) {
    final e1 = node.e1.accept(this) as Parser<E1>;
    final e2 = node.e2.accept(this) as Parser<E2>;
    final e3 = node.e3.accept(this) as Parser<E3>;
    final e4 = node.e4.accept(this) as Parser<E4>;
    final e5 = node.e5.accept(this) as Parser<E5>;
    final e6 = node.e6.accept(this) as Parser<E6>;
    return Sequence6Parser(e1, e2, e3, e4, e5, e6, source: '$node');
  }

  @override
  Parser visitSequence7<E1, E2, E3, E4, E5, E6, E7>(
      Sequence7Expression<E1, E2, E3, E4, E5, E6, E7> node) {
    final e1 = node.e1.accept(this) as Parser<E1>;
    final e2 = node.e2.accept(this) as Parser<E2>;
    final e3 = node.e3.accept(this) as Parser<E3>;
    final e4 = node.e4.accept(this) as Parser<E4>;
    final e5 = node.e5.accept(this) as Parser<E5>;
    final e6 = node.e6.accept(this) as Parser<E6>;
    final e7 = node.e7.accept(this) as Parser<E7>;
    return Sequence7Parser(e1, e2, e3, e4, e5, e6, e7, source: '$node');
  }

  @override
  Parser visitSequenceFirstLastResult<E1, E2>(
      SequenceFirstLastResultExpression<E1, E2> node) {
    final first = node.first.accept(this) as Parser<E1>;
    final middle = _visitParsers(node.middle);
    final last = node.last.accept(this) as Parser<E2>;
    return SequenceFirstLastResultParser<E1, E2>(first, middle, last,
        source: '$node');
  }

  @override
  Parser visitSequenceFirstResult<E>(SequenceFirstResultExpression<E> node) {
    final child = node.expression;
    final parser = child.accept(this) as Parser<E>;
    final expressions = node.expressions;
    if (expressions.length == 1) {
      return parser;
    }

    final after = _visitParsers(node.after);
    return SequenceFirstResultParser<E>(parser, after, source: '$node');
  }

  @override
  Parser visitSequenceFixedResult<E>(SequenceFixedResultExpression<E> node) {
    final expressions = node.expressions;
    final parsers = <Parser>[];
    for (var i = 0; i < expressions.length; i++) {
      final child = expressions[i];
      final parser = child.accept(this);
      parsers.add(parser);
    }

    if (parsers.length == 1) {
      return FixedResultTransformerParser<E>(parsers.first, node.result,
          source: '$node');
    } else {
      return SequenceFixedResultParser<E>(parsers, node.result,
          source: '$node');
    }
  }

  @override
  Parser visitSequenceLastResult<E>(SequenceLastResultExpression<E> node) {
    final before = _visitParsers(node.before);
    final child = node.expression;
    final parser = child.accept(this) as Parser<E>;
    return SequenceLastResultParser<E>(before, parser, source: '$node');
  }

  @override
  Parser visitSequenceMiddleResult<E>(SequenceMiddleResultExpression<E> node) {
    final before = _visitParsers(node.before);
    final child = node.expression;
    final parser = child.accept(this) as Parser<E>;
    final after = _visitParsers(node.after);
    return SequenceMiddleResultParser<E>(before, parser, after,
        source: '$node');
  }

  @override
  Parser visitSubterminal<E>(Subterminal<E> node) {
    throw UnsupportedError('visitSubterminal');
  }

  @override
  Parser visitSubterminalSymbol<E>(SubterminalSymbol<E> node) {
    final expression = node.expression;
    final rule = expression.rule!;
    final name = rule.name;
    SubterminalParser<E> getParser() {
      final parser = DummyParser<E>();
      if (options.debug) {
        return SubterminalDebugParser<E>(parser, name, source: '$node');
      } else {
        return SubterminalParser<E>(parser, name, source: '$node');
      }
    }

    if (rules.containsKey(node)) {
      return rules[node]!;
    }

    final parser = getParser();
    rules[node] = parser;
    final child = visitOrderedChoice(expression) as Parser<E>;
    parser.parser = child;
    if (options.debug) {
      rules[node] = parser;
      return parser;
    } else {
      rules[node] = child;
      return child;
    }
  }

  @override
  Parser visitTerminal<E>(Terminal<E> node) {
    throw UnsupportedError('visitTerminal');
  }

  @override
  Parser visitTerminalSymbol<E>(TerminalSymbol<E> node) {
    final expression = node.expression;
    final rule = expression.rule!;
    final name = rule.name;
    TerminalParser<E> getParser() {
      final parser = DummyParser<E>();
      if (options.debug) {
        return TerminalDebugParser<E>(parser, name, source: '$node');
      } else {
        return TerminalParser<E>(parser, name, source: '$node');
      }
    }

    var parser = rules[node] as TerminalParser<E>?;
    if (parser == null) {
      parser = getParser();
      rules[node] = parser;
      parser.parser = visitOrderedChoice(expression) as Parser<E>;
    }

    return parser;
  }

  @override
  Parser visitTransformer<I, O>(TransformerExpression<I, O> node) {
    final child = node.expression;
    final parser = child.accept(this) as Parser<I>;
    return TransformerParser<I, O>(parser, node.transform, source: '$node');
  }

  @override
  Parser visitZeroOrMore<E>(ZeroOrMoreExpression<E> node) {
    final child = node.expression;
    final parser = child.accept(this) as Parser<E>;
    return parser.getRepeater(0, RepeaterParser.maxValue, source: '$node');
  }

  void _computeTransitions<E>(List<SequenceExpression<E>> sequences,
      List<List<int>> states, List<SparseBoolList> stateCharacters) {
    final statesAndCharacters = SparseList<List<int>>();
    for (var i = 0; i < sequences.length; i++) {
      final sequence = sequences[i];
      for (final src in sequence.startCharacters.getGroups()) {
        final allSpace = statesAndCharacters.getAllSpace(src);
        for (final dest in allSpace) {
          var key = dest.key;
          if (key == null) {
            key = [i];
            final group =
                GroupedRangeList<List<int>>(dest.start, dest.end, key);
            statesAndCharacters.addGroup(group);
          } else {
            final newKey = key.toList();
            if (!newKey.contains(i)) {
              newKey.add(i);
            }

            final group =
                GroupedRangeList<List<int>>(dest.start, dest.end, newKey);
            statesAndCharacters.setGroup(group);
          }
        }
      }
    }

    int addState(List<int> choiceIndexes) {
      for (var i = 0; i < states.length; i++) {
        final state = states[i];
        if (choiceIndexes.length == state.length) {
          var found = true;
          for (var j = 0; j < choiceIndexes.length; j++) {
            if (choiceIndexes[j] != state[j]) {
              found = false;
              break;
            }
          }

          if (found) {
            return i;
          }
        }
      }

      states.add(choiceIndexes.toList());
      return states.length - 1;
    }

    final map = <int, List<GroupedRangeList<List<int>>>>{};
    for (final group in statesAndCharacters.groups) {
      final key = group.key;
      final i = addState(key);
      var value = map[i];
      if (value == null) {
        value = [];
        map[i] = value;
      }

      value.add(group);
    }

    for (var i = 0; i < states.length; i++) {
      final groups = map[i]!;
      final list = SparseBoolList();
      for (final src in groups) {
        final dest = GroupedRangeList<bool>(src.start, src.end, true);
        list.addGroup(dest);
      }

      stateCharacters.add(list);
    }
  }

  List<Parser> _visitParsers(List<Expression> expressions) {
    final parsers = <Parser>[];
    for (var i = 0; i < expressions.length; i++) {
      final child = expressions[i];
      final parser = child.accept(this);
      parsers.add(parser);
    }

    return parsers;
  }
}
