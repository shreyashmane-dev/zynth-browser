import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../models/zynth_vision.dart';

/// Renders one of the 7 Zynth Day Logos ("One Browser, Seven Visions")
/// with high visual fidelity, custom shaders, gradients, and dynamic scaling.
class ZynthLogoWidget extends StatelessWidget {
  final ZynthVision vision;
  final double size;
  final bool showBadge;
  final bool animateGlow;

  const ZynthLogoWidget({
    super.key,
    required this.vision,
    this.size = 72,
    this.showBadge = false,
    this.animateGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _ZynthVisionPainter(vision: vision),
          ),
          if (showBadge)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: vision.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: vision.primaryColor.withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  'D${vision.dayNumber}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ZynthVisionPainter extends CustomPainter {
  final ZynthVision vision;

  _ZynthVisionPainter({required this.vision});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final rect = Offset.zero & size;

    switch (vision.type) {
      case ZynthVisionType.cosmicCore:
        _paintCosmicCore(canvas, size, center, rect);
        break;
      case ZynthVisionType.minimalFlow:
        _paintMinimalFlow(canvas, size, center, rect);
        break;
      case ZynthVisionType.darkForge:
        _paintDarkForge(canvas, size, center, rect);
        break;
      case ZynthVisionType.nebulaWave:
        _paintNebulaWave(canvas, size, center, rect);
        break;
      case ZynthVisionType.orbitRing:
        _paintOrbitRing(canvas, size, center, rect);
        break;
      case ZynthVisionType.horizonPeak:
        _paintHorizonPeak(canvas, size, center, rect);
        break;
      case ZynthVisionType.crystalForm:
        _paintCrystalForm(canvas, size, center, rect);
        break;
    }
  }

