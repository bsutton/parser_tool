part of '../../expressions.dart';

class Sequence2Expression<E1, E2> extends SequenceExpression<Tuple2<E1, E2>> {
  final Expression<E1> e1;

  final Expression<E2> e2;

  Sequence2Expression(this.e1, this.e2) : super(UnmodifiableListView([e1, e2]));

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSequence2(this);
  }
}

class Sequence3Expression<E1, E2, E3>
    extends SequenceExpression<Tuple3<E1, E2, E3>> {
  final Expression<E1> e1;

  final Expression<E2> e2;

  final Expression<E3> e3;

  Sequence3Expression(this.e1, this.e2, this.e3)
      : super(UnmodifiableListView([e1, e2, e3]));

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSequence3(this);
  }
}

class Sequence4Expression<E1, E2, E3, E4>
    extends SequenceExpression<Tuple4<E1, E2, E3, E4>> {
  final Expression<E1> e1;

  final Expression<E2> e2;

  final Expression<E3> e3;

  final Expression<E4> e4;

  Sequence4Expression(this.e1, this.e2, this.e3, this.e4)
      : super(UnmodifiableListView([e1, e2, e3, e4]));

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSequence4(this);
  }
}

class Sequence5Expression<E1, E2, E3, E4, E5>
    extends SequenceExpression<Tuple5<E1, E2, E3, E4, E5>> {
  final Expression<E1> e1;

  final Expression<E2> e2;

  final Expression<E3> e3;

  final Expression<E4> e4;

  final Expression<E5> e5;

  Sequence5Expression(this.e1, this.e2, this.e3, this.e4, this.e5)
      : super(UnmodifiableListView([e1, e2, e3, e4, e5]));

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSequence5(this);
  }
}

class Sequence6Expression<E1, E2, E3, E4, E5, E6>
    extends SequenceExpression<Tuple6<E1, E2, E3, E4, E5, E6>> {
  final Expression<E1> e1;

  final Expression<E2> e2;

  final Expression<E3> e3;

  final Expression<E4> e4;

  final Expression<E5> e5;

  final Expression<E6> e6;

  Sequence6Expression(this.e1, this.e2, this.e3, this.e4, this.e5, this.e6)
      : super(UnmodifiableListView([e1, e2, e3, e4, e5, e6]));

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSequence6(this);
  }
}

class Sequence7Expression<E1, E2, E3, E4, E5, E6, E7>
    extends SequenceExpression<Tuple7<E1, E2, E3, E4, E5, E6, E7>> {
  final Expression<E1> e1;

  final Expression<E2> e2;

  final Expression<E3> e3;

  final Expression<E4> e4;

  final Expression<E5> e5;

  final Expression<E6> e6;

  final Expression<E7> e7;

  Sequence7Expression(
      this.e1, this.e2, this.e3, this.e4, this.e5, this.e6, this.e7)
      : super(UnmodifiableListView([e1, e2, e3, e4, e5, e6, e7]));

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitSequence7(this);
  }
}

abstract class SequenceExpression<E> extends Expression<E> {
  final List<Expression> expressions;

  SequenceExpression(this.expressions);

  @override
  ExpressionKind get kind => ExpressionKind.sequence;

  @override
  String toString() {
    return expressions.map(Expression.quote).join(' ');
  }

  @override
  void visitChildren<R>(ExpressionVisitor<R> visitor) {
    for (var i = 0; i < expressions.length; i++) {
      final child = expressions[i];
      child.accept(visitor);
    }
  }
}
