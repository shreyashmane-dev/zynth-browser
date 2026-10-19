/// Bookmark data model stored in SQLite database.
class Bookmark {
  final int? id;
  final String title;
  final String url;
  final DateTime createdAt;
  final String? faviconUrl;

  const Bookmark({
    this.id,
    required this.title,
    required this.url,
    required this.createdAt,
    this.faviconUrl,
  });

  Bookmark copyWith({
    int? id,
    String? title,
    String? url,
    DateTime? createdAt,
    String? faviconUrl,
  }) {
    return Bookmark(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      faviconUrl: faviconUrl ?? this.faviconUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'url': url,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'faviconUrl': faviconUrl,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] as int?,
      title: map['title'] as String? ?? 'Untitled',
      url: map['url'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : DateTime.now(),
      faviconUrl: map['faviconUrl'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bookmark &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() {
    return 'Bookmark(id: $id, title: $title, url: $url, createdAt: $createdAt)';
  }
}
