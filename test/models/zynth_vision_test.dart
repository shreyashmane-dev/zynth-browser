import 'package:flutter_test/flutter_test.dart';
import 'package:zynth_browser/models/zynth_vision.dart';

void main() {
  group('ZynthVision Model & 7 Day Icon Set Tests', () {
    test('all 7 visions are properly defined and distinct', () {
      expect(ZynthVision.allVisions.length, equals(7));

      final ids = ZynthVision.allVisions.map((v) => v.id).toSet();
      expect(ids.length, equals(7));

      final days = ZynthVision.allVisions.map((v) => v.dayNumber).toList();
      expect(days, equals([1, 2, 3, 4, 5, 6, 7]));
    });

    test('exact 7 day names and tags match image specification', () {
      // Day 1: Cosmic Core
      expect(ZynthVision.cosmicCore.dayNumber, equals(1));
      expect(ZynthVision.cosmicCore.name, equals('Cosmic Core'));
      expect(ZynthVision.cosmicCore.dayName, equals('Monday'));

      // Day 2: Minimal Flow
      expect(ZynthVision.minimalFlow.dayNumber, equals(2));
      expect(ZynthVision.minimalFlow.name, equals('Minimal Flow'));
      expect(ZynthVision.minimalFlow.dayName, equals('Tuesday'));

      // Day 3: Dark Forge
      expect(ZynthVision.darkForge.dayNumber, equals(3));
      expect(ZynthVision.darkForge.name, equals('Dark Forge'));
      expect(ZynthVision.darkForge.dayName, equals('Wednesday'));

      // Day 4: Nebula Wave
      expect(ZynthVision.nebulaWave.dayNumber, equals(4));
      expect(ZynthVision.nebulaWave.name, equals('Nebula Wave'));
      expect(ZynthVision.nebulaWave.dayName, equals('Thursday'));

      // Day 5: Orbit Ring
      expect(ZynthVision.orbitRing.dayNumber, equals(5));
      expect(ZynthVision.orbitRing.name, equals('Orbit Ring'));
      expect(ZynthVision.orbitRing.dayName, equals('Friday'));

      // Day 6: Horizon Peak
      expect(ZynthVision.horizonPeak.dayNumber, equals(6));
      expect(ZynthVision.horizonPeak.name, equals('Horizon Peak'));
      expect(ZynthVision.horizonPeak.dayName, equals('Saturday'));

      // Day 7: Crystal Form
      expect(ZynthVision.crystalForm.dayNumber, equals(7));
      expect(ZynthVision.crystalForm.name, equals('Crystal Form'));
      expect(ZynthVision.crystalForm.dayName, equals('Sunday'));
    });

    test('weekday mapping routes accurately', () {
      expect(ZynthVision.getVisionForWeekday(1).type, equals(ZynthVisionType.cosmicCore));
      expect(ZynthVision.getVisionForWeekday(2).type, equals(ZynthVisionType.minimalFlow));
      expect(ZynthVision.getVisionForWeekday(3).type, equals(ZynthVisionType.darkForge));
      expect(ZynthVision.getVisionForWeekday(4).type, equals(ZynthVisionType.nebulaWave));
      expect(ZynthVision.getVisionForWeekday(5).type, equals(ZynthVisionType.orbitRing));
      expect(ZynthVision.getVisionForWeekday(6).type, equals(ZynthVisionType.horizonPeak));
      expect(ZynthVision.getVisionForWeekday(7).type, equals(ZynthVisionType.crystalForm));
    });

    test('fromId correctly matches vision ID', () {
      expect(ZynthVision.fromId('cosmic_core').type, equals(ZynthVisionType.cosmicCore));
      expect(ZynthVision.fromId('dark_forge').type, equals(ZynthVisionType.darkForge));
      expect(ZynthVision.fromId('crystal_form').type, equals(ZynthVisionType.crystalForm));
      expect(ZynthVision.fromId('invalid_id').dayNumber, inInclusiveRange(1, 7));
    });

    test('each vision has rich gradient colors and glow', () {
      for (final vision in ZynthVision.allVisions) {
        expect(vision.gradientColors.length, greaterThanOrEqualTo(2));
        expect(vision.iconGradient.length, greaterThanOrEqualTo(2));
        expect(vision.primaryColor, isNotNull);
        expect(vision.accentGlow, isNotNull);
        expect(vision.description.isNotEmpty, isTrue);
      }
    });
  });
}