  /// -------------------------------------------------------------
  /// DAY 1: COSMIC CORE
  /// Celestial cyan/purple orb halo, planetary ring, glowing Z
  /// -------------------------------------------------------------
  void _paintCosmicCore(Canvas canvas, Size size, Offset center, Rect rect) {
    final radius = size.width * 0.46;

    // Background cosmic space squircle
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.28));
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF141A3E), Color(0xFF090B1A), Color(0xFF04050D)],
        stops: [0.0, 0.7, 1.0],
      ).createShader(rect);
    canvas.drawRRect(rrect, bgPaint);

    // Deep cosmic halo aura
    final haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00E5FF).withOpacity(0.4),
          const Color(0xFF7C3AED).withOpacity(0.25),
          Colors.transparent,
        ],
        stops: const [0.2, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.15));
    canvas.drawCircle(center, radius * 1.15, haloPaint);

    // Twinkling stars
    final starPaint = Paint()..color = Colors.white.withOpacity(0.7);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.22), size.width * 0.015, starPaint);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.28), size.width * 0.012, starPaint);
    canvas.drawCircle(Offset(size.width * 0.20, size.height * 0.75), size.width * 0.018, starPaint);

    // Back half of planetary orbit ring
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04
      ..shader = const SweepGradient(
        colors: [Color(0xFF00F5FF), Color(0xFF8B5CF6), Color(0xFFEC4899), Color(0xFF00F5FF)],
      ).createShader(rect);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 4.8);
    final ringRect = Rect.fromCenter(
      center: Offset.zero,
      width: radius * 2.1,
      height: radius * 0.75,
    );
    canvas.drawArc(ringRect, math.pi, math.pi, false, ringPaint);
    canvas.restore();

    // Central Glowing Z
    _drawStylizedZ(
      canvas: canvas,
      size: size,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFFFF), Color(0xFF00E5FF), Color(0xFF6366F1)],
      ),
      glowColor: const Color(0xFF00E5FF),
      glowRadius: size.width * 0.08,
    );

    // Front half of planetary orbit ring
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 4.8);
    canvas.drawArc(ringRect, 0, math.pi, false, ringPaint);

    // Orbiting celestial satellite orb
    final orbOffset = Offset(radius * 1.05 * math.cos(0.2), radius * 0.375 * math.sin(0.2));
    final orbPaint = Paint()
      ..color = const Color(0xFF00F5FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);
    canvas.drawCircle(orbOffset, size.width * 0.045, orbPaint);
    canvas.drawCircle(orbOffset, size.width * 0.025, Paint()..color = Colors.white);
    canvas.restore();
  }

  /// -------------------------------------------------------------
  /// DAY 2: MINIMAL FLOW
  /// Frosted clean squircle, smooth iridescent fluid ribbon Z
  /// -------------------------------------------------------------
  void _paintMinimalFlow(Canvas canvas, Size size, Offset center, Rect rect) {
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.28));

    // Frosted clean squircle background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
      ).createShader(rect);
    canvas.drawRRect(rrect, bgPaint);

    // Subtle inner border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02
      ..color = Colors.white.withOpacity(0.85);
    canvas.drawRRect(rrect, borderPaint);

    // Dynamic 3D Ribbon Z with smooth curved caps
    final path = Path();
    final p0 = Offset(size.width * 0.26, size.height * 0.28);
    final p1 = Offset(size.width * 0.74, size.height * 0.28);
    final p2 = Offset(size.width * 0.28, size.height * 0.72);
    final p3 = Offset(size.width * 0.76, size.height * 0.72);

    final ribbonPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.16
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF06B6D4),
          Color(0xFF3B82F6),
          Color(0xFF8B5CF6),
          Color(0xFFD946EF),
        ],
      ).createShader(rect);

    path.moveTo(p0.dx, p0.dy);
    path.lineTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p3.dx, p3.dy);

    // Ribbon drop shadow on frosted canvas
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = size.width * 0.16
        ..color = const Color(0xFF8B5CF6).withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    canvas.drawPath(path, ribbonPaint);

    // Glossy specular highlight line along the ribbon
    final highlightPath = Path()
      ..moveTo(p0.dx + size.width * 0.04, p0.dy - size.width * 0.03)
      ..lineTo(p1.dx - size.width * 0.04, p1.dy - size.width * 0.03);
    canvas.drawPath(
      highlightPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = size.width * 0.04
        ..color = Colors.white.withOpacity(0.6),
    );
  }

  /// -------------------------------------------------------------
  /// DAY 3: DARK FORGE
  /// Obsidian rock texture, chiseled titanium Z with electric cyan edges
  /// -------------------------------------------------------------
  void _paintDarkForge(Canvas canvas, Size size, Offset center, Rect rect) {
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.28));

    // Obsidian rock background
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF1E2430), Color(0xFF101319), Color(0xFF08090C)],
        stops: [0.0, 0.7, 1.0],
      ).createShader(rect);
    canvas.drawRRect(rrect, bgPaint);

    // Obsidian rock fracture lines
    final crackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFF2B3345).withOpacity(0.6);
    canvas.drawLine(Offset(size.width * 0.1, size.height * 0.3), Offset(size.width * 0.3, size.height * 0.45), crackPaint);
    canvas.drawLine(Offset(size.width * 0.7, size.height * 0.2), Offset(size.width * 0.85, size.height * 0.38), crackPaint);
    canvas.drawLine(Offset(size.width * 0.65, size.height * 0.75), Offset(size.width * 0.88, size.height * 0.85), crackPaint);

    // Chiseled Metallic Z (Outer electric blue outline glow)
    _drawSharpZ(
      canvas: canvas,
      size: size,
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.05
        ..color = const Color(0xFF38BDF8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 8),
    );

    // Titanium Chiseled Body
    final titaniumGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF1F5F9), Color(0xFF94A3B8), Color(0xFF475569), Color(0xFF1E293B)],
    ).createShader(rect);

    _drawSharpZ(
      canvas: canvas,
      size: size,
      paint: Paint()
        ..style = PaintingStyle.fill
        ..shader = titaniumGradient,
    );

    // Razor-sharp electric cyan lightning bevels
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02
      ..color = const Color(0xFF38BDF8);
    _drawSharpZ(canvas: canvas, size: size, paint: edgePaint);
  }

  /// -------------------------------------------------------------
  /// DAY 4: NEBULA WAVE
  /// Cosmic plasma smoke, ethereal violet, magenta, and cyan swirl
  /// -------------------------------------------------------------
  void _paintNebulaWave(Canvas canvas, Size size, Offset center, Rect rect) {
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.28));

    // Deep space void
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF160A26), Color(0xFF090412), Color(0xFF030106)],
        stops: [0.0, 0.7, 1.0],
      ).createShader(rect);
    canvas.drawRRect(rrect, bgPaint);

    // Multi-layered ethereal nebula smoke trails
    final nebulaPath = Path();
    nebulaPath.moveTo(size.width * 0.24, size.height * 0.28);
    nebulaPath.cubicTo(
      size.width * 0.5,
      size.height * 0.18,
      size.width * 0.65,
      size.height * 0.26,
      size.width * 0.76,
      size.height * 0.28,
    );
    nebulaPath.cubicTo(
      size.width * 0.55,
      size.height * 0.45,
      size.width * 0.42,
      size.height * 0.55,
      size.width * 0.26,
      size.height * 0.72,
    );
    nebulaPath.cubicTo(
      size.width * 0.45,
      size.height * 0.74,
      size.width * 0.6,
      size.height * 0.82,
      size.width * 0.76,
      size.height * 0.72,
    );

    // Deep nebula glow
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.24
      ..shader = const LinearGradient(
        colors: [Color(0xFF06B6D4), Color(0xFFA855F7), Color(0xFFEC4899), Color(0xFF8B5CF6)],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawPath(nebulaPath, glowPaint);

    // Vibrant middle plasma ribbon
    final plasmaPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.14
      ..shader = const LinearGradient(
        colors: [Color(0xFF38BDF8), Color(0xFFC084FC), Color(0xFFF472B6), Color(0xFF38BDF8)],
      ).createShader(rect);
    canvas.drawPath(nebulaPath, plasmaPaint);

    // Intense core light streak
    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.04
      ..color = Colors.white.withOpacity(0.9);
    canvas.drawPath(nebulaPath, corePaint);
  }

  /// -------------------------------------------------------------
  /// DAY 5: ORBIT RING
  /// High-tech ring with satellite dot, sharp cyber electric Z
  /// -------------------------------------------------------------
  void _paintOrbitRing(Canvas canvas, Size size, Offset center, Rect rect) {
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.28));

    // Dark cyber blue background
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF101B38), Color(0xFF090E1F), Color(0xFF05070F)],
        stops: [0.0, 0.7, 1.0],
      ).createShader(rect);
    canvas.drawRRect(rrect, bgPaint);

    // Outer continuous orbit ring track
    final orbitRadius = size.width * 0.38;
    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.035
      ..shader = const SweepGradient(
        colors: [Color(0xFF38BDF8), Color(0xFF8B5CF6), Color(0xFFEC4899), Color(0xFF38BDF8)],
      ).createShader(Rect.fromCircle(center: center, radius: orbitRadius));

    // Orbit outer glow
    canvas.drawCircle(
      center,
      orbitRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.07
        ..color = const Color(0xFF38BDF8).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(center, orbitRadius, orbitPaint);

    // Sharp Cyber Z inside
    _drawSharpZ(
      canvas: canvas,
      size: size * 0.9,
      paint: Paint()
        ..style = PaintingStyle.fill
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF38BDF8), Color(0xFF3B82F6), Color(0xFF6366F1)],
        ).createShader(rect),
    );

    // Satellite orb on the orbit ring (top right)
    final angle = -math.pi / 4;
    final orbPos = Offset(
      center.dx + orbitRadius * math.cos(angle),
      center.dy + orbitRadius * math.sin(angle),
    );

    // Satellite glow & body
    canvas.drawCircle(
      orbPos,
      size.width * 0.055,
      Paint()
        ..color = const Color(0xFF38BDF8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 6),
    );
    canvas.drawCircle(orbPos, size.width * 0.035, Paint()..color = Colors.white);
  }

  /// -------------------------------------------------------------
  /// DAY 6: HORIZON PEAK
  /// Alpine mountain ridges, sunset horizon glow, frosted glass Z
  /// -------------------------------------------------------------
  void _paintHorizonPeak(Canvas canvas, Size size, Offset center, Rect rect) {
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.28));

    // Twilight night gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0B0E23), Color(0xFF1E1438), Color(0xFF2C1330), Color(0xFF3B1527)],
      ).createShader(rect);
    canvas.drawRRect(rrect, bgPaint);

    // Distant starry sky
    final starPaint = Paint()..color = Colors.white.withOpacity(0.65);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.18), 1.2, starPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.12), 1.5, starPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.22), 1.0, starPaint);

    // Warm Sunset/Sunrise Horizon Glow line
    final horizonPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          const Color(0xFFF97316).withOpacity(0.55),
          const Color(0xFFFB7185).withOpacity(0.4),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.3));
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.3), horizonPaint);

    // Translucent Frosted Glass Z rising over peaks
    _drawSharpZ(
      canvas: canvas,
      size: size,
      paint: Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.95),
            const Color(0xFFC7D2FE).withOpacity(0.85),
            const Color(0xFFFDA4AF).withOpacity(0.75),
          ],
        ).createShader(rect),
    );

    // Mountain silhouettes in front of Z
    final mountainPath = Path();
    mountainPath.moveTo(0, size.height);
    mountainPath.lineTo(0, size.height * 0.78);
    mountainPath.lineTo(size.width * 0.22, size.height * 0.65);
    mountainPath.lineTo(size.width * 0.42, size.height * 0.74);
    mountainPath.lineTo(size.width * 0.64, size.height * 0.60);
    mountainPath.lineTo(size.width * 0.84, size.height * 0.72);
    mountainPath.lineTo(size.width, size.height * 0.66);
    mountainPath.lineTo(size.width, size.height);
    mountainPath.close();

    final mountainPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1B1B3A), Color(0xFF0F0F24)],
      ).createShader(rect);

    // Clip mountain to squircle bounds
    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawPath(mountainPath, mountainPaint);

    // Mountain ridge highlight
    final ridgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = const LinearGradient(
        colors: [Color(0xFFF97316), Color(0xFFE11D48), Color(0xFF818CF8)],
      ).createShader(rect);
    canvas.drawPath(mountainPath, ridgePaint);
    canvas.restore();
  }

  /// -------------------------------------------------------------
  /// DAY 7: CRYSTAL FORM
  /// 3D Faceted geometric crystal gemstone Z with specular highlights
  /// -------------------------------------------------------------
  void _paintCrystalForm(Canvas canvas, Size size, Offset center, Rect rect) {
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.28));

    // Deep jewel navy background
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF0F1E3D), Color(0xFF091024), Color(0xFF040712)],
        stops: [0.0, 0.7, 1.0],
      ).createShader(rect);
    canvas.drawRRect(rrect, bgPaint);

    // Ambient crystal aura
    canvas.drawCircle(
      center,
      size.width * 0.4,
      Paint()
        ..color = const Color(0xFF22D3EE).withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );

    // Draw Faceted Gemstone Z faces:
    final w = size.width;
    final h = size.height;

    // Gem Face 1: Top horizontal prism (Cyan to white)
    final face1 = Path()
      ..moveTo(w * 0.24, h * 0.24)
      ..lineTo(w * 0.76, h * 0.24)
      ..lineTo(w * 0.65, h * 0.38)
      ..lineTo(w * 0.35, h * 0.38)
      ..close();
    canvas.drawPath(
      face1,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFE0F2FE), Color(0xFF38BDF8), Color(0xFF22D3EE)],
        ).createShader(rect),
    );

    // Gem Face 2: Top right facet
    final face2 = Path()
      ..moveTo(w * 0.76, h * 0.24)
      ..lineTo(w * 0.65, h * 0.38)
      ..lineTo(w * 0.52, h * 0.52)
      ..close();
    canvas.drawPath(
      face2,
      Paint()..color = const Color(0xFF0284C7),
    );

    // Gem Face 3: Center diagonal diamond facet (Sapphire blue)
    final face3 = Path()
      ..moveTo(w * 0.65, h * 0.38)
      ..lineTo(w * 0.52, h * 0.52)
      ..lineTo(w * 0.35, h * 0.62)
      ..lineTo(w * 0.35, h * 0.38)
      ..close();
    canvas.drawPath(
      face3,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF38BDF8), Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ).createShader(rect),
    );

    // Gem Face 4: Center-to-bottom diagonal facet (Indigo / Amethyst)
    final face4 = Path()
      ..moveTo(w * 0.52, h * 0.52)
      ..lineTo(w * 0.76, h * 0.76)
      ..lineTo(w * 0.65, h * 0.62)
      ..lineTo(w * 0.35, h * 0.62)
      ..close();
    canvas.drawPath(
      face4,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFF9333EA)],
        ).createShader(rect),
    );

    // Gem Face 5: Bottom horizontal prism (Amethyst to magenta)
    final face5 = Path()
      ..moveTo(w * 0.24, h * 0.76)
      ..lineTo(w * 0.76, h * 0.76)
      ..lineTo(w * 0.65, h * 0.62)
      ..lineTo(w * 0.35, h * 0.62)
      ..close();
    canvas.drawPath(
      face5,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF9333EA), Color(0xFFC026D3), Color(0xFFE879F9)],
        ).createShader(rect),
    );

    // Sharp Facet Wireframe edges (Crystal Specular Reflection)
    final wireframePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withOpacity(0.7);
    canvas.drawPath(face1, wireframePaint);
    canvas.drawPath(face2, wireframePaint);
    canvas.drawPath(face3, wireframePaint);
    canvas.drawPath(face4, wireframePaint);
    canvas.drawPath(face5, wireframePaint);

    // Specular light glints on vertices
    final glintPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.24, h * 0.24), 2.2, glintPaint);
    canvas.drawCircle(Offset(w * 0.65, h * 0.38), 2.0, glintPaint);
    canvas.drawCircle(Offset(w * 0.76, h * 0.76), 2.2, glintPaint);
  }

  /// Helper: Draws stylized Z glyph
  void _drawStylizedZ({
    required Canvas canvas,
    required Size size,
    required Gradient gradient,
    required Color glowColor,
    required double glowRadius,
  }) {
    final path = _createZPath(size);

    // Glow
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.08
        ..color = glowColor.withOpacity(0.4)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius),
    );

    // Fill
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..shader = gradient.createShader(Offset.zero & size),
    );
  }

  /// Helper: Draws sharp angular chiseled Z
  void _drawSharpZ({
    required Canvas canvas,
    required Size size,
    required Paint paint,
  }) {
    final path = _createZPath(size);
    canvas.drawPath(path, paint);
  }

  /// Builds a sharp geometric Z polygon path
  Path _createZPath(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    path.moveTo(w * 0.25, h * 0.26);
    path.lineTo(w * 0.75, h * 0.26);
    path.lineTo(w * 0.75, h * 0.38);
    path.lineTo(w * 0.44, h * 0.64);
    path.lineTo(w * 0.75, h * 0.64);
    path.lineTo(w * 0.75, h * 0.76);
    path.lineTo(w * 0.25, h * 0.76);
    path.lineTo(w * 0.25, h * 0.64);
    path.lineTo(w * 0.56, h * 0.38);
    path.lineTo(w * 0.25, h * 0.38);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant _ZynthVisionPainter oldDelegate) {
    return oldDelegate.vision.type != vision.type;
  }
}
