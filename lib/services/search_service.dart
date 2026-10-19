import '../core/utils/url_parser.dart';
import '../features/search/search_provider.dart';
import '../features/search/search_provider_factory.dart';
import '../models/search_engine.dart';
import 'preferences_service.dart';

/// High-level Search Service coordinating provider routing and query execution.
class SearchService {
  final PreferencesService _prefs = PreferencesService();

  /// Gets the currently selected search provider.
  SearchProvider getActiveProvider() {
    final engineType = _prefs.getSelectedEngine();
    return SearchProviderFactory.getProvider(engineType);
  }

  /// Sets the active search engine type and persists it.
  Future<void> setActiveEngine(SearchEngineType type) async {
    await _prefs.setSelectedEngine(type);
  }

  /// Resolves the destination URL from a [UrlParseResult].
  /// Takes into account explicit shortcuts (@google, @zynth) and active provider.
  String resolveDestinationUrl(UrlParseResult parseResult) {
    if (parseResult.isDirectUrl) {
      return parseResult.targetUrl!;
    }

    if (parseResult.isInternal) {
      return parseResult.targetUrl!;
    }

    if (parseResult.isSearchQuery) {
      final query = parseResult.searchQuery ?? '';

      // Determine provider: explicit shortcut takes precedence
      SearchProvider provider;
      if (parseResult.explicitProvider == SearchEngineType.google.id) {
        provider = SearchProviderFactory.googleProvider;
      } else if (parseResult.explicitProvider == SearchEngineType.zynth.id) {
        provider = SearchProviderFactory.zynthProvider;
      } else {
        provider = getActiveProvider();
      }

      return provider.buildSearchUrl(query);
    }

    // Default fallback
    return getActiveProvider().buildSearchUrl(parseResult.rawInput);
  }

  /// Fetches autocomplete suggestions from the active provider.
  Future<List<String>> getSuggestions(String prefix) async {
    return getActiveProvider().getSuggestions(prefix);
  }
}
