/// Verified data model corresponding to the OM Search Engine FastAPI response schema.
/// From: D:\Projects\Om Search Engine\backend\app\schemas\search.py

class OmSearchResultItem {
  final String id;
  final String url;
  final String canonicalUrl;
  final String domain;
  final String title;
  final String snippet;
  final double score;
  final List<String> highlights;

  const OmSearchResultItem({
    required this.id,
    required this.url,
    required this.canonicalUrl,
    required this.domain,
    required this.title,
    required this.snippet,
    required this.score,
    this.highlights = const [],
  });

  factory OmSearchResultItem.fromJson(Map<String, dynamic> json) {
    return OmSearchResultItem(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      canonicalUrl: json['canonical_url'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled',
      snippet: json['snippet'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      highlights: (json['highlights'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'canonical_url': canonicalUrl,
      'domain': domain,
      'title': title,
      'snippet': snippet,
      'score': score,
      'highlights': highlights,
    };
  }
}

class OmSearchResponse {
  final String query;
  final int total;
  final int page;
  final int size;
  final int totalPages;
  final double tookMs;
  final List<OmSearchResultItem> results;
  final String? spellingSuggestion;
  final String? message;

  const OmSearchResponse({
    required this.query,
    required this.total,
    required this.page,
    required this.size,
    required this.totalPages,
    required this.tookMs,
    required this.results,
    this.spellingSuggestion,
    this.message,
  });

  factory OmSearchResponse.fromJson(Map<String, dynamic> json) {
    return OmSearchResponse(
      query: json['query'] as String? ?? '',
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      size: json['size'] as int? ?? 10,
      totalPages: json['total_pages'] as int? ?? 1,
      tookMs: (json['took_ms'] as num?)?.toDouble() ?? 0.0,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => OmSearchResultItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      spellingSuggestion: json['spelling_suggestion'] as String?,
      message: json['message'] as String?,
    );
  }
}
