import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/search_engine.dart';
import '../../browser_controller.dart';

/// Clean offline & navigation error view.
class ErrorView extends StatelessWidget {
  final BrowserController controller;

  const ErrorView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final failedUrl = controller.failedUrl ?? controller.currentUrl;
    final errorMessage = controller.errorMessage ?? 'Unable to connect to the requested address.';
    final isZynthEngine = controller.activeEngine == SearchEngineType.zynth;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Error icon container
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.errorMuted,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: AppColors.error,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Navigation Failed',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),

            // Failed URL badge
            if (failedUrl.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  failedUrl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Retry Button
                ElevatedButton.icon(
                  onPressed: () => controller.retry(),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Home Button
                OutlinedButton.icon(
                  onPressed: () => controller.goHome(),
                  icon: const Icon(Icons.home_outlined, size: 18),
                  label: const Text('Home'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Alternative: Search with Google or Zynth if search failed
            if (isZynthEngine) ...[
              TextButton.icon(
                onPressed: () async {
                  await controller.setActiveEngine(SearchEngineType.google);
                  controller.retry();
                },
                icon: const Icon(Icons.search_rounded, size: 16, color: AppColors.secondary),
                label: const Text(
                  'Search with Google instead',
                  style: TextStyle(color: AppColors.secondary, fontSize: 13),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
