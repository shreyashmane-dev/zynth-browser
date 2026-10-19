import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../models/om_search_result.dart';
import '../../models/search_engine.dart';
import '../../services/preferences_service.dart';
import 'search_provider.dart';

/// Zynth Search Provider implementation powered by the OM Search backend.
/// Uses the verified FastAPI contract (/api/v1/search, /api/v1/suggestions, /api/v1/health).
class ZynthSearchProvider implements SearchProvider {
  final PreferencesService _prefs = PreferencesService();

  @override
  SearchEngineType get engineType => SearchEngineType.zynth;

  @override
  String get name => AppConstants.engineZynthName;

  /// Base URL configured for OM Search (e.g., http://10.0.2.2:8000 for Android emulator or http://127.0.0.1:8000).
  String get baseUrl => _prefs.getOmBackendUrl();

  @override
  String buildSearchUrl(String query) {
    final encoded = Uri.encodeComponent(query.trim());
    final cleanBase = baseUrl.replaceAll(RegExp(r'/+$'), '');
    return '$cleanBase${AppConstants.omSearchApiPath}?q=$encoded';
  }

  /// Check whether the OM Search backend is reachable and healthy.
  Future<bool> checkHealth() async {
    try {
      final cleanBase = baseUrl.replaceAll(RegExp(r'/+$'), '');
      final uri = Uri.parse('$cleanBase${AppConstants.omHealthApiPath}');
      final response = await http.get(uri).timeout(const Duration(seconds: 4));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Execute a structured search query against OM Search FastAPI.
  /// Returns typed [OmSearchResponse].
  Future<OmSearchResponse> search(String query, {int page = 1, int size = 10}) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      throw ArgumentError('Query string cannot be empty.');
    }

    final cleanBase = baseUrl.replaceAll(RegExp(r'/+$'), '');
    final uri = Uri.parse('$cleanBase${AppConstants.omSearchApiPath}').replace(
      queryParameters: {
        'q': cleanQuery,
        'page': page.toString(),
        'size': size.toString(),
      },
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return OmSearchResponse.fromJson(data);
      } else {
        throw Exception(
          'Zynth Search server returned status code ${response.statusCode}: ${response.body}',
        );
      }
    } on TimeoutException {
      throw TimeoutException('Connection to Zynth Search backend timed out after 6s.');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getSuggestions(String prefix) async {
    final clean = prefix.trim();
    if (clean.isEmpty) return const [];

    final cleanBase = baseUrl.replaceAll(RegExp(r'/+$'), '');
    final uri = Uri.parse('$cleanBase${AppConstants.omSuggestionsApiPath}').replace(
      queryParameters: {
        'q': clean,
        'limit': '6',
      },
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic>? suggestions = data['suggestions'] as List<dynamic>?;
        if (suggestions != null) {
          return suggestions.map((e) => e.toString()).toList();
        }
      }
    } catch (_) {
      // Do not throw on autocomplete failure
    }
    return const [];
  }
}
