import 'package:flutter_test/flutter_test.dart';
import 'package:zynth_browser/core/constants/app_constants.dart';
import 'package:zynth_browser/features/search/google_search_provider.dart';
import 'package:zynth_browser/features/search/zynth_search_provider.dart';
import 'package:zynth_browser/models/om_search_result.dart';
import 'package:zynth_browser/models/search_engine.dart';

void main() {
  group('SearchProvider Tests', () {
    test('GoogleSearchProvider builds properly encoded search URLs', () {
      final google = GoogleSearchProvider();
      expect(google.engineType, equals(SearchEngineType.google));
      expect(google.name, equals('Google'));

      final url = google.buildSearchUrl('best Python courses');
      expect(url, equals('https://www.google.com/search?q=best%20Python%20courses'));

      final urlSpecial = google.buildSearchUrl('c++ & rust programming');
      expect(urlSpecial, equals('https://www.google.com/search?q=c%2B%2B%20%26%20rust%20programming'));
    });

    test('ZynthSearchProvider builds URL pointing to OM Search backend', () {
      final zynth = ZynthSearchProvider();
      expect(zynth.engineType, equals(SearchEngineType.zynth));
      expect(zynth.name, equals('Zynth Search'));

      final url = zynth.buildSearchUrl('distributed systems');
      expect(url, contains(AppConstants.omSearchApiPath));
      expect(url, contains('q=distributed%20systems'));
    });

    test('OmSearchResponse correctly deserializes OM Search FastAPI schema', () {
      final mockFastApiResponse = {
        'query': 'machine learning',
        'total': 42,
        'page': 1,
        'size': 10,
        'total_pages': 5,
        'took_ms': 12.4,
        'results': [
          {
            'id': 'doc-101',
            'url': 'https://example.com/ml-intro',
            'canonical_url': 'https://example.com/ml-intro',
            'domain': 'example.com',
            'title': 'Introduction to Machine Learning',
            'snippet': 'A comprehensive guide to ML foundations...',
            'score': 8.95,
            'highlights': ['<mark>Machine Learning</mark> foundations'],
          }
        ],
        'spelling_suggestion': null,
        'message': null,
      };

      final response = OmSearchResponse.fromJson(mockFastApiResponse);

      expect(response.query, equals('machine learning'));
      expect(response.total, equals(42));
      expect(response.totalPages, equals(5));
      expect(response.tookMs, equals(12.4));
      expect(response.results.length, equals(1));

      final firstResult = response.results.first;
      expect(firstResult.id, equals('doc-101'));
      expect(firstResult.url, equals('https://example.com/ml-intro'));
      expect(firstResult.domain, equals('example.com'));
      expect(firstResult.title, equals('Introduction to Machine Learning'));
      expect(firstResult.score, equals(8.95));
      expect(firstResult.highlights, contains('<mark>Machine Learning</mark> foundations'));
    });
  });
}
