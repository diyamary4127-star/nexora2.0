import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

enum Soft3DButtonType { primary, secondary, outline, danger }

/// Tactile 3D Button with satisfying visual depth, gradients, and soft glow
class Soft3DButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Soft3DButtonType type;
  final double? width;
  final double height;
  final double borderRadius;
  final bool isLoading;

  const Soft3DButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.type = Soft3DButtonType.primary,
    this.width,
    this.height = 54,
    this.borderRadius = 16,
    this.isLoading = false,
  });

  @override
  State<Soft3DButton> createState() => _Soft3DButtonState();
}

class _Soft3DButtonState extends State<Soft3DButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    Color textColor;
    Gradient? gradient;
    Color? bgColor;
    Border? border;
    List<BoxShadow> shadows = [];

    switch (widget.type) {
      case Soft3DButtonType.primary:
        gradient = isDisabled
            ? const LinearGradient(colors: [Color(0xFF93C5FD), Color(0xFF60A5FA)])
            : AppColors.primaryGradient;
        textColor = Colors.white;
        if (!isDisabled && !_isPressed) {
          shadows = AppShadows.soft3dButton;
        }
        break;
      case Soft3DButtonType.secondary:
        bgColor = AppColors.iceBlue;
        textColor = AppColors.primaryDark;
        border = Border.all(color: Colors.white, width: 1.5);
        if (!isDisabled && !_isPressed) {
          shadows = AppShadows.soft3dCard;
        }
        break;
      case Soft3DButtonType.outline:
        bgColor = Colors.white;
        textColor = AppColors.primary;
        border = Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5);
        if (!isDisabled && !_isPressed) {
          shadows = AppShadows.soft3dCard;
        }
        break;
      case Soft3DButtonType.danger:
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        border = Border.all(color: Colors.white, width: 1.5);
        break;
    }

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
      onTap: isDisabled ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: widget.width,
        height: widget.height,
        transform: _isPressed ? Matrix4.translationValues(0, 2, 0) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: bgColor,
          gradient: gradient,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: border,
          boxShadow: shadows,
        ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: textColor, size: widget.height < 45 ? 16 : 19),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          widget.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textColor,
                            fontSize: widget.height < 45 ? 13 : 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
