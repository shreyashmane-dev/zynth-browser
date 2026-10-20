import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/search_engine.dart';

/// Modal bottom sheet for choosing the active search provider.
class ProviderSelectorSheet extends StatelessWidget {
  final SearchEngineType currentEngine;
  final ValueChanged<SearchEngineType> onSelect;

  const ProviderSelectorSheet({
    super.key,
    required this.currentEngine,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.bottom(16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'Select Search Provider',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Text(
              'Default engine used when entering search terms or phrases.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),

          // Zynth Search Option (Default & Primary)
          _buildEngineOption(
            context: context,
            type: SearchEngineType.zynth,
            title: 'Zynth Search',
            subtitle:
                'Powered by OM Search Engine • Independent open-web index',
            shortcut: '@zynth',
            icon: Icons.bolt_rounded,
            accentColor: AppColors.primary,
            isSelected: currentEngine == SearchEngineType.zynth,
          ),

          const SizedBox(height: 8),

          // Google Search Option (Secondary)
          _buildEngineOption(
            context: context,
            type: SearchEngineType.google,
            title: 'Google',
            subtitle: 'Global web search index',
            shortcut: '@google',
            icon: Icons.public_rounded,
            accentColor: AppColors.secondary,
            isSelected: currentEngine == SearchEngineType.google,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildEngineOption({
    required BuildContext context,
    required SearchEngineType type,
    required String title,
    required String subtitle,
    required String shortcut,
    required IconData icon,
    required Color accentColor,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        onSelect(type);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.12) : AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? accentColor : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          shortcut,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: accentColor, size: 20),
          ],
        ),
      ),
    );
  }
}
