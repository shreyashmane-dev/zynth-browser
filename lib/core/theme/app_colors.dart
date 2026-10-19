import 'package:flutter/material.dart';

/// Zynth Browser unified color palette.
/// Designed for a premium, dark-first browsing experience with restrained
/// modern accents and high visual contrast.
class AppColors {
  // Deep Backgrounds
  static const Color background = Color(0xFF0B0C10);
  static const Color surface = Color(0xFF15171F);
  static const Color surfaceVariant = Color(0xFF1E202C);
  static const Color surfaceElevated = Color(0xFF252837);

  // Borders & Dividers
  static const Color border = Color(0xFF2C2F40);
  static const Color borderSubtle = Color(0xFF202331);
  static const Color divider = Color(0xFF1E212E);

  // Accents
  static const Color primary = Color(0xFF7C5CFC); // Restrained electric violet
  static const Color primaryHover = Color(0xFF9074FF);
  static const Color primaryMuted = Color(0x267C5CFC);
  static const Color secondary = Color(0xFF38BDF8); // Fresh sky blue
  static const Color secondaryMuted = Color(0x2038BDF8);

  // Text Colors
  static const Color textPrimary = Color(0xFFF1F3F9);
  static const Color textSecondary = Color(0xFF949BAF);
  static const Color textMuted = Color(0xFF636B83);
  static const Color textInverse = Color(0xFF0B0C10);

  // Status & Feedback
  static const Color success = Color(0xFF10B981);
  static const Color successMuted = Color(0x2010B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningMuted = Color(0x20F59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color errorMuted = Color(0x20EF4444);

  // Browser Specific UI
  static const Color addressBarBg = Color(0xFF161823);
  static const Color addressBarBorder = Color(0xFF292C3D);
  static const Color navigationBarBg = Color(0xFF111219);
  static const Color cardBg = Color(0xFF171924);
  static const Color progressIndicator = Color(0xFF7C5CFC);
  static const Color secureGreen = Color(0xFF10B981);
  static const Color insecureGrey = Color(0xFF949BAF);
}
