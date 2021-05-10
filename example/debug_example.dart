import 'package:parser_tool/grammar_compiler.dart';
import 'package:parser_tool/parse.dart';
import 'package:parser_tool/src/parsers.dart';

import 'example.dart';

void main() {
  final source = '{"name": "Jack"}';
  final options = GrammarCompilerOptions(debug: true);
  final parser = compileGrammar(grammar, options);
  final state = DebugParserState(source);
  final result = parser.parse(state);
  if (result == null) {
    throw state.buildError();
  }

  print(result.value);
}

class DebugParserState extends ParseState {
  int indent = 0;

  DebugParserState(String source) : super(source);

  @override
  void enter(ProductionRuleParser parser) {
    void report() {
      final sink = StringBuffer();
      sink.write(' ' * indent++);
      sink.write('> ');
      sink.write(parser.name);
      sink.write(' (');
      sink.write(pos);
      sink.write(') >> ');
      var end = pos + 20;
      end = end > source.length ? source.length : end;
      sink.write(source.substring(pos, end));
      print(sink);
    }

    report();
    if (parser.name == 'member') {
      //debugger();
    }
  }

  @override
  void leave(ProductionRuleParser parser, result) {
    void report() {
      final sink = StringBuffer();
      sink.write(' ' * --indent);
      sink.write('< ');
      sink.write(parser.name);
      sink.write(' (');
      sink.write(pos);
      sink.write(')');
      if (result == null) {
        sink.write(' FAIL');
      } else {
        sink.write(': ');
        sink.write(result);
      }

      print(sink);
    }

    report();
  }
}
