import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

/// Modal sheet detailing the Google Play Protection Installation Guidelines
/// based on the verified specification.
class PlayProtectionSheet extends StatelessWidget {
  const PlayProtectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 12, bottom: 28),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      child: Column(
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

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      color: AppColors.secureGreen,
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GOOGLE PLAY PROTECTION',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'INSTALLATION & COMPLIANCE GUIDELINES',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
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

          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Section 1: Follow These Rules
                  _buildCard(
                    title: 'FOLLOW THESE RULES',
                    icon: Icons.check_circle_outline_rounded,
                    headerColor: AppColors.secureGreen,
                    items: const [
                      'Use a unique and original icon (these designs are 100% original).',
                      'Do not copy icons from existing browsers or popular apps.',
                      'Use your own package name (com.zynth.browser).',
                      'Sign the APK with a proper release key (keystore).',
                      'Enable code shrinking (R8) and remove debug info for release builds.',
                      'Request only necessary permissions (INTERNET, ACCESS_NETWORK_STATE).',
                      'Do not include malware-like behaviors (background data collection, hidden services).',
                      'Provide a clear app name, description, and privacy policy.',
                      'Use HTTPS for all network requests.',
                      'Test the APK with Google Play Console pre-launch report.',
                    ],
                    isPositive: true,
                  ),

                  const SizedBox(height: 16),

                  // Section 2: Avoid These Things
                  _buildCard(
                    title: 'AVOID THESE THINGS',
                    icon: Icons.cancel_outlined,
                    headerColor: AppColors.error,
                    items: const [
                      'Do not use icons similar to Chrome, Brave, Edge, Firefox, or other popular browsers.',
                      'Do not use existing brand logos, copyrighted assets, or AI-generated icons that mimic known apps.',
                      'Do not include unnecessary or sensitive permissions (SMS, Contacts, Call logs, etc.).',
                      'Do not modify WebView or add native code that triggers security heuristics.',
                      'Do not use obfuscated, packed, or suspicious libraries.',
                      'Do not distribute modified Chromium binaries without proper compliance.',
                      'Do not promise or claim false privacy features.',
                    ],
                    isPositive: false,
                  ),

                  const SizedBox(height: 16),

                  // Section 3: Recommended App Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.secondary,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'RECOMMENDED APP INFO',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('App Name', AppConstants.appName),
                        _buildInfoRow('Package Name', AppConstants.packageName),
                        _buildInfoRow('Category', AppConstants.appCategory),
                        _buildInfoRow('Short Description', AppConstants.appShortDescription),
                        _buildInfoRow('Privacy Policy', 'Embedded locally & https://zynthbrowser.dev/privacy'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Section 4: Build Recommendations
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.settings_suggest_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'BUILD RECOMMENDATIONS',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '• Use Flutter stable channel (3.24+)\n'
                          '• Enable release mode: flutter build apk --release\n'
                          '• Use a keystore for signing (upload-keystore.jks)\n'
                          '• Test on multiple Android devices\n'
                          '• Verify with Google Play Console (internal testing track first)\n'
                          '• Keep the app size optimized (< 100 MB)',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color headerColor,
    required List<String> items,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: headerColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: headerColor, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: headerColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isPositive ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    size: 14,
                    color: isPositive ? AppColors.secureGreen : AppColors.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
