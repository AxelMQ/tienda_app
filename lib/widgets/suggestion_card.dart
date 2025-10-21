import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Tarjeta de sugerencia compacta para agregar productos rápidamente
// Diseño minimalista: solo lo esencial para tomar una decisión rápida
// Botón + prominente para agregar al carrito con un solo toque
class SuggestionCard extends StatefulWidget {
  final String name;
  final double price;
  final double? originalPrice;
  final int? discount;
  final String? imagePath;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const SuggestionCard({
    super.key,
    required this.name,
    required this.price,
    this.originalPrice,
    this.discount,
    this.imagePath,
    this.onTap,
    this.onAddToCart,
  });

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
  bool _isPressed = false;
  bool _isAddingToCart = false;

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
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Container(
          width: 140,  // Más compacto que ProductCard (170px)
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow.withOpacity(0.12),
                offset: const Offset(0, 3),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Imagen del producto con badge de descuento superpuesto
              Stack(
                children: [
                  Container(
                    height: 95,  // Ajustado para evitar overflow
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
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
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholder(),
                            ),
                          )
                        : _buildPlaceholder(),
                  ),

                  // Badge de descuento en la esquina (si existe)
                  if (widget.discount != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          '-${widget.discount}%',
                          style: const TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Información del producto (compacta)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del producto (máximo 2 líneas)
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: AppColors.textBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Fila con precio y botón +
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Columna de precios
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Precio actual
                              Text(
                                'Bs. ${widget.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.primaryRed,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),

                              // Precio original (si existe)
                              if (widget.originalPrice != null &&
                                  widget.originalPrice! > widget.price)
                                Text(
                                  'Bs. ${widget.originalPrice!.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: AppColors.textLightGray,
                                    fontSize: 9,
                                    decoration: TextDecoration.lineThrough,
                                    height: 1.0,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Botón + para agregar al carrito
                        GestureDetector(
                          onTapDown: (_) => setState(() => _isAddingToCart = true),
                          onTapUp: (_) {
                            setState(() => _isAddingToCart = false);
                            widget.onAddToCart?.call();
                          },
                          onTapCancel: () => setState(() => _isAddingToCart = false),
                          child: AnimatedScale(
                            scale: _isAddingToCart ? 0.85 : 1.0,
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeOutBack,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primaryRed,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryRed.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: AppColors.backgroundWhite,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
        Icons.local_offer_outlined,
        color: AppColors.textLightGray,
        size: 40,
      ),
    );
  }
}

// Lista horizontal de sugerencias rápidas
// Optimizada para agregar productos al carrito con un solo toque
class SuggestionsList extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> suggestions;
  final Function(String)? onProductTap;
  final Function(String)? onAddToCart;

  const SuggestionsList({
    super.key,
    required this.title,
    required this.suggestions,
    this.onProductTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección con subtítulo
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Toca + para agregar rápidamente',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textBlack.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        // Lista horizontal de sugerencias
        SizedBox(
          height: 192,  // Altura calculada: 95px imagen + 80px info + margen extra
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(
              AppConstants.defaultPadding,
              8,
              AppConstants.defaultPadding,
              8,
            ),
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return SuggestionCard(
                name: suggestion['name'],
                price: suggestion['price'],
                originalPrice: suggestion['originalPrice'],
                discount: suggestion['discount'],
                imagePath: suggestion['image'],
                onTap: () => onProductTap?.call(suggestion['name']),
                onAddToCart: () => onAddToCart?.call(suggestion['name']),
              );
            },
          ),
        ),
      ],
    );
  }
}

