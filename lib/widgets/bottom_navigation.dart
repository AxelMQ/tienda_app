import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Barra de navegación inferior con diseño moderno y curveado
// Implementa un estilo minimalista con animaciones fluidas
class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.bottomNavHeight,
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        // Bordes superiores curvos para un look moderno
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        // Sombra elevada para dar sensación de flotación
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.15),
            offset: const Offset(0, -4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        // Recorta el contenido para que respete las curvas
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Inicio',
                index: 0,
                isSelected: currentIndex == 0,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.local_offer_rounded,
                label: 'Ofertas',
                index: 1,
                isSelected: currentIndex == 1,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.receipt_long_rounded,
                label: 'Pedidos',
                index: 2,
                isSelected: currentIndex == 2,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Perfil',
                index: 3,
                isSelected: currentIndex == 3,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget individual de navegación con animaciones
// Separado para mejor organización y rendimiento
class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Controlador para las animaciones de selección
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Animación de escala para el efecto de rebote (reducida para evitar overflow)
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Animación de fade para transiciones suaves
    _fadeAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(_controller);

    // Si ya está seleccionado, mostrar animado
    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animar cuando cambia el estado de selección
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(widget.index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono con animación de escala
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  // Fondo suave cuando está seleccionado
                  color: widget.isSelected
                      ? AppColors.primaryRed.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.isSelected
                      ? AppColors.navIconActive
                      : AppColors.navIcon.withOpacity(0.6),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 1),
            
            // Texto con animación de fade
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget.isSelected
                      ? AppColors.navIconActive
                      : AppColors.navIcon.withOpacity(0.6),
                  fontSize: 9,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.1,
                  height: 1.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Indicador de selección (línea inferior)
            if (widget.isSelected)
              Container(
                margin: const EdgeInsets.only(top: 1),
                height: 2,
                width: 20,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
