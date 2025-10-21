import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

/// Tarjeta de producto para mostrar información de productos
class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final double? originalPrice;
  final int? discount;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onOrderAgain;
  final bool showOrderAgainButton;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    this.originalPrice,
    this.discount,
    this.imageUrl,
    this.onTap,
    this.onOrderAgain,
    this.showOrderAgainButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: showOrderAgainButton ? 220 : 180,
        margin: const EdgeInsets.only(right: AppConstants.smallPadding),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              offset: const Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.defaultRadius),
                  topRight: Radius.circular(AppConstants.defaultRadius),
                ),
              ),
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.defaultRadius),
                        topRight: Radius.circular(AppConstants.defaultRadius),
                      ),
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                      ),
                    )
                  : _buildPlaceholder(),
            ),
            
            // Información del producto
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del producto
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.textBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Precio
                    Text(
                      'Bs. ${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.primaryRed,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // Precio original y descuento
                    if (originalPrice != null && originalPrice! > price)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Bs. ${originalPrice!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.textLightGray,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (discount != null) ...[
                            const SizedBox(width: 4),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accentYellow,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${discount}% ${AppConstants.discountText}',
                                  style: const TextStyle(
                                    color: AppColors.textBlack,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    
                    const Spacer(),
                    
                    // Botón de "Volver a Pedir"
                    if (showOrderAgainButton)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onOrderAgain,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: AppColors.backgroundWhite,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            AppConstants.orderAgainText,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(
        Icons.image,
        color: AppColors.textLightGray,
        size: 40,
      ),
    );
  }
}

/// Lista horizontal de productos
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
            ),
          ),
        ),
        
        // Lista horizontal de productos
        SizedBox(
          height: showOrderAgainButton ? 240 : 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                name: product['name'],
                price: product['price'],
                originalPrice: product['originalPrice'],
                discount: product['discount'],
                imageUrl: product['image'],
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
