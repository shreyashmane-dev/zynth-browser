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
      expect(
        url,
        equals('https://www.google.com/search?q=best%20Python%20courses'),
      );

      final urlSpecial = google.buildSearchUrl('c++ & rust programming');
      expect(
        urlSpecial,
        equals(
          'https://www.google.com/search?q=c%2B%2B%20%26%20rust%20programming',
        ),
      );
    });

    test('ZynthSearchProvider builds URL pointing to OM Search backend', () {
      final zynth = ZynthSearchProvider();
      expect(zynth.engineType, equals(SearchEngineType.zynth));
      expect(zynth.name, equals('Zynth Search'));

      final url = zynth.buildSearchUrl('distributed systems');
      expect(url, contains(AppConstants.omSearchApiPath));
      expect(url, contains('q=distributed%20systems'));
    });

    test(
      'OmSearchResponse correctly deserializes OM Search FastAPI schema',
      () {
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
            },
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
        expect(
          firstResult.highlights,
          contains('<mark>Machine Learning</mark> foundations'),
        );
      },
    );

    test(
      'OmSearchResponse parses real live response from Render deployment',
      () {
        final liveRenderPayload = {
          'query': 'test',
          'total': 45,
          'page': 1,
          'size': 10,
          'total_pages': 5,
          'took_ms': 40.13,
          'results': [
            {
              'id': '3037f02d7418d96f',
              'url': 'https://arcol.io/customer-stories/how-slantis-uses-arcol-to-move-faster-test-smarter-and-design-together',
              'canonical_url': 'https://arcol.io/customer-stories/how-slantis-uses-arcol-to-move-faster-test-smarter-and-design-together',
              'domain': 'arcol.io',
              'title': 'How Slantis Uses Arcol To Move Faster Test Smarter And Design Together',
              'snippet': 'Live crawled real-web document from arcol.io. Indexed by OM Search crawler.',
              'language': 'en',
              'score': 1.405,
              'highlights': [
                'Live crawled real-web document from arcol.io. Indexed by OM Search crawler.',
              ],
            },
          ],
          'is_early_index': true,
          'message':
              'Results retrieved and ranked by Phase 3 intelligence pipeline',
          'query_intent': 'general',
          'spelling_suggestion': null,
          'ranking_version': '3.0.0',
        };

        final response = OmSearchResponse.fromJson(liveRenderPayload);

        expect(response.query, equals('test'));
        expect(response.total, equals(45));
        expect(response.totalPages, equals(5));
        expect(response.tookMs, equals(40.13));
        expect(response.results.length, equals(1));
        expect(response.results.first.domain, equals('arcol.io'));
        expect(response.results.first.score, equals(1.405));
      },
    );
  });
}
