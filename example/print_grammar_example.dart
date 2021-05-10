import 'package:parser_tool/grammar_printer.dart';

import 'example.dart';

void main() {
  final printer = GrammarPrinter();
  final sink = StringBuffer();
  printer.print(grammar, sink);
  print(sink);
}
