import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

/// Screen presenting the full Zynth Browser Privacy Policy.
/// Complies with Google Play Protection Installation Guidelines:
/// - Clear app name, package name, and data usage descriptions
/// - Zero telemetry, no third-party tracking, no background services
/// - Local SQLite storage for user-created bookmarks only
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.secureGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: AppColors.secureGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Google Play Protected & Verified',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Package: com.zynth.browser • Zero Data Collection',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSection(
              title: '1. Overview',
              content:
                  'Zynth Browser is a privacy-first, lightweight web browser built with Flutter and standard Android System WebView. We respect your autonomy and privacy. Zynth Browser operates entirely client-side without third-party tracking, profiling, or background data collection.',
            ),

            _buildSection(
              title: '2. Permissions Requested',
              content:
                  'In strict compliance with Google Play Protection guidelines, Zynth Browser only requests the absolute minimum permissions required to browse the web:\n\n'
                  '• android.permission.INTERNET: Required to load web pages and retrieve OM Search results.\n'
                  '• android.permission.ACCESS_NETWORK_STATE: Required to detect offline/online status.\n\n'
                  'Zynth Browser DOES NOT request or access sensitive permissions such as SMS, Contacts, Location, Microphone, Camera, or Call Logs.',
            ),

            _buildSection(
              title: '3. Data Storage & Local Persistence',
              content:
                  '• Bookmarks: Stored locally on your device in an encrypted SQLite database. Bookmarks are never sent to external servers.\n'
                  '• Preferences: Settings such as your preferred search engine, theme mode, and 7 Visions daily icon configuration are saved locally via Android SharedPreferences.\n'
                  '• WebView Cache & Cookies: Managed directly by Android System WebView. You may clear your cache and cookies at any time from Settings.',
            ),

            _buildSection(
              title: '4. Search Engines & Network Requests',
              content:
                  '• Zynth Search: Powered by the OM Search backend (https://omsearch.onrender.com). Search queries sent to OM Search are transmitted strictly over secure HTTPS.\n'
                  '• Google Search: Standard HTTPS search queries to https://www.google.com.\n'
                  '• HTTPS Enforcement: Zynth Browser prioritizes secure HTTPS connections for all browser requests.',
            ),

            _buildSection(
              title: '5. Original Artwork & Iconography',
              content:
                  'All 7 day icons ("One Browser, Seven Visions": Cosmic Core, Minimal Flow, Dark Forge, Nebula Wave, Orbit Ring, Horizon Peak, Crystal Form) are 100% original, proprietary vector designs. They do not mimic or infringe upon any existing browsers or copyrighted trademarks.',
            ),

            _buildSection(
              title: '6. Contact & Openness',
              content:
                  'For inquiries regarding Zynth Browser, security, or source code compliance, please reach out via the official repository at https://github.com/shreyashmane-dev/zynth-browser.',
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                'Effective Date: 2026 • Version ${AppConstants.appVersion}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
