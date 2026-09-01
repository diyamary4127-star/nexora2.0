import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

/// Soft 3D selectable Chip / Pill with active and inactive states
class Soft3DChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? activeColor;
  final Color? activeTextColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const Soft3DChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.activeColor,
    this.activeTextColor,
    this.fontSize = 13,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
  });

  @override
  Widget build(BuildContext context) {
    final bgGradient = isSelected
        ? (activeColor == null
            ? AppColors.primaryGradient
            : LinearGradient(colors: [activeColor!, activeColor!.withValues(alpha: 0.85)]))
        : null;

    final bgColor = isSelected ? null : Colors.white;
    final textColor = isSelected ? (activeTextColor ?? Colors.white) : AppColors.textSecondary;
    final borderColor = isSelected
        ? Colors.transparent
        : AppColors.lightBlueTint.withValues(alpha: 0.9);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: padding,
        decoration: BoxDecoration(
          color: bgColor,
          gradient: bgGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: isSelected ? AppShadows.soft3dChipActive : AppShadows.soft3dChip,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: fontSize + 3,
                color: textColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: textColor,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
