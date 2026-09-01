import 'package:flutter/material.dart';

/// Soft 3D elevation shadows for tactile, neumorphic-inspired blue & white UI
class AppShadows {
  AppShadows._();

  /// Soft 3D elevation for cards with light highlight on top-left and blue-tinted drop shadow
  static List<BoxShadow> get soft3dCard => [
        const BoxShadow(
          color: Color(0xFFFFFFFF),
          offset: Offset(-3, -3),
          blurRadius: 8,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF1E3A8A).withValues(alpha: 0.07),
          offset: const Offset(4, 6),
          blurRadius: 14,
          spreadRadius: 0,
        ),
      ];

  /// High elevation 3D floating effect
  static List<BoxShadow> get soft3dFloating => [
        const BoxShadow(
          color: Color(0xFFFFFFFF),
          offset: Offset(-4, -4),
          blurRadius: 10,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: const Color(0xFF2563EB).withValues(alpha: 0.12),
          offset: const Offset(6, 10),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ];

  /// Glowing blue shadow for 3D buttons
  static List<BoxShadow> get soft3dButton => [
        BoxShadow(
          color: const Color(0xFF2563EB).withValues(alpha: 0.35),
          offset: const Offset(0, 6),
          blurRadius: 14,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];

  /// Subtle soft pill/chip shadow
  static List<BoxShadow> get soft3dChip => [
        const BoxShadow(
          color: Color(0xFFFFFFFF),
          offset: Offset(-2, -2),
          blurRadius: 5,
        ),
        BoxShadow(
          color: const Color(0xFF1E3A8A).withValues(alpha: 0.06),
          offset: const Offset(2, 4),
          blurRadius: 8,
        ),
      ];

  /// Selected / Active 3D chip shadow
  static List<BoxShadow> get soft3dChipActive => [
        BoxShadow(
          color: const Color(0xFF2563EB).withValues(alpha: 0.28),
          offset: const Offset(0, 3),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  /// Subtle recessed / inner style shadow simulation
  static List<BoxShadow> get soft3dInput => [
        BoxShadow(
          color: const Color(0xFF1E3A8A).withValues(alpha: 0.04),
          offset: const Offset(1, 2),
          blurRadius: 6,
          spreadRadius: 0,
        ),
      ];
}
