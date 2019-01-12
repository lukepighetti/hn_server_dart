import 'package:test/test.dart';
import "package:hn_aqueduct/services/cache.dart";

main() async {
  test("simple string", () async {
    final cache = Cache<int, String>();

    await cache.fetch(1, "one");

    expect(cache.read(1), equals("one"));
  });

  test("simple map", () async {
    final cache = Cache<int, Map>();
    final map = {"foo": "bar"};

    await cache.fetch(1, map);

    expect(cache.read(1)['foo'], equals('bar'));
  });

  /// this test is intended to illustrate that objects maintain their
  /// reference once they have been stored in the cache. For this reason,
  /// it is recommended that JSON is stored as a string instead of a Map
  test("can modify maps after they have been cached", () async {
    final cache = Cache<int, Map>();
    final map = {"foo": "bar"};

    await cache.fetch(1, map);

    map['foo'] = 'baz';

    expect(cache.read(1)['foo'], equals('baz'));
  });

  test("purge", () async {
    final cache = Cache<int, String>(Duration(milliseconds: 10));

    await cache.fetch(1, "one");

    expect(cache.read(1), equals("one"));

    await Future.delayed(Duration(milliseconds: 200)).then(expectAsync1((_) {
      expect(cache.read(1), isNull);
    }));
  });

  test("expire", () async {
    final cache = Cache<int, String>();

    await cache.fetch(1, "one");
    expect(cache.read(1), equals("one"));

    await cache.expire(1);
    expect(cache.read(1), isNull);
  });
}
