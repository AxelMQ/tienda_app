import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Tarjeta de producto con diseño minimalista
// Muestra imagen, nombre, precio, descuento y botón opcional
class ProductCard extends StatefulWidget {
  final String name;
  final double price;
  final double? originalPrice;
  final int? discount;
  final String? imagePath;  // Ruta de asset local (no URL de internet)
  final VoidCallback? onTap;
  final VoidCallback? onOrderAgain;
  final bool showOrderAgainButton;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    this.originalPrice,
    this.discount,
    this.imagePath,
    this.onTap,
    this.onOrderAgain,
    this.showOrderAgainButton = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
        scale: _isPressed ? 0.95 : 1.0,  // Animación sutil al tocar
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Container(
          width: 170,  // Ligeramente más ancho para mejor visualización
          height: widget.showOrderAgainButton ? 240 : 200,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),  // Más redondeado
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow.withOpacity(0.12),  // Sombra visible pero elegante
                offset: const Offset(0, 3),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del producto (ahora con Image.asset para assets locales)
              Container(
                height: 110,  // Más alta para mejor visualización
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,  // Fondo blanco como en Figma
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: widget.imagePath != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.asset(  // Cambiado de Image.network a Image.asset
                          widget.imagePath!,
                          fit: BoxFit.contain,  // contain para ver el producto completo
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                        ),
                      )
                    : _buildPlaceholder(),
              ),
              
              // Información del producto
              Expanded(
                child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del producto
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: AppColors.textBlack,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Precio actual (destacado en rojo)
                    Text(
                      'Bs. ${widget.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.primaryRed,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    
                    // Precio original y descuento (en la misma línea)
                    if (widget.originalPrice != null && widget.originalPrice! > widget.price)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            // Precio tachado
                            Text(
                              'Bs. ${widget.originalPrice!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.textLightGray,
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                                height: 1.2,
                              ),
                            ),
                            if (widget.discount != null) ...[
                              const SizedBox(width: 6),
                              // Badge de descuento más visible
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accentYellow,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${widget.discount}% ${AppConstants.discountText}',
                                  style: const TextStyle(
                                    color: AppColors.textBlack,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    
                    const Spacer(),
                    
                    // Botón "Volver a Pedir" más atractivo
                    if (widget.showOrderAgainButton)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onOrderAgain,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: AppColors.backgroundWhite,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            AppConstants.orderAgainText,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
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

  // Icono de placeholder si no hay imagen
  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(
        Icons.shopping_bag_outlined,
        color: AppColors.textLightGray,
        size: 50,
      ),
    );
  }
}

// Lista horizontal de productos que se puede deslizar
// Muestra el título y las tarjetas en scroll horizontal
class ProductsList extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> products;
  final Function(String)? onProductTap;
  final Function(String)? onOrderAgain;
  final bool showOrderAgainButton;

  const ProductsList({
    super.key,
    required this.title,
    required this.products,
    this.onProductTap,
    this.onOrderAgain,
    this.showOrderAgainButton = false,
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
        
        // Lista horizontal de productos que se desliza suavemente
        SizedBox(
          height: showOrderAgainButton ? 260 : 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(
              AppConstants.defaultPadding,  // Izquierda
              8,  // Arriba - espacio para sombra superior
              AppConstants.defaultPadding,  // Derecha
              8,  // Abajo - espacio para sombra inferior
            ),
            // Para scroll suave en dispositivos
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,  // Permite que las sombras se vean completamente
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                name: product['name'],
                price: product['price'],
                originalPrice: product['originalPrice'],
                discount: product['discount'],
                imagePath: product['image'],  // Cambiado de imageUrl a imagePath
                showOrderAgainButton: showOrderAgainButton,
                onTap: () => onProductTap?.call(product['name']),
                onOrderAgain: () => onOrderAgain?.call(product['name']),
              );
            },
          ),
        ),
      ],
    );
  }
}
