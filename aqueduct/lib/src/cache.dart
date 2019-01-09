import 'dart:collection';
import 'dart:async';

class Cache<K, V> {
  final Duration _timeout;

  Cache([this._timeout = const Duration(minutes: 10)]) {
    final purgeTime = Duration(seconds: _timeout.inSeconds ~/ 100);

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

  V _remove(K key) {
    final value = _store[key];

    if (value != null) {
      _store.remove(key);
      _expirations.remove(key);
    }

    return value;
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
        _expirations.entries.where((m) => m.value.isBefore(now)).map((m) => m.key);

    keys.forEach((key) => _remove(key));
  }
}
