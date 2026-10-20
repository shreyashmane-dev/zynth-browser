import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/zynth_vision.dart';
import '../../../../services/preferences_service.dart';
import 'zynth_logo_widget.dart';

/// Modal bottom sheet allowing users to view and switch between the
/// 7 Day Icon Set ("One Browser, Seven Visions") and configure auto-daily switching.
class VisionSelectorSheet extends StatefulWidget {
  final ZynthVision currentVision;
  final ValueChanged<ZynthVision> onVisionSelected;

  const VisionSelectorSheet({
    super.key,
    required this.currentVision,
    required this.onVisionSelected,
  });

  @override
  State<VisionSelectorSheet> createState() => _VisionSelectorSheetState();
}

class _VisionSelectorSheetState extends State<VisionSelectorSheet> {
  final PreferencesService _prefs = PreferencesService();
  late bool _autoDaily;
  late String _selectedVisionId;

  @override
  void initState() {
    super.initState();
    _autoDaily = _prefs.isVisionAutoDaily();
    _selectedVisionId = _prefs.getSelectedVisionId();
  }

  void _handleSelectVision(ZynthVision vision) {
    setState(() {
      _selectedVisionId = vision.id;
      _autoDaily = false;
    });
    _prefs.setVisionAutoDaily(false);
    _prefs.setSelectedVisionId(vision.id);
    widget.onVisionSelected(vision);
  }

  void _handleToggleAutoDaily(bool enabled) {
    setState(() {
      _autoDaily = enabled;
      if (enabled) {
        _selectedVisionId = 'auto';
      }
    });
    _prefs.setVisionAutoDaily(enabled);
    _prefs.setSelectedVisionId(enabled ? 'auto' : widget.currentVision.id);
    if (enabled) {
      widget.onVisionSelected(ZynthVision.forToday());
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = ZynthVision.forToday();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ZYNTH 7 DAY ICON SET',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'ONE BROWSER • SEVEN VISIONS',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Auto-Daily Switch Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _autoDaily ? AppColors.primary : AppColors.borderSubtle,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryMuted,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Auto Day-of-Week Switch',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _autoDaily
                              ? 'Active: Today is ${today.dayName} (${today.name})'
                              : 'Manual mode: Vision is pinned',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _autoDaily,
                    activeColor: AppColors.primary,
                    onChanged: _handleToggleAutoDaily,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Horizontal/Scrollable List of 7 Visions
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              itemCount: ZynthVision.allVisions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final vision = ZynthVision.allVisions[index];
                final isSelected = !_autoDaily
                    ? _selectedVisionId == vision.id
                    : today.id == vision.id;
                final isToday = today.id == vision.id;

                return _buildVisionCard(
                  vision: vision,
                  isSelected: isSelected,
                  isToday: isToday,
                  onTap: () => _handleSelectVision(vision),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Google Play Protection & Originality Note
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.secureGreen,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  '100% Original Artwork • Google Play Protection Compliant',
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisionCard({
    required ZynthVision vision,
    required bool isSelected,
    required bool isToday,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? vision.surfaceColor
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? vision.primaryColor
                : AppColors.borderSubtle,
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: vision.primaryColor.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Vision Custom Painted Logo
            ZynthLogoWidget(
              vision: vision,
              size: 56,
              showBadge: true,
            ),
            const SizedBox(width: 14),

            // Vision Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'DAY ${vision.dayNumber} • ${vision.name.toUpperCase()}',
                        style: TextStyle(
                          color: isSelected
                              ? vision.primaryColor
                              : AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      if (isToday) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryMuted,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.4),
                            ),
                          ),
                          child: const Text(
                            'TODAY',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${vision.dayName} • ${vision.tagline}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vision.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Selection Radio / Check
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? vision.primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? vision.primaryColor
                      : AppColors.textMuted,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.black,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
