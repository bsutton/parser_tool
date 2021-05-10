part of '../parsers.dart';

class Sequence2Parser<E1, E2> extends Parser<Tuple2<E1, E2>> {
  final Parser<E1> p1;

  final Parser<E2> p2;

  Sequence2Parser(this.p1, this.p2, {String? source}) : super(source: source);

  @override
  bool fastParse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    if (p1.fastParse(state)) {
      if (p2.fastParse(state)) {
        return true;
      }
    }

    state.pos = pos;
    state.ch = ch;
    return false;
  }

  @override
  Sequence2RepeaterParser<E1, E2> getRepeater(int min, int max,
      {String? source}) {
    return Sequence2RepeaterParser<E1, E2>(min, max, p1, p2, source: source);
  }

  @override
  ParseResult<Tuple2<E1, E2>>? parse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    final r1 = p1.parse(state);
    if (r1 != null) {
      final r2 = p2.parse(state);
      if (r2 != null) {
        return ParseResult(Tuple2(r1.value, r2.value));
      }
    }

    state.pos = pos;
    state.ch = ch;
  }
}

class Sequence2RepeaterParser<E1, E2> extends RepeaterParser<Tuple2<E1, E2>> {
  final Parser<E1> p1;

  final Parser<E2> p2;

  Sequence2RepeaterParser(int min, int max, this.p1, this.p2, {String? source})
      : super(min, max, source: source);

  @override
  bool fastParse(ParseState state) {
    var count = 0;
    while (count < max) {
      final ch = state.ch;
      final pos = state.pos;
      if (p1.fastParse(state)) {
        if (p2.fastParse(state)) {
          count++;
          continue;
        }
      }

      state.pos = pos;
      state.ch = ch;
      break;
    }

    return count >= min;
  }

  @override
  ParseResult<List<Tuple2<E1, E2>>>? parse(ParseState state) {
    final list = <Tuple2<E1, E2>>[];
    while (list.length < max) {
      final ch = state.ch;
      final pos = state.pos;
      final r1 = p1.parse(state);
      if (r1 != null) {
        final r2 = p2.parse(state);
        if (r2 != null) {
          final r = Tuple2(r1.value, r2.value);
          list.add(r);
          continue;
        }
      }

      state.pos = pos;
      state.ch = ch;
      break;
    }

    if (list.length >= min) {
      return ParseResult(list);
    }
  }
}

class Sequence3Parser<E1, E2, E3> extends Parser<Tuple3<E1, E2, E3>> {
  final Parser<E1> p1;

  final Parser<E2> p2;

  final Parser<E3> p3;

  Sequence3Parser(this.p1, this.p2, this.p3, {String? source})
      : super(source: source);

  @override
  bool fastParse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    if (p1.fastParse(state)) {
      if (p2.fastParse(state)) {
        if (p3.fastParse(state)) {
          return true;
        }
      }
    }

    state.pos = pos;
    state.ch = ch;
    return false;
  }

  @override
  ParseResult<Tuple3<E1, E2, E3>>? parse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    final r1 = p1.parse(state);
    if (r1 != null) {
      final r2 = p2.parse(state);
      if (r2 != null) {
        final r3 = p3.parse(state);
        if (r3 != null) {
          final r = Tuple3(r1.value, r2.value, r3.value);
          return ParseResult(r);
        }
      }
    }

    state.pos = pos;
    state.ch = ch;
  }
}

class Sequence4Parser<E1, E2, E3, E4> extends Parser<Tuple4<E1, E2, E3, E4>> {
  final Parser<E1> p1;

  final Parser<E2> p2;

  final Parser<E3> p3;

  final Parser<E4> p4;

  Sequence4Parser(this.p1, this.p2, this.p3, this.p4, {String? source})
      : super(source: source);

  @override
  bool fastParse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    if (p1.fastParse(state)) {
      if (p2.fastParse(state)) {
        if (p3.fastParse(state)) {
          if (p4.fastParse(state)) {
            return true;
          }
        }
      }
    }

    state.pos = pos;
    state.ch = ch;
    return false;
  }

  @override
  ParseResult<Tuple4<E1, E2, E3, E4>>? parse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    final r1 = p1.parse(state);
    if (r1 != null) {
      final r2 = p2.parse(state);
      if (r2 != null) {
        final r3 = p3.parse(state);
        if (r3 != null) {
          final r4 = p4.parse(state);
          if (r4 != null) {
            final r = Tuple4(r1.value, r2.value, r3.value, r4.value);
            return ParseResult(r);
          }
        }
      }
    }

    state.pos = pos;
    state.ch = ch;
  }
}

