import 'package:typeset/src/models/typeset_autolink_config.dart';
import 'package:typeset/src/models/typeset_document.dart';

/// An LRU cache for compiled [TypeSetDocument]s.
///
/// Documents are keyed by their input text and AutoLink config, so a change
/// to either automatically produces a cache miss and recompiles cleanly.
///
/// Dart's insertion-ordered [Map] gives us O(1) LRU promotion via
/// remove + re-insert on every hit, and eviction of the first key on overflow.
///
/// Set the global document cache to `null` to disable caching.
final class TypeSetDocumentCache {
  /// Creates an LRU cache that retains at most [maxSize] documents.
  TypeSetDocumentCache({this.maxSize = TypeSetDocumentCache.defaultMaxSize}) {
    if (maxSize <= 0) {
      throw ArgumentError.value(maxSize, 'maxSize', 'must be greater than 0');
    }
  }

  /// Default maximum number of compiled documents to retain.
  static const int defaultMaxSize = 256;

  /// Maximum number of compiled documents to retain.
  final int maxSize;

  // (text, autoLinkConfig) → document, kept in insertion/access order.
  final _cache = <(String, TypeSetAutoLinkConfig?), TypeSetDocument>{};

  int _hits = 0;
  int _misses = 0;

  /// Number of documents currently held in cache.
  int get size => _cache.length;

  /// Total cache hits since creation or last [clear].
  int get hits => _hits;

  /// Total cache misses since creation or last [clear].
  int get misses => _misses;

  /// Fraction of lookups served from cache. Returns `0.0` when unused.
  double get hitRate {
    final total = _hits + _misses;
    return total == 0 ? 0.0 : _hits / total;
  }

  /// Returns the cached document for [text] + [autoLinkConfig].
  ///
  /// Compiles and caches a new document on a miss.
  /// Promotes the entry to most-recently-used on a hit.
  TypeSetDocument getOrCompile(
    String text, {
    required TypeSetAutoLinkConfig? autoLinkConfig,
  }) {
    final key = (text, autoLinkConfig);
    final cached = _cache[key];

    if (cached != null) {
      _hits++;
      // Promote to most-recently-used by moving to end.
      _cache
        ..remove(key)
        ..[key] = cached;
      return cached;
    }

    _misses++;

    if (_cache.length >= maxSize) {
      _cache.remove(_cache.keys.first); // evict least-recently-used
    }

    final doc = TypeSetDocument.compile(text, autoLinkConfig: autoLinkConfig);
    _cache[key] = doc;
    return doc;
  }

  /// Clears all cached documents and resets hit/miss statistics.
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
