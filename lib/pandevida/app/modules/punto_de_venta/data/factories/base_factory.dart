import 'dart:math';

import 'package:faker/faker.dart';

abstract class Factory<T> {
  final faker = Faker();
  final random = Random();
  T create();

  List<T> createMany([int count = 1]) {
    return List.generate(count, (_) => create());
  }

  Factory<T> times(int count) {
    return _RepeatFactory(this, count);
  }
}

class _RepeatFactory<T> extends Factory<T> {
  final Factory<T> _factory;
  final int _count;

  _RepeatFactory(this._factory, this._count);

  @override
  T create() => _factory.create();

  @override
  List<T> createMany([int? count]) {
    final actualCount = count ?? _count;
    return List.generate(actualCount, (_) => create());
  }
}