class Sequence5Parser<E1, E2, E3, E4, E5>
    extends Parser<Tuple5<E1, E2, E3, E4, E5>> {
  final Parser<E1> p1;

  final Parser<E2> p2;

  final Parser<E3> p3;

  final Parser<E4> p4;

  final Parser<E5> p5;

  Sequence5Parser(this.p1, this.p2, this.p3, this.p4, this.p5, {String? source})
      : super(source: source);

  @override
  bool fastParse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    if (p1.fastParse(state)) {
      if (p2.fastParse(state)) {
        if (p3.fastParse(state)) {
          if (p4.fastParse(state)) {
            if (p5.fastParse(state)) {
              return true;
            }
          }
        }
      }
    }

    state.pos = pos;
    state.ch = ch;
    return false;
  }

  @override
  ParseResult<Tuple5<E1, E2, E3, E4, E5>>? parse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    final r1 = p1.parse(state);
    if (r1 != null) {
      final r2 = p2.parse(state);
      if (r2 != null) {
        final r3 = p3.parse(state);
        if (r3 != null) {
          final r4 = p4.parse(state);
          if (r4 != null) {
            final r5 = p5.parse(state);
            if (r5 != null) {
              final r =
                  Tuple5(r1.value, r2.value, r3.value, r4.value, r5.value);
              return ParseResult(r);
            }
          }
        }
      }
    }

    state.pos = pos;
    state.ch = ch;
  }
}

class Sequence6Parser<E1, E2, E3, E4, E5, E6>
    extends Parser<Tuple6<E1, E2, E3, E4, E5, E6>> {
  final Parser<E1> p1;

  final Parser<E2> p2;

  final Parser<E3> p3;

  final Parser<E4> p4;

  final Parser<E5> p5;

  final Parser<E6> p6;

  Sequence6Parser(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6,
      {String? source})
      : super(source: source);

  @override
  bool fastParse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    if (p1.fastParse(state)) {
      if (p2.fastParse(state)) {
        if (p3.fastParse(state)) {
          if (p4.fastParse(state)) {
            if (p5.fastParse(state)) {
              if (p6.fastParse(state)) {
                return true;
              }
            }
          }
        }
      }
    }

    state.pos = pos;
    state.ch = ch;
    return false;
  }

  @override
  ParseResult<Tuple6<E1, E2, E3, E4, E5, E6>>? parse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    final r1 = p1.parse(state);
    if (r1 != null) {
      final r2 = p2.parse(state);
      if (r2 != null) {
        final r3 = p3.parse(state);
        if (r3 != null) {
          final r4 = p4.parse(state);
          if (r4 != null) {
            final r5 = p5.parse(state);
            if (r5 != null) {
              final r6 = p6.parse(state);
              if (r6 != null) {
                final r = Tuple6(
                    r1.value, r2.value, r3.value, r4.value, r5.value, r6.value);
                return ParseResult(r);
              }
            }
          }
        }
      }
    }

    state.pos = pos;
    state.ch = ch;
  }
}

class Sequence7Parser<E1, E2, E3, E4, E5, E6, E7>
    extends Parser<Tuple7<E1, E2, E3, E4, E5, E6, E7>> {
  final Parser<E1> p1;

  final Parser<E2> p2;

  final Parser<E3> p3;

  final Parser<E4> p4;

  final Parser<E5> p5;

  final Parser<E6> p6;

  final Parser<E7> p7;

  Sequence7Parser(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7,
      {String? source})
      : super(source: source);

  @override
  bool fastParse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    if (p1.fastParse(state)) {
      if (p2.fastParse(state)) {
        if (p3.fastParse(state)) {
          if (p4.fastParse(state)) {
            if (p5.fastParse(state)) {
              if (p6.fastParse(state)) {
                if (p7.fastParse(state)) {
                  return true;
                }
              }
            }
          }
        }
      }
    }

    state.pos = pos;
    state.ch = ch;
    return false;
  }

  @override
  ParseResult<Tuple7<E1, E2, E3, E4, E5, E6, E7>>? parse(ParseState state) {
    final ch = state.ch;
    final pos = state.pos;
    final r1 = p1.parse(state);
    if (r1 != null) {
      final r2 = p2.parse(state);
      if (r2 != null) {
        final r3 = p3.parse(state);
        if (r3 != null) {
          final r4 = p4.parse(state);
          if (r4 != null) {
            final r5 = p5.parse(state);
            if (r5 != null) {
              final r6 = p6.parse(state);
              if (r6 != null) {
                final r7 = p7.parse(state);
                if (r7 != null) {
                  final r = Tuple7(r1.value, r2.value, r3.value, r4.value,
                      r5.value, r6.value, r7.value);
                  return ParseResult(r);
                }
              }
            }
          }
        }
      }
    }

    state.pos = pos;
    state.ch = ch;
  }
}
