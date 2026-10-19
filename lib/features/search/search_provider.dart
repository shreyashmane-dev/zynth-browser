import '../../models/search_engine.dart';

/// Abstract contract for all search engine providers in Zynth Browser.
abstract class SearchProvider {
  /// The engine type identifier.
  SearchEngineType get engineType;

  /// Human-readable provider name.
  String get name;

  /// Builds the web navigation URL for a given query string.
  String buildSearchUrl(String query);

  /// Fetches autocomplete or search suggestions for a prefix.
  Future<List<String>> getSuggestions(String prefix);
}
