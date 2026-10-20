import '../core/constants/app_constants.dart';

/// Available search engine types in Zynth Browser.
enum SearchEngineType { zynth, google }

extension SearchEngineTypeExtension on SearchEngineType {
  String get id {
    switch (this) {
      case SearchEngineType.zynth:
        return AppConstants.engineZynthId;
      case SearchEngineType.google:
        return AppConstants.engineGoogleId;
    }
  }

  String get displayName {
    switch (this) {
      case SearchEngineType.zynth:
        return AppConstants.engineZynthName;
      case SearchEngineType.google:
        return AppConstants.engineGoogleName;
    }
  }

  String get shortcut {
    switch (this) {
      case SearchEngineType.zynth:
        return AppConstants.shortcutZynth;
      case SearchEngineType.google:
        return AppConstants.shortcutGoogle;
    }
  }

  String get description {
    switch (this) {
      case SearchEngineType.zynth:
        return 'Independent open web search powered by OM Search Engine';
      case SearchEngineType.google:
        return 'Global search engine index';
    }
  }

  static SearchEngineType fromId(String id) {
    if (id == AppConstants.engineGoogleId) {
      return SearchEngineType.google;
    }
    return SearchEngineType.zynth;
  }
}
