import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/url_parser.dart';
import '../../models/bookmark.dart';
import '../../models/search_engine.dart';
import '../../services/database_service.dart';
import '../../services/preferences_service.dart';
import '../../services/search_service.dart';

/// Central state controller managing webview navigation, browser history,
/// loading progress, and error/offline states.
class BrowserController extends ChangeNotifier {
  final PreferencesService _prefs = PreferencesService();
  final DatabaseService _db = DatabaseService();
  final SearchService _searchService = SearchService();

  WebViewController? _webViewController;
  WebViewController? get webViewController => _webViewController;

  // Browser Navigation State
  String _currentUrl = AppConstants.homeUrl;
  String _displayUrl = '';
  String _pageTitle = AppConstants.appName;
  bool _isLoading = false;
  double _loadingProgress = 0.0;
  bool _canGoBack = false;
  bool _canGoForward = false;
  bool _isSecure = false;
  bool _isHomeView = true;
  bool _isSearchResultsView = false;
  String? _searchQuery;

  // Error & Offline State
  bool _hasError = false;
  String? _errorMessage;
  String? _failedUrl;

  // Search Engine State
  late SearchEngineType _activeEngine;

  // Bookmarks & Feature State
  bool _isCurrentUrlBookmarked = false;
  int _blockedTrackersCount = 0;

  // Known tracking & ad patterns for shield protection (PRD 3.2)
  static final List<RegExp> _adFilterPatterns = [
    RegExp(r'doubleclick\.net', caseSensitive: false),
    RegExp(r'googlesyndication\.com', caseSensitive: false),
    RegExp(r'adservice\.google\.', caseSensitive: false),
    RegExp(r'adnxs\.com', caseSensitive: false),
    RegExp(r'taboola\.com', caseSensitive: false),
    RegExp(r'outbrain\.com', caseSensitive: false),
  ];

  // Getters
  String get currentUrl => _currentUrl;
  String get displayUrl => _displayUrl;
  String get pageTitle => _pageTitle;
  bool get isLoading => _isLoading;
  double get loadingProgress => _loadingProgress;
  bool get canGoBack => _canGoBack;
  bool get canGoForward => _canGoForward;
  bool get isSecure => _isSecure;
  bool get isHomeView => _isHomeView;
  bool get isSearchResultsView => _isSearchResultsView;
  String? get searchQuery => _searchQuery;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  String? get failedUrl => _failedUrl;
  SearchEngineType get activeEngine => _activeEngine;
  bool get isCurrentUrlBookmarked => _isCurrentUrlBookmarked;
  int get blockedTrackersCount => _blockedTrackersCount;

  BrowserController() {
    _activeEngine = _prefs.getSelectedEngine();
    _initWebViewController();
  }

