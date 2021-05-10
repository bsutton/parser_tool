part of '../../grammar_compiler.dart';

class GrammarCompiler<E> {
  final GrammarCompilerOptions options;

  GrammarCompiler([this.options = const GrammarCompilerOptions()]);

  Parser<E> compile(Grammar<E> grammar) {
    return _compile(grammar);
  }

  Parser<E> _compile(Grammar<E> grammar) {
    final compiler = ExpressionToParserCompiler(options);
    return compiler.compile(grammar.start.expression);
  }
}
