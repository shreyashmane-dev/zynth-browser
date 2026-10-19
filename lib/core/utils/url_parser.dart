import '../constants/app_constants.dart';

/// The resolved type of user input from the address/search bar.
enum UrlType {
  /// A valid web URL (https://, http://, or resolved domain)
  directUrl,

  /// A search query string to be submitted to a search engine
  searchQuery,

  /// An internal browser URL (e.g., about:blank, about:home)
  internal,

  /// An unsupported or blocked scheme (e.g., javascript:, file:, data:)
  blocked,

  /// Empty or whitespace-only input
  empty,
}

/// The result of parsing raw user input from the address bar.
class UrlParseResult {
  final UrlType type;
  final String rawInput;
  final String? targetUrl;
  final String? searchQuery;
  final String? explicitProvider; // 'google' or 'zynth' if shortcut used
  final String? errorMessage;

  const UrlParseResult({
    required this.type,
    required this.rawInput,
    this.targetUrl,
    this.searchQuery,
    this.explicitProvider,
    this.errorMessage,
  });

  bool get isDirectUrl => type == UrlType.directUrl;
  bool get isSearchQuery => type == UrlType.searchQuery;
  bool get isInternal => type == UrlType.internal;
  bool get isBlocked => type == UrlType.blocked;
  bool get isEmpty => type == UrlType.empty;

  /// Returns true if this target URL uses HTTPS.
  bool get isSecure => targetUrl?.startsWith('https://') ?? false;

  @override
  String toString() {
    return 'UrlParseResult(type: $type, targetUrl: $targetUrl, searchQuery: $searchQuery, explicitProvider: $explicitProvider)';
  }
}

/// Robust, testable URL & search query parser for Zynth Browser.
class UrlParser {
  // Disallowed and unsafe schemes
  static const Set<String> _blockedSchemes = {
    'javascript',
    'file',
    'data',
    'content',
    'intent',
    'chrome',
    'blob',
  };

  // Common Top Level Domains for domain heuristic recognition
  static const Set<String> _knownTlds = {
    'com', 'org', 'net', 'edu', 'gov', 'mil', 'int',
    'io', 'ai', 'dev', 'app', 'co', 'uk', 'ca', 'de', 'fr', 'jp',
    'cn', 'ru', 'in', 'br', 'it', 'es', 'nl', 'se', 'no', 'ch',
    'au', 'nz', 'me', 'cc', 'tv', 'tech', 'info', 'biz', 'online',
    'site', 'store', 'blog', 'news', 'xyz', 'live', 'club', 'space',
    'top', 'pro', 'agency', 'digital', 'cloud', 'global', 'design',
    'media', 'link', 'click', 'press', 'zone', 'vip', 'group', 'today',
    'world', 'wiki', 'center', 'life', 'art', 'pub', 'law', 'crypto',
    'us', 'eu', 'asia', 'mobi', 'name', 'travel', 'jobs', 'tel',
  };

  // IPv4 regex with optional port and path
  static final RegExp _ipv4Regex = RegExp(
    r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(?::[0-9]{1,5})?(?:/.*)?$',
  );

