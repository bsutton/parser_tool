part of '../../expressions.dart';

class AnyCharacterExpression extends Expression<int> {
  @override
  ExpressionKind get kind => ExpressionKind.anyCharater;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitAnyCharacter(this);
  }

  @override
  String toString() => '.';

  @override
  void visitChildren<R>(ExpressionVisitor<R> visitor) {
    return;
  }
}
