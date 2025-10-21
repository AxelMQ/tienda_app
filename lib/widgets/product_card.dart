import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Tarjeta de producto con diseño minimalista
// Muestra imagen, nombre, precio, descuento y botón opcional
// Incluye botón flotante para agregar al carrito rápidamente
class ProductCard extends StatefulWidget {
  final String name;
  final double price;
  final double? originalPrice;
  final int? discount;
  final String? imagePath;  // Ruta de asset local (no URL de internet)
  final VoidCallback? onTap;
  final VoidCallback? onOrderAgain;
  final VoidCallback? onAddToCart;  // Callback para agregar al carrito
  final bool showOrderAgainButton;
  final bool showAddToCartButton;  // Mostrar botón flotante de agregar

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    this.originalPrice,
    this.discount,
    this.imagePath,
    this.onTap,
    this.onOrderAgain,
    this.onAddToCart,
    this.showOrderAgainButton = false,
    this.showAddToCartButton = true,  // Por defecto sí se muestra
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
        child: Stack(
          children: [
            // Card principal del producto
            Container(
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
                  // Imagen del producto con Hero animation para transición suave al detalle
                  Hero(
                    tag: 'product_${widget.name}',  // Tag único para cada producto
                    child: Container(
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
                              child: Image.asset(
                                widget.imagePath!,
                                fit: BoxFit.cover,  // cover para rellenar todo el espacio
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                              ),
                            )
                          : _buildPlaceholder(),
                    ),
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
                              fontSize: 12,  // Reducido de 13 a 12
                              fontWeight: FontWeight.w600,
                              height: 1.2,  // Reducido de 1.3 a 1.2
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 4),  // Reducido de 6 a 4
                          
                          // Precio actual (destacado en rojo)
                          Text(
                            'Bs. ${widget.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.primaryRed,
                              fontSize: 16,  // Reducido de 18 a 16
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,  // Reducido de 0.5 a 0.3
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
            
            // Botón flotante para agregar al carrito rápidamente
            // Solo aparece si showAddToCartButton es true
            if (widget.showAddToCartButton && widget.onAddToCart != null)
              Positioned(
                top: 8,
                right: 20,  // 8 del edge + 12 del margin
                child: _AddToCartButton(
                  onPressed: widget.onAddToCart!,
                ),
              ),
          ],
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

// Botón circular flotante para agregar productos al carrito
// Incluye animación de escala al presionar y feedback visual
class _AddToCartButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _AddToCartButton({
    required this.onPressed,
  });

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton> {
  bool _isPressed = false;
  bool _justAdded = false;

  void _handlePress() {
    setState(() => _justAdded = true);
    widget.onPressed();
    
    // Vuelve al estado normal después de la animación
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _justAdded = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _handlePress();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : (_justAdded ? 1.1 : 1.0),
        duration: Duration(milliseconds: _justAdded ? 200 : 100),
        curve: _justAdded ? Curves.elasticOut : Curves.easeOut,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _justAdded ? Colors.green : AppColors.primaryRed,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (_justAdded ? Colors.green : AppColors.primaryRed)
                    .withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            _justAdded ? Icons.check_rounded : Icons.add_rounded,
            color: AppColors.backgroundWhite,
            size: 20,
          ),
        ),
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
  final Function(String)? onAddToCart;  // Callback para agregar al carrito
  final bool showOrderAgainButton;
  final bool showAddToCartButton;  // Mostrar botón de agregar

  const ProductsList({
    super.key,
    required this.title,
    required this.products,
    this.onProductTap,
    this.onOrderAgain,
    this.onAddToCart,
    this.showOrderAgainButton = false,
    this.showAddToCartButton = true,  // Por defecto sí se muestra
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
                showAddToCartButton: showAddToCartButton,
                onTap: () => onProductTap?.call(product['name']),
                onOrderAgain: () => onOrderAgain?.call(product['name']),
                onAddToCart: onAddToCart != null 
                    ? () => onAddToCart?.call(product['name']) 
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
