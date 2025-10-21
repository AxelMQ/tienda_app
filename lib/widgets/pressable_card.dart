import 'package:flutter/material.dart';

// Card con animación de escala al presionar
// Proporciona feedback táctil al usuario cuando toca elementos interactivos
// Usado en listas de opciones, menús de configuración, etc.
class PressableCard extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const PressableCard({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

