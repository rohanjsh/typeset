import 'package:typeset/src/config/autolink_config.dart';
import 'package:typeset/src/document.dart';

/// LRU cache for compiled [TypeSetDocument]s.
///
/// Keyed by (inputText, autoLinkConfig). Dart's insertion-ordered Map
/// gives us O(1) LRU promotion via remove + re-insert.
final class TypeSetDocumentCache {
  /// Creates a cache with [maxSize] entries.
  TypeSetDocumentCache({this.maxSize = defaultMaxSize}) {
    if (maxSize <= 0) {
      throw ArgumentError.value(maxSize, 'maxSize', 'must be greater than 0');
    }
  }

  /// Default max entries.
  static const int defaultMaxSize = 256;

  /// Maximum number of cached documents.
  final int maxSize;
  final _cache = <(String, TypeSetAutoLinkConfig?), TypeSetDocument>{};

  int _hits = 0;
  int _misses = 0;

  /// Current number of cached entries.
  int get size => _cache.length;

  /// Number of cache hits.
  int get hits => _hits;

  /// Number of cache misses.
  int get misses => _misses;

  /// Hit rate as a ratio (0.0–1.0).
  double get hitRate {
    final total = _hits + _misses;
    return total == 0 ? 0.0 : _hits / total;
  }

  /// Returns a cached document or compiles and caches a new one.
  TypeSetDocument getOrCompile(
    String text, {
    required TypeSetAutoLinkConfig? autoLinkConfig,
  }) {
    final key = (text, autoLinkConfig);
    final cached = _cache[key];

    if (cached != null) {
      _hits++;
      _cache
        ..remove(key)
        ..[key] = cached;
      return cached;
    }

    _misses++;

    if (_cache.length >= maxSize) {
      _cache.remove(_cache.keys.first);
    }

    final doc = TypeSetDocument.compile(text, autoLinkConfig: autoLinkConfig);
    _cache[key] = doc;
    return doc;
  }

  /// Clears all cached entries and resets stats.
  void clear() {
    _cache.clear();
    _hits = 0;
    _misses = 0;
  }

  @override
  String toString() => 'TypeSetDocumentCache('
      'size: $size/$maxSize, '
      'hitRate: ${(hitRate * 100).toStringAsFixed(1)}%)';
}
