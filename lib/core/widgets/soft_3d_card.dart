import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

/// Soft 3D elevated card with smooth curves and subtle light reflections
class Soft3DCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final Border? border;
  final List<BoxShadow>? customShadow;

  const Soft3DCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.borderRadius = 20,
    this.backgroundColor,
    this.gradient,
    this.onTap,
    this.border,
    this.customShadow,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? AppColors.surfaceWhite) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: 1.2,
            ),
        boxShadow: customShadow ?? AppShadows.soft3dCard,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
