import '../../models/search_engine.dart';
import 'google_search_provider.dart';
import 'search_provider.dart';
import 'zynth_search_provider.dart';

/// Factory providing singleton instances of search providers.
class SearchProviderFactory {
  static final ZynthSearchProvider _zynthProvider = ZynthSearchProvider();
  static final GoogleSearchProvider _googleProvider = GoogleSearchProvider();

  static SearchProvider getProvider(SearchEngineType type) {
    switch (type) {
      case SearchEngineType.zynth:
        return _zynthProvider;
      case SearchEngineType.google:
        return _googleProvider;
    }
  }

  static ZynthSearchProvider get zynthProvider => _zynthProvider;
  static GoogleSearchProvider get googleProvider => _googleProvider;
}
