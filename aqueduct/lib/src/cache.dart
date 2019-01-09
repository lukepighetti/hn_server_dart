import 'dart:collection';
import 'dart:async';

class Cache<K, V> {
  final Duration _timeout;

  Cache([this._timeout = const Duration(minutes: 10)]) {
    final purgeTime = Duration(seconds: 1);

    Timer.periodic(
      purgeTime,
      (_) => _purge(),
    );
  }

  final _store = HashMap<K, V>();
  final _expirations = HashMap<K, DateTime>();

  void _add(K key, V value) {
    _store[key] = value;
    _expirations[key] = DateTime.now().add(_timeout);
  }

  void _remove(K key) {
    _store.remove(key);
    _expirations.remove(key);
  }

  V read(K key) => _store[key];

  Future<V> fetch(K key, Future<V> futureValue) async {
    final value = _store[key];

    if (value == null) {
      final newValue = await futureValue;
      _add(key, newValue);
      return newValue;
    }

    return value;
  }

  void _purge() {
    final now = DateTime.now();
    final keys =
        _expirations.entries.where((m) => now.isAfter(m.value)).map((m) => m.key);

    if (keys.isNotEmpty) {
      keys.forEach((key) => _remove(key));
      print('purged ${keys.length} keys');
    }
  }
}
