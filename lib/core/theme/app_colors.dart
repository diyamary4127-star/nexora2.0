import 'package:flutter/material.dart';

/// Blue & White theme colors with rich shades of blue
class AppColors {
  AppColors._();

  // Primary Blues
  static const Color primary = Color(0xFF2563EB); // Royal / Electric Blue
  static const Color primaryDark = Color(0xFF1E3A8A); // Deep Navy Blue
  static const Color primaryAccent = Color(0xFF1D4ED8); // Vibrant Royal Accent
  static const Color primaryLight = Color(0xFF3B82F6); // Bright Blue
  static const Color electric = Color(0xFF60A5FA); // Sky Electric

  // Soft Ice Blues & Whites
  static const Color iceBlue = Color(0xFFE0F2FE); // Soft Ice Blue
  static const Color lightBlueTint = Color(0xFFDBEAFE); // Crisp Blue Tint
  static const Color background = Color(0xFFF2F7FD); // Soft Campus Canvas
  static const Color surfaceWhite = Color(0xFFFFFFFF); // Clean Card White
  static const Color surfaceSoft = Color(0xFFF8FAFC); // Subtle Off-White

  // Text & Accents
  static const Color textPrimary = Color(0xFF0F172A); // Dark Navy Black
  static const Color textSecondary = Color(0xFF475569); // Slate Blue
  static const Color textMuted = Color(0xFF94A3B8); // Muted Slate
  static const Color borderSubtle = Color(0xFFE2E8F0); // Subtle Border

  // Status & Tags
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPurpleBg = Color(0xFFEDE9FE);
  static const Color error = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient deepBlueGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient softBlueCardGradient = LinearGradient(
    colors: [Color(0xFFF0F6FF), Color(0xFFFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
