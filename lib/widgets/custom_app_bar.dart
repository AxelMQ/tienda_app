import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Barra superior de la aplicación que muestra el logo y el carrito
// Diseñada para ser consistente en todas las pantallas
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCartButton;
  final VoidCallback? onCartPressed;
  final int cartItemCount;

  const CustomAppBar({
    super.key,
    this.title = AppConstants.appName,
    this.showCartButton = true,
    this.onCartPressed,
    this.cartItemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.headerHeight,
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        // Sombra sutil para dar profundidad sin ser muy invasiva
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sección del logo - ocupa todo el espacio disponible y centra el contenido
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Imagen del logo con bordes redondeados
                      Hero(
                        tag: 'app_logo',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                          child: Image.asset(
                            'assets/icons/la_canasta.png',
                            width: 45,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Nombre de la aplicación
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botón del carrito con animaciones
              if (showCartButton)
                _CartButton(
                  cartItemCount: cartItemCount,
                  onPressed: onCartPressed ?? () => _showCart(context),
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.headerHeight);

  // Función temporal que se ejecuta cuando se toca el carrito
  // En una versión completa, esto llevaría al usuario a la pantalla del carrito
  void _showCart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Carrito de compras'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Widget separado para el botón del carrito
// Lo mantuvimos aparte para que sea más fácil añadirle animaciones y modificarlo
class _CartButton extends StatefulWidget {
  final int cartItemCount;
  final VoidCallback onPressed;

  const _CartButton({
    required this.cartItemCount,
    required this.onPressed,
  });

  @override
  State<_CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<_CartButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    // Controlador para animar el badge cuando cambia el número de items
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_CartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cuando cambia el número de items, hacemos una pequeña animación de rebote
    if (oldWidget.cartItemCount != widget.cartItemCount && widget.cartItemCount > 0) {
      _controller.forward(from: 0.0);
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
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        // Efecto de rebote al soltar el botón
        curve: Curves.easeOutBack,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            // La sombra se reduce cuando está presionado para dar sensación de profundidad
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryRed.withOpacity(_isPressed ? 0.2 : 0.3),
                offset: Offset(0, _isPressed ? 1 : 2),
                blurRadius: _isPressed ? 3 : 6,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.backgroundWhite,
                size: 24,
              ),
              // El badge solo aparece cuando hay items en el carrito
              if (widget.cartItemCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 1.0, end: 1.3).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.accentYellow,
                        shape: BoxShape.circle,
                        // Borde blanco para que resalte del fondo
                        border: Border.all(
                          color: AppColors.backgroundWhite,
                          width: 2,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          // Si hay más de 99 items, mostramos "99+"
                          widget.cartItemCount > 99 ? '99+' : '${widget.cartItemCount}',
                          style: const TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
