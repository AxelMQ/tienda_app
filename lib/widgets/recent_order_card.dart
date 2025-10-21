import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Tarjeta horizontal para pedidos recientes
// Diseñada para mostrar productos que el usuario ya compró anteriormente
// con un botón prominente para volver a pedir fácilmente
class RecentOrderCard extends StatefulWidget {
  final String name;
  final double price;
  final double? originalPrice;
  final int? discount;
  final String? imagePath;
  final VoidCallback? onTap;
  final VoidCallback? onOrderAgain;

  const RecentOrderCard({
    super.key,
    required this.name,
    required this.price,
    this.originalPrice,
    this.discount,
    this.imagePath,
    this.onTap,
    this.onOrderAgain,
  });

  @override
  State<RecentOrderCard> createState() => _RecentOrderCardState();
}

class _RecentOrderCardState extends State<RecentOrderCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,  // Animación muy sutil al tocar
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(16),
            // Sombra sutil para separar del fondo
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow.withOpacity(0.12),
                offset: const Offset(0, 3),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              // Imagen del producto a la izquierda
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: widget.imagePath != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Image.asset(
                          widget.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        ),
                      )
                    : _buildPlaceholder(),
              ),

              // Información del producto en el centro
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nombre del producto
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: AppColors.textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 6),
                      
                      // Precio actual
                      Text(
                        'Bs. ${widget.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.primaryRed,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      // Precio original y descuento (si existen)
                      if (widget.originalPrice != null && 
                          widget.originalPrice! > widget.price)
                        Row(
                          children: [
                            Text(
                              'Bs. ${widget.originalPrice!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.textLightGray,
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            if (widget.discount != null) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accentYellow,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${widget.discount}% ${AppConstants.discountText}',
                                  style: const TextStyle(
                                    color: AppColors.textBlack,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // Botón "Volver a Pedir" a la derecha
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ElevatedButton(
                  onPressed: widget.onOrderAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.backgroundWhite,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh_rounded, size: 20),
                      SizedBox(height: 2),
                      Text(
                        'Repetir',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Placeholder si no hay imagen
  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(
        Icons.shopping_bag_outlined,
        color: AppColors.textLightGray,
        size: 40,
      ),
    );
  }
}

// Lista vertical de pedidos recientes
// Se muestra con scroll vertical para ver todo el historial
class RecentOrdersList extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> orders;
  final Function(String)? onOrderTap;
  final Function(String)? onOrderAgain;

  const RecentOrdersList({
    super.key,
    required this.title,
    required this.orders,
    this.onOrderTap,
    this.onOrderAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
              letterSpacing: 0.3,
            ),
          ),
        ),
        
        // Lista de pedidos recientes (scroll vertical)
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
          ),
          child: Column(
            children: orders.map((order) {
              return RecentOrderCard(
                name: order['name'],
                price: order['price'],
                originalPrice: order['originalPrice'],
                discount: order['discount'],
                imagePath: order['image'],
                onTap: () => onOrderTap?.call(order['name']),
                onOrderAgain: () => onOrderAgain?.call(order['name']),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

