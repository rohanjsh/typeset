import 'package:flutter_test/flutter_test.dart';
import 'package:typeset/typeset.dart';

void main() {
  group('TypeSetAutoLinkConfig', () {
    test('defensively copies allowedSchemes', () {
      final schemes = <String>{'https'};
      final config = TypeSetAutoLinkConfig(allowedSchemes: schemes);

      schemes.add('mailto');

      expect(config.allowedSchemes, equals({'https'}));
    });

    test('exposes allowedSchemes as unmodifiable', () {
      final config = TypeSetAutoLinkConfig(
        allowedSchemes: const <String>{'https'},
      );

      expect(() => config.allowedSchemes.add('http'), throwsUnsupportedError);
    });

    test('uses deep equality and hashCode for equivalent scheme sets', () {
      final first = TypeSetAutoLinkConfig(
        allowedSchemes: const <String>{'https', 'http'},
      );
      final second = TypeSetAutoLinkConfig(
        allowedSchemes: const <String>{'http', 'https'},
      );

      expect(first, equals(second));
      expect(first.hashCode, equals(second.hashCode));
    });

    test('compares allowedDomains by pattern and flags', () {
      final first = TypeSetAutoLinkConfig(
        allowedDomains: RegExp(
          r'^flutter\.dev$',
          caseSensitive: false,
          multiLine: true,
        ),
      );
      final second = TypeSetAutoLinkConfig(
        allowedDomains: RegExp(
          r'^flutter\.dev$',
          caseSensitive: false,
          multiLine: true,
        ),
      );

      expect(first, equals(second));
      expect(first.hashCode, equals(second.hashCode));
    });
  });

  group('TypeSetConfig', () {
    test('compares equal when autolink configs are semantically equal', () {
      final first = TypeSetConfig(
        autoLinkConfig: TypeSetAutoLinkConfig(
          allowedSchemes: const <String>{'https'},
          allowedDomains: RegExp(r'^flutter\.dev$'),
        ),
      );
      final second = TypeSetConfig(
        autoLinkConfig: TypeSetAutoLinkConfig(
          allowedSchemes: const <String>{'https'},
          allowedDomains: RegExp(r'^flutter\.dev$'),
        ),
      );

      expect(first, equals(second));
      expect(first.hashCode, equals(second.hashCode));
    });
  });

  group('TypeSetDocumentCache', () {
    late TypeSetDocumentCache cache;

    setUp(() => cache = TypeSetDocumentCache(maxSize: 3));

    test('uses 256 documents as the default maxSize', () {
      expect(
        TypeSetDocumentCache().maxSize,
        TypeSetDocumentCache.defaultMaxSize,
      );
      expect(TypeSetDocumentCache.defaultMaxSize, 256);
    });

    test('rejects non-positive maxSize', () {
      expect(() => TypeSetDocumentCache(maxSize: 0), throwsArgumentError);
      expect(() => TypeSetDocumentCache(maxSize: -1), throwsArgumentError);
    });

    test('starts empty with zero stats', () {
      expect(cache.size, 0);
      expect(cache.hits, 0);
      expect(cache.misses, 0);
      expect(cache.hitRate, 0.0);
    });

    test('returns identical document instance on cache hit', () {
      final first = cache.getOrCompile('hello *world*', autoLinkConfig: null);
      final second = cache.getOrCompile('hello *world*', autoLinkConfig: null);

      expect(identical(first, second), isTrue);
      expect(cache.hits, 1);
      expect(cache.misses, 1);
      expect(cache.size, 1);
    });

    test('different text produces a cache miss', () {
      cache
        ..getOrCompile('text A', autoLinkConfig: null)
        ..getOrCompile('text B', autoLinkConfig: null);

      expect(cache.misses, 2);
      expect(cache.size, 2);
    });

    test('different autoLinkConfig produces a cache miss for same text', () {
      final cfg1 = TypeSetAutoLinkConfig(
        allowedSchemes: const {'https'},
      );
      final cfg2 = TypeSetAutoLinkConfig(
        allowedSchemes: const {'http', 'https'},
      );

      cache
        ..getOrCompile('visit https://example.com', autoLinkConfig: cfg1)
        ..getOrCompile('visit https://example.com', autoLinkConfig: cfg2);

      expect(cache.misses, 2);
      expect(cache.size, 2);
    });

    test('evicts least-recently-used entry when maxSize is exceeded', () {
      cache
        ..getOrCompile('doc A', autoLinkConfig: null) // slot 1
        ..getOrCompile('doc B', autoLinkConfig: null) // slot 2
        ..getOrCompile('doc C', autoLinkConfig: null) // slot 3 — full
        ..getOrCompile('doc A', autoLinkConfig: null) // promote A → B is LRU
        ..getOrCompile('doc D', autoLinkConfig: null); // evicts B

      expect(cache.size, 3);
      // B was evicted — looking it up must be a miss.
      final hitsBeforeB = cache.hits;
      cache.getOrCompile('doc B', autoLinkConfig: null);
      expect(cache.hits, hitsBeforeB); // no new hit
    });

    test('clear() resets size and stats', () {
      cache
        ..getOrCompile('doc A', autoLinkConfig: null)
        ..getOrCompile('doc A', autoLinkConfig: null)
        ..clear();

      expect(cache.size, 0);
      expect(cache.hits, 0);
      expect(cache.misses, 0);
    });

    test('hitRate reflects ratio correctly', () {
      cache
        ..getOrCompile('x', autoLinkConfig: null) // miss
        ..getOrCompile('x', autoLinkConfig: null) // hit
        ..getOrCompile('x', autoLinkConfig: null); // hit

      expect(cache.hitRate, closeTo(2 / 3, 0.001));
    });

    test('toString includes size and hitRate', () {
      cache
        ..getOrCompile('ping', autoLinkConfig: null)
        ..getOrCompile('ping', autoLinkConfig: null);

      final s = cache.toString();
      expect(s, contains('TypeSetDocumentCache('));
      expect(s, contains('1/3'));
      expect(s, contains('%'));
    });

    test('null autoLinkConfig and non-null are separate cache keys', () {
      cache
        ..getOrCompile('text', autoLinkConfig: null)
        ..getOrCompile('text', autoLinkConfig: TypeSetAutoLinkConfig());

      expect(cache.misses, 2);
    });
  });
}
