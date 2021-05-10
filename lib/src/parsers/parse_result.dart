part of '../parsers.dart';

class ParseResult<E> {
  final E value;

  const ParseResult(this.value);

  @override
  String toString() => '$runtimeType';
}
