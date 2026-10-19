import 'package:flutter_test/flutter_test.dart';
import 'package:zynth_browser/models/bookmark.dart';

void main() {
  group('Bookmark Model Tests', () {
    test('Bookmark serialization to SQLite map and deserialization', () {
      final now = DateTime.now();
      final bookmark = Bookmark(
        id: 1,
        title: 'Zynth Home',
        url: 'https://zynth.dev',
        createdAt: now,
        faviconUrl: 'https://zynth.dev/favicon.ico',
      );

      final map = bookmark.toMap();
      expect(map['id'], equals(1));
      expect(map['title'], equals('Zynth Home'));
      expect(map['url'], equals('https://zynth.dev'));
      expect(map['createdAt'], equals(now.millisecondsSinceEpoch));
      expect(map['faviconUrl'], equals('https://zynth.dev/favicon.ico'));

      final reconstructed = Bookmark.fromMap(map);
      expect(reconstructed.id, equals(1));
      expect(reconstructed.title, equals('Zynth Home'));
      expect(reconstructed.url, equals('https://zynth.dev'));
      expect(reconstructed.createdAt.millisecondsSinceEpoch, equals(now.millisecondsSinceEpoch));
      expect(reconstructed.faviconUrl, equals('https://zynth.dev/favicon.ico'));
    });

    test('Bookmark copyWith updates fields correctly', () {
      final bookmark = Bookmark(
        id: 1,
        title: 'Old Title',
        url: 'https://example.com',
        createdAt: DateTime.now(),
      );

      final updated = bookmark.copyWith(title: 'New Title');
      expect(updated.id, equals(1));
      expect(updated.title, equals('New Title'));
      expect(updated.url, equals('https://example.com'));
    });

    test('Bookmark equality is based on URL', () {
      final b1 = Bookmark(title: 'A', url: 'https://example.com', createdAt: DateTime.now());
      final b2 = Bookmark(title: 'B', url: 'https://example.com', createdAt: DateTime.now());
      final b3 = Bookmark(title: 'A', url: 'https://different.com', createdAt: DateTime.now());

      expect(b1, equals(b2));
      expect(b1, isNot(equals(b3)));
    });
  });
}