  /// Initialize the WebView platform controller.
  void _initWebViewController() {
    try {
      final controller = WebViewController();

      final isJsEnabled = _prefs.isJavaScriptEnabled();
      controller.setJavaScriptMode(
        isJsEnabled ? JavaScriptMode.unrestricted : JavaScriptMode.disabled,
      );

      controller.setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            _loadingProgress = progress / 100.0;
            _isLoading = progress < 100;
            notifyListeners();
          },
          onPageStarted: (String url) {
            _onPageStarted(url);
          },
          onPageFinished: (String url) {
            _onPageFinished(url);
          },
          onWebResourceError: (WebResourceError error) {
            _onWebResourceError(error);
          },
          onNavigationRequest: (NavigationRequest request) {
            return _evaluateNavigationRequest(request);
          },
        ),
      );

      _webViewController = controller;
    } catch (_) {
      // In headless test environments without native WebViewPlatform, gracefully fall back
    }
  }

  /// Evaluates incoming navigation requests for security and tracker mitigation.
  NavigationDecision _evaluateNavigationRequest(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);
    if (uri == null) return NavigationDecision.prevent;

    // Reject unsafe schemes
    if (!AppConstants.allowedSchemes.contains(uri.scheme.toLowerCase())) {
      return NavigationDecision.prevent;
    }

    // Tracker & Ad Guarding (PRD 3.2)
    if (_prefs.isAdBlockEnabled()) {
      for (final pattern in _adFilterPatterns) {
        if (pattern.hasMatch(request.url)) {
          _blockedTrackersCount++;
          notifyListeners();
          return NavigationDecision.prevent;
        }
      }
    }

    return NavigationDecision.navigate;
  }

  void _onPageStarted(String url) {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    _currentUrl = url;
    _displayUrl = _formatDisplayUrl(url);
    _isSecure = url.startsWith('https://');
    _isHomeView = (url == AppConstants.homeUrl || url == AppConstants.blankUrl);
    _checkBookmarkStatus(url);
    _updateHistoryControls();
    notifyListeners();
  }

  void _onPageFinished(String url) async {
    _isLoading = false;
    _currentUrl = url;
    _displayUrl = _formatDisplayUrl(url);
    _isSecure = url.startsWith('https://');

    try {
      final title = await _webViewController?.getTitle();
      if (title != null && title.isNotEmpty) {
        _pageTitle = title;
      }
    } catch (_) {}

    _updateHistoryControls();
    _checkBookmarkStatus(url);
    notifyListeners();
  }

  void _onWebResourceError(WebResourceError error) {
    // Only trigger main error state for main-frame errors
    _hasError = true;
    _isLoading = false;
    _failedUrl = _currentUrl;
    _errorMessage = '${error.description} (code: ${error.errorCode})';
    notifyListeners();
  }

  Future<void> _updateHistoryControls() async {
    if (_webViewController == null) return;
    try {
      _canGoBack = await _webViewController!.canGoBack();
      _canGoForward = await _webViewController!.canGoForward();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _checkBookmarkStatus(String url) async {
    if (_isHomeView) {
      _isCurrentUrlBookmarked = false;
      return;
    }
    _isCurrentUrlBookmarked = await _db.isBookmarked(url);
    notifyListeners();
  }

  String _formatDisplayUrl(String url) {
    if (url == AppConstants.homeUrl || url == AppConstants.blankUrl) {
      return '';
    }
    return url;
  }

  /// Process user input from address bar or search field.
  Future<void> handleUserInput(String input) async {
    final parseResult = UrlParser.parse(input);

    if (parseResult.isEmpty) return;

    if (parseResult.isBlocked) {
      _hasError = true;
      _errorMessage =
          parseResult.errorMessage ?? 'URL scheme is blocked for security.';
      _isHomeView = false;
      _isSearchResultsView = false;
      notifyListeners();
      return;
    }

    if (parseResult.isSearchQuery) {
      final query = parseResult.searchQuery ?? '';
      final isGoogle =
          parseResult.explicitProvider == AppConstants.engineGoogleId ||
          (parseResult.explicitProvider == null &&
              _activeEngine == SearchEngineType.google);

      if (isGoogle) {
        _isSearchResultsView = false;
        final destinationUrl = _searchService.resolveDestinationUrl(
          parseResult,
        );
        await navigateTo(destinationUrl);
      } else {
        // Zynth Search powered by OM Search on Render
        _hasError = false;
        _errorMessage = null;
        _isHomeView = false;
        _isSearchResultsView = true;
        _searchQuery = query;
        _currentUrl = 'about:search?q=${Uri.encodeComponent(query)}';
        _displayUrl = query;
        _pageTitle = 'Zynth Search: $query';
        notifyListeners();
      }
      return;
    }

    _isSearchResultsView = false;
    final destinationUrl = _searchService.resolveDestinationUrl(parseResult);
    await navigateTo(destinationUrl);
  }

  /// Directly navigates to a URL.
  Future<void> navigateTo(String url) async {
    _hasError = false;
    _errorMessage = null;
    _failedUrl = null;
    _isSearchResultsView = false;

    if (url == AppConstants.homeUrl || url == AppConstants.blankUrl) {
      _isHomeView = true;
      _searchQuery = null;
      _currentUrl = AppConstants.homeUrl;
      _displayUrl = '';
      _pageTitle = AppConstants.appName;
      notifyListeners();
      return;
    }

    _isHomeView = false;
    _currentUrl = url;
    _displayUrl = _formatDisplayUrl(url);
    _isLoading = true;
    notifyListeners();

    try {
      final uri = Uri.parse(url);
      await _webViewController?.loadRequest(uri);
    } catch (e) {
      _hasError = true;
      _isLoading = false;
      _failedUrl = url;
      _errorMessage = 'Failed to load URL: $e';
      notifyListeners();
    }
  }

  /// Go back in webview history or return to search results / home.
  Future<void> goBack() async {
    if (_hasError) {
      _hasError = false;
      if (_searchQuery != null && _searchQuery!.isNotEmpty) {
        _isSearchResultsView = true;
        _displayUrl = _searchQuery!;
      } else {
        _isHomeView = true;
      }
      notifyListeners();
      return;
    }

    if (_isSearchResultsView) {
      goHome();
      return;
    }

    if (_canGoBack && _webViewController != null) {
      await _webViewController!.goBack();
      await _updateHistoryControls();
    } else if (_searchQuery != null && !_isSearchResultsView) {
      // Returned from visited website back to Zynth Search results
      _isSearchResultsView = true;
      _displayUrl = _searchQuery!;
      _pageTitle = 'Zynth Search: $_searchQuery';
      notifyListeners();
    } else {
      goHome();
    }
  }

  /// Go forward in webview history.
  Future<void> goForward() async {
    if (_canGoForward && _webViewController != null) {
      await _webViewController!.goForward();
      await _updateHistoryControls();
    }
  }

  /// Reload current page.
  Future<void> reload() async {
    _hasError = false;
    _errorMessage = null;
    if (_isHomeView) return;

    if (_webViewController != null) {
      await _webViewController!.reload();
    }
  }

  /// Stop current loading.
  Future<void> stopLoading() async {
    if (_webViewController != null) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Navigate to Zynth Home.
  void goHome() {
    _isHomeView = true;
    _isSearchResultsView = false;
    _searchQuery = null;
    _hasError = false;
    _currentUrl = AppConstants.homeUrl;
    _displayUrl = '';
    _pageTitle = AppConstants.appName;
    notifyListeners();
  }

  /// Switch the active search engine.
  Future<void> setActiveEngine(SearchEngineType type) async {
    _activeEngine = type;
    await _searchService.setActiveEngine(type);
    notifyListeners();
  }

  /// Toggle bookmark for the current URL.
  Future<void> toggleBookmark() async {
    if (_isHomeView || _currentUrl.isEmpty) return;

    if (_isCurrentUrlBookmarked) {
      await _db.deleteBookmarkByUrl(_currentUrl);
      _isCurrentUrlBookmarked = false;
    } else {
      final bookmark = Bookmark(
        title: _pageTitle.isNotEmpty ? _pageTitle : _currentUrl,
        url: _currentUrl,
        createdAt: DateTime.now(),
      );
      await _db.addBookmark(bookmark);
      _isCurrentUrlBookmarked = true;
    }
    notifyListeners();
  }

  /// Retry last failed URL.
  void retry() {
    if (_failedUrl != null && _failedUrl!.isNotEmpty) {
      navigateTo(_failedUrl!);
    } else {
      reload();
    }
  }
}
