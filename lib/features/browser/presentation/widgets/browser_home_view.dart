import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/search_engine.dart';
import '../../browser_controller.dart';
import 'provider_selector_sheet.dart';

/// The Zynth Browser branded home view with quick shortcuts, search bar,
/// and engine status indicator.
class BrowserHomeView extends StatefulWidget {
  final BrowserController controller;

  const BrowserHomeView({super.key, required this.controller});

  @override
  State<BrowserHomeView> createState() => _BrowserHomeViewState();
}

class _BrowserHomeViewState extends State<BrowserHomeView> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _quickShortcuts = [
    {
      'title': 'Zynth Search',
      'subtitle': 'OM Engine',
      'url': 'https://omsearch.onrender.com',
      'icon': Icons.bolt_rounded,
      'color': AppColors.primary,
    },
    {
      'title': 'Flutter Docs',
      'subtitle': 'flutter.dev',
      'url': 'https://docs.flutter.dev',
      'icon': Icons.flutter_dash_rounded,
      'color': AppColors.secondary,
    },
    {
      'title': 'GitHub',
      'subtitle': 'github.com',
      'url': 'https://github.com',
      'icon': Icons.code_rounded,
      'color': Colors.purpleAccent,
    },
    {
      'title': 'Wikipedia',
      'subtitle': 'wikipedia.org',
      'url': 'https://wikipedia.org',
      'icon': Icons.menu_book_rounded,
      'color': Colors.tealAccent,
    },
    {
      'title': 'Hacker News',
      'subtitle': 'ycombinator',
      'url': 'https://news.ycombinator.com',
      'icon': Icons.newspaper_rounded,
      'color': Colors.orangeAccent,
    },
    {
      'title': 'Google',
      'subtitle': 'google.com',
      'url': 'https://www.google.com',
      'icon': Icons.public_rounded,
      'color': Colors.blueAccent,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchSubmit(String query) {
    if (query.trim().isNotEmpty) {
      widget.controller.handleUserInput(query.trim());
    }
  }

  void _openProviderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProviderSelectorSheet(
        currentEngine: widget.controller.activeEngine,
        onSelect: (engine) {
          widget.controller.setActiveEngine(engine);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final engine = widget.controller.activeEngine;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),

          // Zynth Branding Logo & Icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF5B34EA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),

          // Brand Title
          const Text(
            'ZYNTH',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 3.0,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Performance • Autonomy • Clarity',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 28),

          // Search Engine Active Chip
          GestureDetector(
            onTap: _openProviderSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    engine == SearchEngineType.zynth
                        ? Icons.bolt_rounded
                        : Icons.public_rounded,
                    size: 14,
                    color: engine == SearchEngineType.zynth
                        ? AppColors.primary
                        : AppColors.secondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Engine: ${engine.displayName}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Prominent Central Search Bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.addressBarBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.addressBarBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'Search with ${engine.displayName} or enter URL...',
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textMuted,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primary,
                  ),
                  onPressed: () => _handleSearchSubmit(_searchController.text),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onSubmitted: _handleSearchSubmit,
            ),
          ),

          const SizedBox(height: 36),

          // Quick Shortcuts Grid Header
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'QUICK ACCESS',
              style: TextStyle(
                color: AppColors.textMuted.withOpacity(0.8),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Shortcuts Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _quickShortcuts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final item = _quickShortcuts[index];
              return _buildShortcutCard(
                title: item['title'] as String,
                subtitle: item['subtitle'] as String,
                url: item['url'] as String,
                icon: item['icon'] as IconData,
                color: item['color'] as Color,
              );
            },
          ),

          const SizedBox(height: 28),

          // Shortcuts info note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.warning,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tip: Type "@google" or "@zynth" before queries in the address bar to switch engines instantly.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutCard({
    required String title,
    required String subtitle,
    required String url,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () => widget.controller.navigateTo(url),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
