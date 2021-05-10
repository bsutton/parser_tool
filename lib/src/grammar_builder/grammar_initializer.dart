part of '../../grammar_builder.dart';

class GrammarInitializer {
  void initialize(Grammar grammar) {
    final expressionInitializer = ExpressionInitializer();
    expressionInitializer.initialize(grammar);
    final optionalExpressionResolver = OptionalExpressionResolver();
    optionalExpressionResolver.resolve(grammar);
    final expressionStartCharactersResolver =
        ExpressionStartCharactersResolver();
    expressionStartCharactersResolver.resolve(grammar);
    final expressionStartTerminalsResolver = ExpressionStartTerminalsResolver();
    expressionStartTerminalsResolver.resolve(grammar);
  }
}
