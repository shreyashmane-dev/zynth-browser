import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/bookmark.dart';
import '../../services/database_service.dart';

/// Modal bottom sheet for viewing, searching, and managing saved bookmarks.
class BookmarksSheet extends StatefulWidget {
  final ValueChanged<String> onSelectBookmark;

  const BookmarksSheet({super.key, required this.onSelectBookmark});

  @override
  State<BookmarksSheet> createState() => _BookmarksSheetState();
}

class _BookmarksSheetState extends State<BookmarksSheet> {
  final DatabaseService _db = DatabaseService();
  final TextEditingController _searchController = TextEditingController();

  List<Bookmark> _allBookmarks = [];
  List<Bookmark> _filteredBookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _searchController.addListener(_filterBookmarks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    setState(() => _isLoading = true);
    final bookmarks = await _db.getBookmarks();
    if (mounted) {
      setState(() {
        _allBookmarks = bookmarks;
        _filteredBookmarks = bookmarks;
        _isLoading = false;
      });
    }
  }

  void _filterBookmarks() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBookmarks = _allBookmarks;
      } else {
        _filteredBookmarks = _allBookmarks.where((b) {
          return b.title.toLowerCase().contains(query) ||
              b.url.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _deleteBookmark(Bookmark bookmark) async {
    await _db.deleteBookmarkByUrl(bookmark.url);
    await _loadBookmarks();
  }

  void _showAddBookmarkDialog() {
    final titleController = TextEditingController();
    final urlController = TextEditingController(text: 'https://');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Add Bookmark',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
                labelStyle: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final title = titleController.text.trim();
              final url = urlController.text.trim();
              if (url.isNotEmpty) {
                await _db.addBookmark(
                  Bookmark(
                    title: title.isNotEmpty ? title : url,
                    url: url,
                    createdAt: DateTime.now(),
                  ),
                );
                Navigator.pop(ctx);
                _loadBookmarks();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.bottom(12),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.bookmarks_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Bookmarks',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_rounded, color: AppColors.primary),
                  tooltip: 'Add Bookmark',
                  onPressed: _showAddBookmarkDialog,
                ),
              ],
            ),
          ),

          // Search bar for bookmarks
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: 'Search bookmarks...',
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
              ),
            ),
          ),

          const Divider(color: AppColors.divider, height: 1),

          // Bookmarks List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _filteredBookmarks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border_rounded,
                          size: 48,
                          color: AppColors.textMuted.withOpacity(0.4),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No bookmarks saved yet',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredBookmarks.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: AppColors.divider, height: 1),
                    itemBuilder: (context, index) {
                      final bookmark = _filteredBookmarks[index];
                      return ListTile(
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.public_rounded,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                        ),
                        title: Text(
                          bookmark.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          bookmark.url,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                          ),
                          color: AppColors.textMuted,
                          onPressed: () => _deleteBookmark(bookmark),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          widget.onSelectBookmark(bookmark.url);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
