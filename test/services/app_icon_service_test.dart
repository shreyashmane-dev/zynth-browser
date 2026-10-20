import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zynth_browser/models/zynth_vision.dart';
import 'package:zynth_browser/services/app_icon_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('com.zynth.browser/app_icon');
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);
      if (methodCall.method == 'setAppIcon') {
        return true;
      }
      if (methodCall.method == 'getCurrentAppIcon') {
        return 3; // Wednesday (Dark Forge)
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('AppIconService Tests', () {
    test('ZynthVision maps all 7 days with valid dayNumber 1..7', () {
      expect(ZynthVision.allVisions.length, 7);
      for (int i = 0; i < 7; i++) {
        expect(ZynthVision.allVisions[i].dayNumber, i + 1);
      }
    });

    test('Days correspond to correct Vision names', () {
      expect(ZynthVision.getVisionForWeekday(1).name, 'Cosmic Core');
      expect(ZynthVision.getVisionForWeekday(2).name, 'Minimal Flow');
      expect(ZynthVision.getVisionForWeekday(3).name, 'Dark Forge');
      expect(ZynthVision.getVisionForWeekday(4).name, 'Nebula Wave');
      expect(ZynthVision.getVisionForWeekday(5).name, 'Orbit Ring');
      expect(ZynthVision.getVisionForWeekday(6).name, 'Horizon Peak');
      expect(ZynthVision.getVisionForWeekday(7).name, 'Crystal Form');
    });

    test('AppIconService gracefully handles invalid day bounds in getVisionForWeekday', () {
      expect(ZynthVision.getVisionForWeekday(0).dayNumber, 1); // fallback
      expect(ZynthVision.getVisionForWeekday(8).dayNumber, 1); // fallback
    });
  });
}
