part of '../../expressions.dart';

class LiteralExpression extends Expression<String> {
  final String text;

  LiteralExpression(this.text);

  @override
  ExpressionKind get kind => ExpressionKind.literal;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitLiteral(this);
  }

  @override
  String toString() {
    var value = text;
    value = value.replaceAll('\\', r'\\');
    value = value.replaceAll('\b', r'\b');
    value = value.replaceAll('\f', r'\f');
    value = value.replaceAll('\n', r'\n');
    value = value.replaceAll('\r', r'\r');
    value = value.replaceAll('\t', r'\t');
    value = value.replaceAll('\v', r'\v');
    value = value.replaceAll('"', '\\"');
    value = value.replaceAll('\$', r'\$');
    value = '"$value"';
    return value;
  }

  @override
  void visitChildren<R>(ExpressionVisitor<R> visitor) {
    return;
  }
}
