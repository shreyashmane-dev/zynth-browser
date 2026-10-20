import 'package:flutter/material.dart';

/// Represents one of the 7 daily visions and icon designs for Zynth Browser.
/// "One Browser, Seven Visions" - An evolving aesthetic where each day of the
/// week features a distinct, custom-crafted visual identity and theme palette.
enum ZynthVisionType {
  cosmicCore,
  minimalFlow,
  darkForge,
  nebulaWave,
  orbitRing,
  horizonPeak,
  crystalForm,
}

class ZynthVision {
  final ZynthVisionType type;
  final String id;
  final String name;
  final int dayNumber; // 1 = Monday ... 7 = Sunday
  final String dayName;
  final String tagline;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentGlow;
  final Color surfaceColor;
  final List<Color> gradientColors;
  final List<Color> iconGradient;

  const ZynthVision({
    required this.type,
    required this.id,
    required this.name,
    required this.dayNumber,
    required this.dayName,
    required this.tagline,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentGlow,
    required this.surfaceColor,
    required this.gradientColors,
    required this.iconGradient,
  });

  /// Day 1: Cosmic Core (Monday)
  /// Deep space, glowing celestial cyan-blue orb halo, planetary ring orbiting a glowing Z.
  static const ZynthVision cosmicCore = ZynthVision(
    type: ZynthVisionType.cosmicCore,
    id: 'cosmic_core',
    name: 'Cosmic Core',
    dayNumber: 1,
    dayName: 'Monday',
    tagline: 'Celestial Energy & Infinite Space',
    description:
        'A glowing celestial cyan and indigo planetary core with an orbiting orbital ring, radiating cosmic energy across deep space.',
    primaryColor: Color(0xFF00E5FF),
    secondaryColor: Color(0xFF7C3AED),
    accentGlow: Color(0xFF00F5FF),
    surfaceColor: Color(0xFF0B0E1E),
    gradientColors: [Color(0xFF0A0F24), Color(0xFF13092C), Color(0xFF070A18)],
    iconGradient: [Color(0xFF00E5FF), Color(0xFF6366F1), Color(0xFF9333EA)],
  );

