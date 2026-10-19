import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../browser_controller.dart';
import '../../../bookmarks/bookmarks_sheet.dart';
import '../../../settings/settings_sheet.dart';

/// Bottom Navigation Bar with Back, Forward, Home, Bookmark, and Menu controls.
class BrowserBottomBar extends StatelessWidget {
  final BrowserController controller;

  const BrowserBottomBar({
    super.key,
    required this.controller,
  });

  void _openBookmarks(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookmarksSheet(
        onSelectBookmark: (url) {
          controller.navigateTo(url);
        },
      ),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SettingsSheet(
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canBack = controller.canGoBack || !controller.isHomeView;
    final canForward = controller.canGoForward;
    final isBookmarked = controller.isCurrentUrlBookmarked;
    final isHome = controller.isHomeView;

    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: AppColors.navigationBarBg,
        border: Border(
          top: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Back Button
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              color: canBack ? AppColors.textPrimary : AppColors.textMuted.withOpacity(0.5),
              onPressed: canBack ? () => controller.goBack() : null,
              tooltip: 'Back',
            ),

            // Forward Button
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              color: canForward ? AppColors.textPrimary : AppColors.textMuted.withOpacity(0.5),
              onPressed: canForward ? () => controller.goForward() : null,
              tooltip: 'Forward',
            ),

            // Home Button
            IconButton(
              icon: Icon(
                isHome ? Icons.home_rounded : Icons.home_outlined,
                size: 22,
              ),
              color: isHome ? AppColors.primary : AppColors.textPrimary,
              onPressed: () => controller.goHome(),
              tooltip: 'Home',
            ),

            // Bookmark Toggle Button
            IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                size: 20,
              ),
              color: isBookmarked ? AppColors.warning : (isHome ? AppColors.textMuted.withOpacity(0.4) : AppColors.textPrimary),
              onPressed: isHome ? () => _openBookmarks(context) : () => controller.toggleBookmark(),
              tooltip: isBookmarked ? 'Bookmarked' : 'Add Bookmark',
            ),

            // Menu Button (Settings & Features)
            IconButton(
              icon: const Icon(Icons.more_horiz_rounded, size: 22),
              color: AppColors.textPrimary,
              onPressed: () => _showBrowserMenu(context),
              tooltip: 'Menu',
            ),
          ],
        ),
      ),
    );
  }

  void _showBrowserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: const BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.bottom(20),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bookmarks_rounded, color: AppColors.primary),
              title: const TextStyleText('Bookmarks', isTitle: true),
              subtitle: const TextStyleText('View and manage saved websites'),
              onTap: () {
                Navigator.pop(ctx);
                _openBookmarks(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield_outlined, color: AppColors.secondary),
              title: const TextStyleText('Shield Protection', isTitle: true),
              subtitle: TextStyleText(
                'Blocked ${controller.blockedTrackersCount} tracker requests',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
              title: const TextStyleText('Settings', isTitle: true),
              subtitle: const TextStyleText('Search provider, clear data, and preferences'),
              onTap: () {
                Navigator.pop(ctx);
                _openSettings(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TextStyleText extends StatelessWidget {
  final String text;
  final bool isTitle;

  const TextStyleText(this.text, {super.key, this.isTitle = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: isTitle ? AppColors.textPrimary : AppColors.textSecondary,
        fontSize: isTitle ? 15 : 12,
        fontWeight: isTitle ? FontWeight.w500 : FontWeight.w400,
      ),
    );
  }
}
