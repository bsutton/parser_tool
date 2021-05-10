part of '../../grammar_builder.dart';

class ExpressionStartCharactersResolver extends GrammarResolver {
  @override
  void visitAndPredicate(AndPredicateExpression node) {
    final child = node.expression;
    child.accept(this);
    _addCharacters(node, child.startCharacters);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _addCharacters(node, Expression.allCharacters);
  }

  @override
  void visitCapture(CaptureExpression node) {
    final child = node.expression;
    child.accept(this);
    _addCharacters(node, child.startCharacters);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    _addCharacters(node, node.ranges);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    final text = node.text;
    if (text.isEmpty) {
      _addAllCharactersWithEof(node);
    } else {
      final characters = SparseBoolList();
      final rune = text.runes.first;
      final group = GroupedRangeList<bool>(rune, rune, true);
      characters.addGroup(group);
      _addCharacters(node, characters);
    }
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
    final child = node.expression;
    child.accept(this);
    SparseBoolList? childCharacters;
    if (child is AnyCharacterExpression) {
      childCharacters = child.startCharacters;
    } else if (child is CharacterClassExpression) {
      childCharacters = child.startCharacters;
    } else if (child is LiteralExpression) {
      final text = child.text;
      if (text.length == 1) {
        final rune = text.runes.first;
        childCharacters = SparseBoolList();
        final group = GroupedRangeList(rune, rune, true);
        childCharacters.addGroup(group);
      }
    }

    if (childCharacters != null) {
      final startCharacters = SparseBoolList();
      for (final group in Expression.allCharactersWithEof.groups) {
        startCharacters.addGroup(group);
      }

      for (final range in childCharacters.groups) {
        final group = GroupedRangeList(range.start, range.end, false);
        startCharacters.setGroup(group);
      }

      _addCharacters(node, startCharacters);
    } else {
      _addAllCharactersWithEof(node);
    }
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
    final expressions = node.expressions;
    final length = expressions.length;
    for (var i = 0; i < length; i++) {
      final child = expressions[i];
      child.accept(this);
      _addCharacters(node, child.startCharacters);
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

  void _addAllCharactersWithEof(Expression node) {
    _addCharacters(node, Expression.allCharactersWithEof);
  }

  void _addCharacters(Expression node, SparseBoolList characters) {
    final startCharacters = node.startCharacters;
    for (final range in characters.groups) {
      for (final group in startCharacters.getAllSpace(range)) {
        if (!group.key!) {
          _hasModifications = true;
          final start = group.start;
          final end = group.end;
          final newGroup = GroupedRangeList(start, end, true);
          startCharacters.addGroup(newGroup);
        }
      }
    }
  }

  void _visitSequence(SequenceExpression node) {
    final expressions = node.expressions;
    final length = expressions.length;
    final affected = <Expression>[];
    var skip = false;
    for (var i = 0; i < length; i++) {
      final child = expressions[i];
      child.accept(this);
      if (!skip) {
        affected.add(child);
        if (!child.isOptional) {
          skip = true;
        }
      }
    }

    for (final child in affected) {
      _addCharacters(node, child.startCharacters);
    }
  }

  void _visitSingle(SingleExpression node) {
    final child = node.expression;
    child.accept(this);
    _addCharacters(node, child.startCharacters);
  }

  void _visitSymbol(SymbolExpression node) {
    final expression = node.expression;
    _addCharacters(node, expression.startCharacters);
  }
}