  /// Day 2: Minimal Flow (Tuesday)
  /// Clean, frosted light squircle, housing a vibrant, smooth neon gradient ribbon Z.
  static const ZynthVision minimalFlow = ZynthVision(
    type: ZynthVisionType.minimalFlow,
    id: 'minimal_flow',
    name: 'Minimal Flow',
    dayNumber: 2,
    dayName: 'Tuesday',
    tagline: 'Pure Geometry & Iridescent Flow',
    description:
        'A pristine frosted squircle canvas cradling an ultra-smooth 3D ribbon Z with vibrant neon blue-to-violet fluid gradients.',
    primaryColor: Color(0xFF8B5CF6),
    secondaryColor: Color(0xFF06B6D4),
    accentGlow: Color(0xFFC084FC),
    surfaceColor: Color(0xFF151824),
    gradientColors: [Color(0xFF16182C), Color(0xFF1C1335), Color(0xFF121422)],
    iconGradient: [Color(0xFF06B6D4), Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFFD946EF)],
  );

  /// Day 3: Dark Forge (Wednesday)
  /// Chiseled metallic chrome/titanium Z with razor electric cyan lightning highlights on obsidian rock.
  static const ZynthVision darkForge = ZynthVision(
    type: ZynthVisionType.darkForge,
    id: 'dark_forge',
    name: 'Dark Forge',
    dayNumber: 3,
    dayName: 'Wednesday',
    tagline: 'Raw Titanium & Obsidian Strength',
    description:
        'Chiseled metallic chrome forged over volcanic obsidian rock, with razor-sharp electric cyan edges forged under intense pressure.',
    primaryColor: Color(0xFF38BDF8),
    secondaryColor: Color(0xFF94A3B8),
    accentGlow: Color(0xFF0EA5E9),
    surfaceColor: Color(0xFF0D1017),
    gradientColors: [Color(0xFF0F141D), Color(0xFF161922), Color(0xFF090B0E)],
    iconGradient: [Color(0xFFE2E8F0), Color(0xFF94A3B8), Color(0xFF38BDF8), Color(0xFF0284C7)],
  );

  /// Day 4: Nebula Wave (Thursday)
  /// Ethereal cosmic smoke/plasma wave forming the Z, vibrant cosmic violet, magenta, and cyan nebula fluid.
  static const ZynthVision nebulaWave = ZynthVision(
    type: ZynthVisionType.nebulaWave,
    id: 'nebula_wave',
    name: 'Nebula Wave',
    dayNumber: 4,
    dayName: 'Thursday',
    tagline: 'Interstellar Smoke & Stellar Waves',
    description:
        'Luminous interstellar plasma swirls forming an ethereal Z through radiant violet, magenta, and cyan cosmic smoke.',
    primaryColor: Color(0xFFA855F7),
    secondaryColor: Color(0xFFEC4899),
    accentGlow: Color(0xFFE879F9),
    surfaceColor: Color(0xFF120B1F),
    gradientColors: [Color(0xFF180A28), Color(0xFF230C35), Color(0xFF0E0719)],
    iconGradient: [Color(0xFF06B6D4), Color(0xFFA855F7), Color(0xFFEC4899), Color(0xFFF43F5E)],
  );

  /// Day 5: Orbit Ring (Friday)
  /// Tech ring with a luminous planetary satellite dot, encircling a sharp electric-blue Z.
  static const ZynthVision orbitRing = ZynthVision(
    type: ZynthVisionType.orbitRing,
    id: 'orbit_ring',
    name: 'Orbit Ring',
    dayNumber: 5,
    dayName: 'Friday',
    tagline: 'Planetary Paths & Cyber Dynamics',
    description:
        'A glowing circular tech track with an illuminated planetary satellite orb circling a sharp electric cyan-and-magenta Z.',
    primaryColor: Color(0xFF3B82F6),
    secondaryColor: Color(0xFFF43F5E),
    accentGlow: Color(0xFF60A5FA),
    surfaceColor: Color(0xFF0A1124),
    gradientColors: [Color(0xFF0B142F), Color(0xFF191238), Color(0xFF070B1A)],
    iconGradient: [Color(0xFF38BDF8), Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFFF43F5E)],
  );

  /// Day 6: Horizon Peak (Saturday)
  /// Alpine mountain ridges under a starry twilight gradient sky, luminous frosted glass Z rising with horizon glow.
  static const ZynthVision horizonPeak = ZynthVision(
    type: ZynthVisionType.horizonPeak,
    id: 'horizon_peak',
    name: 'Horizon Peak',
    dayNumber: 6,
    dayName: 'Saturday',
    tagline: 'Starry Peaks & Twilight Brilliance',
    description:
        'Silhouetted mountain peaks under a twilight starry night sky, with a translucent crystal Z illuminated by warm sunset horizon glow.',
    primaryColor: Color(0xFFF97316),
    secondaryColor: Color(0xFF6366F1),
    accentGlow: Color(0xFFFB923C),
    surfaceColor: Color(0xFF101328),
    gradientColors: [Color(0xFF111432), Color(0xFF28152E), Color(0xFF0A0D1E)],
    iconGradient: [Color(0xFFF97316), Color(0xFFE11D48), Color(0xFF818CF8), Color(0xFFC7D2FE)],
  );

  /// Day 7: Crystal Form (Sunday)
  /// Low-poly 3D faceted geometric crystal gemstone Z with refractive cyan, sapphire, and amethyst faces.
  static const ZynthVision crystalForm = ZynthVision(
    type: ZynthVisionType.crystalForm,
    id: 'crystal_form',
    name: 'Crystal Form',
    dayNumber: 7,
    dayName: 'Sunday',
    tagline: 'Faceted Gems & Refractive Light',
    description:
        'A multi-faceted 3D geometric crystal prism Z reflecting vibrant sapphire, amethyst, and cyan specular light across sharp gem vertices.',
    primaryColor: Color(0xFF22D3EE),
    secondaryColor: Color(0xFF818CF8),
    accentGlow: Color(0xFF67E8F9),
    surfaceColor: Color(0xFF0B1226),
    gradientColors: [Color(0xFF0C1633), Color(0xFF1C133F), Color(0xFF080D21)],
    iconGradient: [Color(0xFF22D3EE), Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFFA855F7)],
  );

  /// List of all 7 visions in day order (Day 1..Day 7).
  static const List<ZynthVision> allVisions = [
    cosmicCore,
    minimalFlow,
    darkForge,
    nebulaWave,
    orbitRing,
    horizonPeak,
    crystalForm,
  ];

  /// Get the active vision for today based on the day of week (1 = Mon .. 7 = Sun).
  static ZynthVision forToday() {
    final weekday = DateTime.now().weekday; // 1 to 7
    return getVisionForWeekday(weekday);
  }

  /// Map weekday integer (1..7) to vision.
  static ZynthVision getVisionForWeekday(int weekday) {
    if (weekday < 1 || weekday > 7) {
      return cosmicCore;
    }
    return allVisions[weekday - 1];
  }

  /// Get vision by ID string.
  static ZynthVision fromId(String? id) {
    if (id == null || id.isEmpty || id == 'auto') {
      return forToday();
    }
    return allVisions.firstWhere(
      (v) => v.id == id,
      orElse: () => forToday(),
    );
  }
}
