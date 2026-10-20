import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../core/constants/app_constants.dart';
import '../models/bookmark.dart';

/// Service managing SQLite persistence for Bookmarks.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;
  bool _useMemoryFallback = false;
  final List<Bookmark> _memoryBookmarks = [];
  int _memoryIdCounter = 1;

  /// Initialize database connection with fallback support.
  Future<void> init() async {
    if (_db != null) return;

    try {
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, AppConstants.dbName);

      _db = await openDatabase(
        path,
        version: AppConstants.dbVersion,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE ${AppConstants.tableBookmarks} (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              url TEXT NOT NULL UNIQUE,
              createdAt INTEGER NOT NULL,
              faviconUrl TEXT
            )
          ''');
          // Insert initial default bookmark for OM Search
          await db.insert(AppConstants.tableBookmarks, {
            'title': 'Zynth Search (OM Search)',
            'url': 'https://omsearch.onrender.com',
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'faviconUrl': null,
          });
        },
      );
    } catch (e) {
      // In testing environments or unsupported platforms, fall back gracefully to memory
      _useMemoryFallback = true;
      if (_memoryBookmarks.isEmpty) {
        _memoryBookmarks.add(
          Bookmark(
            id: _memoryIdCounter++,
            title: 'Zynth Search (OM Search)',
            url: 'https://omsearch.onrender.com',
            createdAt: DateTime.now(),
          ),
        );
      }
    }
  }

  /// Get all saved bookmarks ordered by creation time (most recent first).
  Future<List<Bookmark>> getBookmarks() async {
    if (_useMemoryFallback || _db == null) {
      return List.unmodifiable(_memoryBookmarks.reversed);
    }

    try {
      final List<Map<String, dynamic>> maps = await _db!.query(
        AppConstants.tableBookmarks,
        orderBy: 'createdAt DESC',
      );
      return maps.map((m) => Bookmark.fromMap(m)).toList();
    } catch (_) {
      return List.unmodifiable(_memoryBookmarks.reversed);
    }
  }

  /// Add a new bookmark. Returns the generated ID.
  Future<int> addBookmark(Bookmark bookmark) async {
    if (_useMemoryFallback || _db == null) {
      final newBookmark = bookmark.copyWith(id: _memoryIdCounter++);
      _memoryBookmarks.removeWhere((b) => b.url == bookmark.url);
      _memoryBookmarks.add(newBookmark);
      return newBookmark.id!;
    }

    try {
      return await _db!.insert(
        AppConstants.tableBookmarks,
        bookmark.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      final newBookmark = bookmark.copyWith(id: _memoryIdCounter++);
      _memoryBookmarks.removeWhere((b) => b.url == bookmark.url);
      _memoryBookmarks.add(newBookmark);
      return newBookmark.id!;
    }
  }

  /// Remove a bookmark by URL.
  Future<int> deleteBookmarkByUrl(String url) async {
    if (_useMemoryFallback || _db == null) {
      final count = _memoryBookmarks.where((b) => b.url == url).length;
      _memoryBookmarks.removeWhere((b) => b.url == url);
      return count;
    }

    try {
      return await _db!.delete(
        AppConstants.tableBookmarks,
        where: 'url = ?',
        whereArgs: [url],
      );
    } catch (_) {
      _memoryBookmarks.removeWhere((b) => b.url == url);
      return 1;
    }
  }

  /// Check if a URL is bookmarked.
  Future<bool> isBookmarked(String url) async {
    if (_useMemoryFallback || _db == null) {
      return _memoryBookmarks.any((b) => b.url == url);
    }

    try {
      final results = await _db!.query(
        AppConstants.tableBookmarks,
        where: 'url = ?',
        whereArgs: [url],
        limit: 1,
      );
      return results.isNotEmpty;
    } catch (_) {
      return _memoryBookmarks.any((b) => b.url == url);
    }
  }

  /// Close the database instance.
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
