/// Global constants for Zynth Browser.
class AppConstants {
  static const String appName = 'Zynth Browser';
  static const String appVersion = '1.0.0-alpha';

  // Search Engine Identifiers
  static const String engineZynthId = 'zynth';
  static const String engineGoogleId = 'google';

  // Search Engine Display Names
  static const String engineZynthName = 'Zynth Search';
  static const String engineGoogleName = 'Google';

  // Engine Shortcuts
  static const String shortcutGoogle = '@google';
  static const String shortcutZynth = '@zynth';

  // Search URLs & Endpoints
  static const String defaultOmSearchBackend = 'https://omsearch.onrender.com';
  static const String defaultOmSearchLocalhost = 'http://127.0.0.1:8000';
  static const String googleSearchBase = 'https://www.google.com/search?q=';

  // API Paths for OM Search
  static const String omSearchApiPath = '/api/v1/search';
  static const String omSuggestionsApiPath = '/api/v1/suggestions';
  static const String omHealthApiPath = '/api/v1/health';

  // Internal schemes & URLs
  static const String homeUrl = 'about:home';
  static const String blankUrl = 'about:blank';

  // Allowed navigation schemes
  static const Set<String> allowedSchemes = {'http', 'https', 'about'};

  // Storage Keys
  static const String prefSelectedEngine = 'zynth_selected_engine';
  static const String prefOmBackendUrl = 'zynth_om_backend_url';
  static const String prefThemeMode = 'zynth_theme_mode';
  static const String prefAdBlockEnabled = 'zynth_ad_block_enabled';
  static const String prefJsEnabled = 'zynth_js_enabled';
  static const String prefSelectedVision = 'zynth_selected_vision';
  static const String prefVisionAutoDaily = 'zynth_vision_auto_daily';

  // App Metadata (Google Play Protection Guidelines)
  static const String packageName = 'com.zynth.browser';
  static const String appCategory = 'Tools & Communication';
  static const String appShortDescription =
      'A fast, customizable, and privacy-focused browser.';
  static const String privacyPolicyUrl = 'https://zynthbrowser.dev/privacy';

  // Database
  static const String dbName = 'zynth_browser.db';
  static const int dbVersion = 1;
  static const String tableBookmarks = 'bookmarks';
}
