import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/browser/presentation/browser_screen.dart';
import 'services/app_icon_service.dart';
import 'services/database_service.dart';
import 'services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set immersive system overlay style for dark-first browsing
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.navigationBarBg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize persistence services
  final prefsService = PreferencesService();
  await prefsService.init();

  final dbService = DatabaseService();
  await dbService.init();

  // Sync dynamic app launcher icon according to 7-Day Vision schedule
  await AppIconService.syncDailyIcon();

  runApp(const ZynthBrowserApp());
}

/// Root Application Widget for Zynth Browser.
class ZynthBrowserApp extends StatelessWidget {
  const ZynthBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const BrowserScreen(),
    );
  }
}
