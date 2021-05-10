# parser_tool

Version 0.1.1 (BETA)  

Parser tool is a real-time compiler and runtime engine for strongly typed PEG parsers.  

Parser tool contains libraries that allow you to create strongly typed PEG parsers. The tool contains a compiler that compiles a parser in real time and an engine to execute the compiled parsers.  

### Advantages

- Strongly typed parsers
- Sufficiently high performance
- Allows you to debug the parser through tracing support with information about the parsing progress
- Expression notations are available during debugging
- Allows you to print out grammar

### Disvantages

- Not as fast parsers as compared to parsers that compile directly into source code
- The debugging process is not so clear and convenient

### Planned features

- Adding a semantic predicate

### Example

```dart
import 'package:parser_tool/grammar.dart';
import 'package:parser_tool/grammar_builder.dart';
import 'package:parser_tool/grammar_compiler.dart';
import 'package:parser_tool/grammar_heplers.dart';

import '_parse_number.dart';

export 'package:parser_tool/parse.dart';

void main() {
  final text = '''
{"rocket": "🚀 flies to the stars"}
''';
  final state = ParseState(text);
  final result = parser.parse(state);
  if (result == null) {
    throw state.buildError();
  }

  print(result.value);
}

final grammar = buildGrammar();

final Parser parser = compileGrammar(grammar);

Grammar buildGrammar() {
  // Nonterminals
  final array = Nonterminal<List>('array');
  final json = Nonterminal('json');
  final member = Nonterminal<MapEntry<String, dynamic>>('member');
  final members = Nonterminal<List<MapEntry<String, dynamic>>>('members');
  final object = Nonterminal<Map<String, dynamic>>('object');
  final value = Nonterminal('value');
  final values = Nonterminal<List>('values');

  // Terminals
  final $comma = Terminal(',');
  final $eof = Terminal('end of file');
  final $false = Terminal<bool>('false');
  final $leadingSpaces = Terminal('leading spaces');
  final $lbrace = Terminal('{');
  final $lbracket = Terminal('[');
  final $number = Terminal<num>('number');
  final $null = Terminal('null');
  final $rbrace = Terminal('}');
  final $rbracket = Terminal(']');
  final $semicolon = Terminal(':');
  final $string = Terminal<String>('string');
  final $true = Terminal<bool>('true');

  // Subterminals
  final _char = Subterminal<int>('char');
  final _escaped = Subterminal<int>('escaped');
  final _hexdig = Subterminal<int>('hexdig');
  final _hexdig4 = Subterminal<int>('hexdig4');
  final _unescaped = Subterminal<int>('unescaped');
  final _ws = Subterminal('ws');

  // Nonterminals
  array << seqm([$lbracket], values.opt, [$rbracket]).map((r) => r ?? []);

  json << seqm([$leadingSpaces], value, [$eof]);

  member <<
      seqfl($string, [$semicolon], value).map((r) => MapEntry(r.$1, r.$2));

  members << repsep(member, $comma);

  object <<
      seqm([$lbrace], members.opt, [$rbrace])
          .map((r) => {}..addEntries(r ?? []));

  value << object;
  value << array;
  value << $string;
  value << $number;
  value << $true;
  value << $false;
  value << $null;

  values << repsep(value, $comma);

  // Terminals
  $comma << seq([literal(','), _ws]);

  $eof << not(any());

  $false << seqr([literal('false'), _ws], false);

  $lbrace << seq([literal('{'), _ws]);

  $leadingSpaces << _ws;

  $lbracket << seq([literal('['), _ws]);

  $null << seqr([literal('null'), _ws], null);

  final zero = '0'.r;
  final digit = '0-9'.r;
  final minus = '-'.r;
  final integer = alt<dynamic>([
    zero,
    seq(['1-9'.r, digit.star])
  ]);
  final frac = seq(['.'.r, digit.plus]);
  final exp = seq(['eE'.r, '+-'.r.opt, digit.plus]);

  $number <<
      seqf(cap(seq([minus.opt, integer, frac.opt, exp.opt])), [_ws])
          .map(parseNumber);

  $rbrace << seq([literal('}'), _ws]);

  $rbracket << seq([literal(']'), _ws]);

  $semicolon << seq([literal(':'), _ws]);

  $string <<
      seqm([literal('"')], _char.star, [literal('"'), _ws])
          .map((r) => String.fromCharCodes(r));

  $true << seqr([literal('true'), _ws], true);

  // Subterminals
  _char << _unescaped;
  _char << seql([r'\\'.r], _escaped);

  _escaped << r'\u22\u2f\u5c'.r;
  _escaped << seqr(['b'.r], 0x08);
  _escaped << seqr(['f'.r], 0x0c);
  _escaped << seqr(['n'.r], 0x0a);
  _escaped << seqr(['r'.r], 0x0d);
  _escaped << seqr(['t'.r], 0x09);
  _escaped << seqr(['v'.r], 0x0b);
  _escaped << seql(['u'.r], _hexdig4).map((r) => r);

  _hexdig << 'a-f'.r.map((c) => c - 97);
  _hexdig << 'A-F'.r.map((c) => c - 65);
  _hexdig << '0-9'.r.map((c) => c - 48);

  _hexdig4 <<
      seq4(_hexdig, _hexdig, _hexdig, _hexdig)
          .map((r) => r.$1 * 0xfff + r.$2 * 0xff + r.$3 * 0xf + r.$4);

  _unescaped << r'\u20-\u21\u23-\u5b\u5d-\u10ffff'.r;

  _ws << r' \n\r\t'.r.star;

  final builder = GrammarBuilder();
  return builder.build(json);
}

Parser<E> compileGrammar<E>(Grammar<E> grammar,
    [GrammarCompilerOptions options = const GrammarCompilerOptions()]) {
  final compiler = GrammarCompiler<E>(options);
  return compiler.compile(grammar);
}

```

To be continued...