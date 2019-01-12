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
  final _store = HashMap<K, _ExpiringValue<V>>();

  Cache([this._timeout = const Duration(minutes: 10)]) {
    /// Setup a periodic purging of expired items
    Timer.periodic(
      _timeout,
      (_) => _purge(),
    );
  }

  /// Add an item to the store and set an expiration
  void _add(K key, V value) {
    _store[key] = _ExpiringValue(value, _timeout);
  }

  /// Remove an item from the store and expire it
  void expire(K key) {
    _store.remove(key);
  }

  /// Read an item from the store directly. Not recommended.
  V read(K key) => _store[key]?.value;

  /// The recommended method of reading. Provide a key and a fetching method.
  /// If the key has expired, it will automatically perform the fetching operation.
  ///
  /// Note: we cannot explicitly return `null` values
  Future<V> fetch(K key, FutureOr<V> futureValue) async {
    final item = _store[key];

    if (item?.value == null || item.isExpired) {
      final newValue = await futureValue;
      _add(key, newValue);
      return newValue;
    }

    return item?.value;
  }

  /// Search _expirations for expired keys and remove them from the cache.
  void _purge() {
    _store.removeWhere((key, value) => value.isExpired);
  }
}

/// A helper class for an expiring value
class _ExpiringValue<T> {
  final T value;
  final DateTime expiration;

  bool get isExpired => expiration.isBefore(DateTime.now());

  _ExpiringValue(this.value, Duration timeout)
      : expiration = DateTime.now().add(timeout);
}
