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
    test('ZynthVision maps all 7 days with valid dayOfWeek 1..7', () {
      expect(ZynthVision.allVisions.length, 7);
      for (int i = 0; i < 7; i++) {
        expect(ZynthVision.allVisions[i].dayOfWeek, i + 1);
      }
    });

    test('Days correspond to correct Vision names', () {
      expect(ZynthVision.forDay(1).name, 'Cosmic Core');
      expect(ZynthVision.forDay(2).name, 'Minimal Flow');
      expect(ZynthVision.forDay(3).name, 'Dark Forge');
      expect(ZynthVision.forDay(4).name, 'Nebula Wave');
      expect(ZynthVision.forDay(5).name, 'Orbit Ring');
      expect(ZynthVision.forDay(6).name, 'Horizon Peak');
      expect(ZynthVision.forDay(7).name, 'Crystal Form');
    });

    test('AppIconService gracefully handles day clamping', () {
      expect(ZynthVision.forDay(0).dayOfWeek, 7); // modulo wrap
      expect(ZynthVision.forDay(8).dayOfWeek, 1);
    });
  });
}
