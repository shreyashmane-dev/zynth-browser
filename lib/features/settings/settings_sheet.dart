import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/search_engine.dart';
import '../../services/preferences_service.dart';
import '../browser/browser_controller.dart';
import '../search/search_provider_factory.dart';

/// Comprehensive settings interface for Zynth Browser.
class SettingsSheet extends StatefulWidget {
  final BrowserController controller;

  const SettingsSheet({super.key, required this.controller});

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  final PreferencesService _prefs = PreferencesService();
  late TextEditingController _backendUrlController;

  late SearchEngineType _selectedEngine;
  late bool _adBlockEnabled;
  late bool _jsEnabled;

  bool _isTestingBackend = false;
  String? _backendTestStatus;
  bool? _backendIsHealthy;

  @override
  void initState() {
    super.initState();
    _selectedEngine = widget.controller.activeEngine;
    _backendUrlController = TextEditingController(
      text: _prefs.getOmBackendUrl(),
    );
    _adBlockEnabled = _prefs.isAdBlockEnabled();
    _jsEnabled = _prefs.isJavaScriptEnabled();
  }

  @override
  void dispose() {
    _backendUrlController.dispose();
    super.dispose();
  }

  Future<void> _testOmBackend() async {
    setState(() {
      _isTestingBackend = true;
      _backendTestStatus = 'Testing connection to OM Search...';
      _backendIsHealthy = null;
    });

    final currentUrl = _backendUrlController.text.trim();
    await _prefs.setOmBackendUrl(currentUrl);

    final isHealthy = await SearchProviderFactory.zynthProvider.checkHealth();

    if (mounted) {
      setState(() {
        _isTestingBackend = false;
        _backendIsHealthy = isHealthy;
        _backendTestStatus = isHealthy
            ? 'Connected successfully (OM Search /api/v1/health: 200 OK)'
            : 'Could not connect. Ensure OM Search backend is running on this port.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  'Zynth Settings',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(color: AppColors.divider, height: 1),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                // SECTION: SEARCH ENGINE
                _buildSectionHeader('SEARCH ENGINE CONFIGURATION'),
                const SizedBox(height: 10),

                // Engine Dropdown / Radio Tile
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<SearchEngineType>(
                        value: SearchEngineType.zynth,
                        groupValue: _selectedEngine,
                        activeColor: AppColors.primary,
                        title: const Text(
                          'Zynth Search (Primary)',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          'Powered by local OM Search Engine',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedEngine = val);
                            widget.controller.setActiveEngine(val);
                          }
                        },
                      ),
                      const Divider(color: AppColors.divider, height: 1),
                      RadioListTile<SearchEngineType>(
                        value: SearchEngineType.google,
                        groupValue: _selectedEngine,
                        activeColor: AppColors.secondary,
                        title: const Text(
                          'Google (Secondary)',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          'Standard web search fallback',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedEngine = val);
                            widget.controller.setActiveEngine(val);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // SECTION: OM SEARCH BACKEND
                _buildSectionHeader('ZYNTH / OM SEARCH BACKEND'),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FastAPI Endpoint URL',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _backendUrlController,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: 'https://omsearch.onrender.com',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              onChanged: (val) {
                                _prefs.setOmBackendUrl(val.trim());
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _isTestingBackend
                                ? null
                                : _testOmBackend,
                            child: _isTestingBackend
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Test',
                                    style: TextStyle(fontSize: 12),
                                  ),
                          ),
                        ],
                      ),
                      if (_backendTestStatus != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (_backendIsHealthy ?? false)
                                ? AppColors.successMuted
                                : AppColors.errorMuted,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: (_backendIsHealthy ?? false)
                                  ? AppColors.success
                                  : AppColors.error,
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                (_backendIsHealthy ?? false)
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.error_outline_rounded,
                                size: 16,
                                color: (_backendIsHealthy ?? false)
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _backendTestStatus!,
                                  style: TextStyle(
                                    color: (_backendIsHealthy ?? false)
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // SECTION: PRIVACY & SHIELDS
                _buildSectionHeader('PRIVACY & SHIELDS'),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _adBlockEnabled,
                        activeColor: AppColors.primary,
                        title: const Text(
                          'Tracker & Ad Guarding',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          'Drops known telemetry and tracker domains at network loop',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => _adBlockEnabled = val);
                          _prefs.setAdBlockEnabled(val);
                        },
                      ),
                      const Divider(color: AppColors.divider, height: 1),
                      SwitchListTile(
                        value: _jsEnabled,
                        activeColor: AppColors.primary,
                        title: const Text(
                          'Enable JavaScript',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          'Required for modern interactive web applications',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => _jsEnabled = val);
                          _prefs.setJavaScriptEnabled(val);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // SECTION: ABOUT
                _buildSectionHeader('ABOUT ZYNTH BROWSER'),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppConstants.appName} v${AppConstants.appVersion}',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Target Platform: Android System WebView (Chromium core)\n'
                        'Architecture: Flutter + Dart with extensible search providers and local SQLite storage.\n'
                        'Future Desktop Target: Linux Chromium Embedded Framework (CEF).',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textMuted.withOpacity(0.8),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}
