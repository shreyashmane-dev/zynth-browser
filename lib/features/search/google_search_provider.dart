import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../models/search_engine.dart';
import 'search_provider.dart';

/// Google Search Provider implementation.
class GoogleSearchProvider implements SearchProvider {
  @override
  SearchEngineType get engineType => SearchEngineType.google;

  @override
  String get name => AppConstants.engineGoogleName;

  @override
  String buildSearchUrl(String query) {
    final encoded = Uri.encodeComponent(query.trim());
    return '${AppConstants.googleSearchBase}$encoded';
  }

  @override
  Future<List<String>> getSuggestions(String prefix) async {
    final clean = prefix.trim();
    if (clean.isEmpty) return const [];

    try {
      final uri = Uri.parse(
        'https://suggestqueries.google.com/complete/search?client=firefox&q=${Uri.encodeComponent(clean)}',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.length > 1 && data[1] is List) {
          return (data[1] as List).map((e) => e.toString()).toList();
        }
      }
    } catch (_) {
      // Gracefully suppress suggestion errors
    }
    return const [];
  }
}
