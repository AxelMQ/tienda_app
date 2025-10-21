import 'package:flutter/material.dart';

// Botón de ícono con animación de escala al presionar
// Proporciona feedback táctil al usuario de manera más pronunciada que un botón normal
// Ideal para acciones importantes en headers, modales, etc.
class PressableIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final double? padding;
  final double? borderRadius;

  const PressableIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
    this.padding,
    this.borderRadius,
  });

  @override
  State<PressableIconButton> createState() => _PressableIconButtonState();
}

class _PressableIconButtonState extends State<PressableIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          padding: EdgeInsets.all(widget.padding ?? 8),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
          ),
          child: Icon(
            widget.icon,
            color: widget.iconColor ?? Colors.white,
            size: widget.iconSize ?? 22,
          ),
        ),
      ),
    );
  }
}

