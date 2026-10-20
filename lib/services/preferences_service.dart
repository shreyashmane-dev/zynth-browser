import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../models/search_engine.dart';

/// Service managing lightweight user settings and preferences persistence.
class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  SharedPreferences? _prefs;

  // In-memory fallbacks
  String _memoryEngine = AppConstants.engineZynthId;
  String _memoryBackendUrl = AppConstants.defaultOmSearchBackend;
  String _memoryThemeMode = 'dark';
  bool _memoryAdBlock = true;
  bool _memoryJsEnabled = true;

  /// Initialize SharedPreferences.
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (_) {
      // In testing or uninitialized contexts, use in-memory values
    }
  }

  /// Get the active search engine type. Default is Zynth Search.
  SearchEngineType getSelectedEngine() {
    final engineId =
        _prefs?.getString(AppConstants.prefSelectedEngine) ?? _memoryEngine;
    return SearchEngineTypeExtension.fromId(engineId);
  }

  /// Persist the active search engine selection.
  Future<void> setSelectedEngine(SearchEngineType engine) async {
    _memoryEngine = engine.id;
    await _prefs?.setString(AppConstants.prefSelectedEngine, engine.id);
  }

  /// Get the configured OM Search backend URL.
  String getOmBackendUrl() {
    return _prefs?.getString(AppConstants.prefOmBackendUrl) ??
        _memoryBackendUrl;
  }

  /// Persist the OM Search backend URL.
  Future<void> setOmBackendUrl(String url) async {
    _memoryBackendUrl = url;
    await _prefs?.setString(AppConstants.prefOmBackendUrl, url);
  }

  /// Get the user's theme mode ('dark', 'light', 'system').
  String getThemeMode() {
    return _prefs?.getString(AppConstants.prefThemeMode) ?? _memoryThemeMode;
  }

  /// Persist the theme mode.
  Future<void> setThemeMode(String mode) async {
    _memoryThemeMode = mode;
    await _prefs?.setString(AppConstants.prefThemeMode, mode);
  }

  /// Check if ad/tracker shielding is enabled.
  bool isAdBlockEnabled() {
    return _prefs?.getBool(AppConstants.prefAdBlockEnabled) ?? _memoryAdBlock;
  }

  /// Set ad/tracker shielding status.
  Future<void> setAdBlockEnabled(bool enabled) async {
    _memoryAdBlock = enabled;
    await _prefs?.setBool(AppConstants.prefAdBlockEnabled, enabled);
  }

  /// Check if JavaScript is enabled.
  bool isJavaScriptEnabled() {
    return _prefs?.getBool(AppConstants.prefJsEnabled) ?? _memoryJsEnabled;
  }

  /// Set JavaScript execution status.
  Future<void> setJavaScriptEnabled(bool enabled) async {
    _memoryJsEnabled = enabled;
    await _prefs?.setBool(AppConstants.prefJsEnabled, enabled);
  }
}
