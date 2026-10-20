import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/zynth_vision.dart';
import 'preferences_service.dart';

/// Service responsible for managing dynamic launcher app icons for Android
/// supporting the "One Browser • Seven Visions" 7-Day Icon Set.
class AppIconService {
  static const MethodChannel _channel = MethodChannel('com.zynth.browser/app_icon');

  /// Switch the active Android home screen launcher icon to match the specified day [1..7].
  /// Day 1 = Monday (Cosmic Core) ... Day 7 = Sunday (Crystal Form).
  static Future<bool> setAppIcon(int dayIndex) async {
    if (kIsWeb || !Platform.isAndroid) {
      debugPrint('[AppIconService] Dynamic launcher icon only supported on Android platform.');
      return false;
    }

    final clampedDay = dayIndex.clamp(1, 7);
    try {
      final bool? success = await _channel.invokeMethod<bool>('setAppIcon', {
        'dayIndex': clampedDay,
      });
      debugPrint('[AppIconService] Switched app launcher icon to Day $clampedDay ($success)');
      return success ?? false;
    } on PlatformException catch (e) {
      debugPrint('[AppIconService] Failed to set app icon for Day $clampedDay: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('[AppIconService] Unexpected error setting app icon: $e');
      return false;
    }
  }

  /// Retrieve the active day index [1..7] currently configured on the Android launcher.
  static Future<int> getCurrentAppIcon() async {
    if (kIsWeb || !Platform.isAndroid) {
      return DateTime.now().weekday;
    }

    try {
      final int? activeDay = await _channel.invokeMethod<int>('getCurrentAppIcon');
      return activeDay ?? DateTime.now().weekday;
    } catch (e) {
      debugPrint('[AppIconService] Failed to get active app icon: $e');
      return DateTime.now().weekday;
    }
  }

  /// Synchronize the launcher app icon based on user preferences:
  /// - If Auto Daily is enabled: automatically sets icon to today's day-of-week (1..7).
  /// - If user selected a specific vision: locks the launcher icon to that vision's day.
  static Future<void> syncDailyIcon() async {
    try {
      final prefs = PreferencesService();
      final isAuto = prefs.isVisionAutoDaily();
      if (isAuto) {
        final todayWeekday = DateTime.now().weekday;
        await setAppIcon(todayWeekday);
      } else {
        final savedVisionId = prefs.getSelectedVisionId();
        final vision = ZynthVision.fromId(savedVisionId);
        await setAppIcon(vision.dayNumber);
      }
    } catch (e) {
      debugPrint('[AppIconService] Error syncing daily icon: $e');
    }
  }
}