  /// Parse the raw user input into a [UrlParseResult].
  static UrlParseResult parse(String rawInput) {
    final trimmed = rawInput.trim();

    if (trimmed.isEmpty) {
      return const UrlParseResult(
        type: UrlType.empty,
        rawInput: '',
      );
    }

    // 1. Check for search provider shortcuts (@google, @zynth)
    String inputWithoutShortcut = trimmed;
    String? explicitProvider;

    final lower = trimmed.toLowerCase();
    if (lower.startsWith('${AppConstants.shortcutGoogle} ') || lower == AppConstants.shortcutGoogle) {
      explicitProvider = AppConstants.engineGoogleId;
      inputWithoutShortcut = trimmed.length > AppConstants.shortcutGoogle.length
          ? trimmed.substring(AppConstants.shortcutGoogle.length).trim()
          : '';
    } else if (lower.startsWith('${AppConstants.shortcutZynth} ') || lower == AppConstants.shortcutZynth) {
      explicitProvider = AppConstants.engineZynthId;
      inputWithoutShortcut = trimmed.length > AppConstants.shortcutZynth.length
          ? trimmed.substring(AppConstants.shortcutZynth.length).trim()
          : '';
    }

    // If only shortcut was entered, treat as search query for empty or home
    if (explicitProvider != null && inputWithoutShortcut.isEmpty) {
      return UrlParseResult(
        type: UrlType.searchQuery,
        rawInput: trimmed,
        searchQuery: '',
        explicitProvider: explicitProvider,
      );
    }

    final toEvaluate = explicitProvider != null ? inputWithoutShortcut : trimmed;

    // 2. Check localhost (e.g. localhost, localhost:8000, localhost:3000/api)
    if (_isLocalhost(toEvaluate)) {
      return UrlParseResult(
        type: UrlType.directUrl,
        rawInput: trimmed,
        targetUrl: 'http://$toEvaluate',
        explicitProvider: explicitProvider,
      );
    }

    // 3. Check explicit scheme (e.g. https://, http://, about:, javascript:)
    final schemeMatch = RegExp(r'^([a-zA-Z][a-zA-Z0-9+.-]*):').firstMatch(toEvaluate);
    if (schemeMatch != null) {
      final scheme = schemeMatch.group(1)!.toLowerCase();
      final afterColon = toEvaluate.substring(schemeMatch.end);

      // If colon is immediately followed by digits, it's a port number on a hostname, not a scheme
      final isPort = RegExp(r'^[0-9]+(?:/.*)?$').hasMatch(afterColon);

      if (!isPort) {
        // Check blocked / dangerous schemes
        if (_blockedSchemes.contains(scheme)) {
          return UrlParseResult(
            type: UrlType.blocked,
            rawInput: trimmed,
            explicitProvider: explicitProvider,
            errorMessage: 'Navigation to "$scheme:" scheme is blocked for security.',
          );
        }

        // Check internal schemes
        if (scheme == 'about') {
          return UrlParseResult(
            type: UrlType.internal,
            rawInput: trimmed,
            targetUrl: toEvaluate.toLowerCase(),
            explicitProvider: explicitProvider,
          );
        }

        // Check supported web schemes
        if (scheme == 'http' || scheme == 'https') {
          final parsedUri = Uri.tryParse(toEvaluate);
          if (parsedUri != null && parsedUri.host.isNotEmpty) {
            return UrlParseResult(
              type: UrlType.directUrl,
              rawInput: trimmed,
              targetUrl: toEvaluate,
              explicitProvider: explicitProvider,
            );
          }
        }

        // Other arbitrary schemes (e.g. intent:, custom:) are treated as search query
        // or blocked if invalid
        if (!AppConstants.allowedSchemes.contains(scheme)) {
          return UrlParseResult(
            type: UrlType.searchQuery,
            rawInput: trimmed,
            searchQuery: toEvaluate,
            explicitProvider: explicitProvider,
          );
        }
      }
    }

    // 3. If explicit provider was given (@google or @zynth), route directly to search query
    if (explicitProvider != null) {
      return UrlParseResult(
        type: UrlType.searchQuery,
        rawInput: trimmed,
        searchQuery: inputWithoutShortcut,
        explicitProvider: explicitProvider,
      );
    }

    // 4. Domain vs Search Query Heuristic
    // A string with spaces is always a search query
    if (toEvaluate.contains(' ') || toEvaluate.contains('\t') || toEvaluate.contains('\n')) {
      return UrlParseResult(
        type: UrlType.searchQuery,
        rawInput: trimmed,
        searchQuery: toEvaluate,
      );
    }

    // Check localhost (e.g. localhost, localhost:8000, localhost:3000/api)
    if (_isLocalhost(toEvaluate)) {
      return UrlParseResult(
        type: UrlType.directUrl,
        rawInput: trimmed,
        targetUrl: 'http://$toEvaluate',
      );
    }

    // Check IPv4 address
    if (_ipv4Regex.hasMatch(toEvaluate)) {
      final hasPort = toEvaluate.contains(':');
      final prefix = hasPort ? 'http://' : 'https://';
      return UrlParseResult(
        type: UrlType.directUrl,
        rawInput: trimmed,
        targetUrl: '$prefix$toEvaluate',
      );
    }

    // Check if it's a domain name
    if (_looksLikeDomain(toEvaluate)) {
      return UrlParseResult(
        type: UrlType.directUrl,
        rawInput: trimmed,
        targetUrl: 'https://$toEvaluate',
      );
    }

    // Default: It is a search query
    return UrlParseResult(
      type: UrlType.searchQuery,
      rawInput: trimmed,
      searchQuery: toEvaluate,
    );
  }

  /// Determines if the input string is a localhost address.
  static bool _isLocalhost(String input) {
    final lower = input.toLowerCase();
    if (lower == 'localhost') return true;
    if (lower.startsWith('localhost:') || lower.startsWith('localhost/')) {
      return true;
    }
    return false;
  }

  /// Determines if an input looks like a valid internet domain.
  /// Does not classify every string with a period as a website!
  static bool _looksLikeDomain(String input) {
    // Cannot start or end with a dot, dash, or slash
    if (input.startsWith('.') || input.endsWith('.') ||
        input.startsWith('-') || input.endsWith('-') ||
        input.startsWith('/')) {
      return false;
    }

    // Cannot contain double dots
    if (input.contains('..')) {
      return false;
    }

    // If it starts with www., it's definitely a domain
    if (input.toLowerCase().startsWith('www.')) {
      return true;
    }

    // Extract the host part before any path (/), query (?), or fragment (#)
    String host = input;
    final pathIndex = host.indexOf('/');
    if (pathIndex != -1) {
      host = host.substring(0, pathIndex);
    }
    final queryIndex = host.indexOf('?');
    if (queryIndex != -1) {
      host = host.substring(0, queryIndex);
    }
    final fragmentIndex = host.indexOf('#');
    if (fragmentIndex != -1) {
      host = host.substring(0, fragmentIndex);
    }

    // Strip port if present
    final portIndex = host.indexOf(':');
    if (portIndex != -1) {
      host = host.substring(0, portIndex);
    }

    // Host must contain at least one dot
    final dotIndex = host.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == host.length - 1) {
      return false;
    }

    // Extract the TLD
    final tld = host.substring(dotIndex + 1).toLowerCase();

    // TLD must be all letters or punycode (xn--)
    if (!RegExp(r'^[a-z]{2,}$').hasMatch(tld) && !tld.startsWith('xn--')) {
      return false;
    }

    // Check against known TLDs or if path is provided with a valid TLD length
    if (_knownTlds.contains(tld)) {
      return true;
    }

    // If it has a path or query and the TLD is 2-6 alphabetic chars, classify as domain
    if (input.contains('/') && RegExp(r'^[a-z]{2,6}$').hasMatch(tld)) {
      return true;
    }

    return false;
  }
}
