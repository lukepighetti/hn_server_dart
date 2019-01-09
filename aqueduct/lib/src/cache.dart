import 'dart:collection';
import 'dart:async';

/// A simple key value cache with a default TTL of 10 minutes.
///
/// Read by providing an id and a fetching method. If the
/// item is in cache it will ignore the fetching method.
///
/// Actual TTL may drift ±10%.

class Cache<K, V> {
  final Duration _timeout;

  /// Contains the cached values for each key
  final _store = HashMap<K, V>();

  /// Contains the timeout dates for each key
  final _expirations = HashMap<K, DateTime>();

  Cache([this._timeout = const Duration(minutes: 10)]) {
    /// Purge stale keys to reduce memory usage
    final purgeTime = _timeout;

    /// Setup a periodic purging of expired items
    Timer.periodic(
      purgeTime,
      (_) => _purge(),
    );
  }

  /// Add an item to the store and set an expiration
  void _add(K key, V value) {
    _store[key] = value;
    _expirations[key] = DateTime.now().add(_timeout);
  }

  /// Remove an item from the store and expire it
  void _remove(K key) {
    _store.remove(key);
    _expirations.remove(key);
  }

  /// Read an item from the store directly. Not recommended.
  V read(K key) => _store[key];

  /// The recommended method of reading. Provide a key and a fetching method.
  /// If the key has expired, it will automatically perform the fetching operation.
  ///
  /// Note: we cannot explicitly return `null` values
  Future<V> fetch(K key, Future<V> futureValue) async {
    final value = _store[key];
    final expiration = _expirations[key];
    final now = DateTime.now();

    if (value == null || expiration == null || now.isAfter(expiration)) {
      final newValue = await futureValue;
      _add(key, newValue);
      return newValue;
    }

    return value;
  }

  /// Search _expirations for expired keys and remove them from the cache.
  void _purge() {
    final now = DateTime.now();

    _expirations.forEach((key, expiration) {
      if (now.isAfter(expiration)) {
        _remove(key);

        print('purged ${key}');
      }
    });
  }
}
