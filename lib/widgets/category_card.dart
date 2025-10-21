import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Tarjeta de categoría con diseño minimalista y animaciones sutiles
// Soporta tanto imágenes PNG personalizadas como íconos de Material
class CategoryCard extends StatefulWidget {
  final String name;
  final IconData? icon;
  final String? imagePath;  // Ruta a imagen PNG sin fondo
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const CategoryCard({
    super.key,
    required this.name,
    this.icon,
    this.imagePath,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
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
        // Efecto sutil al tocar, estilo minimalista
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          width: AppConstants.categoryCardSize,
          height: AppConstants.categoryCardSize,
          margin: const EdgeInsets.only(right: AppConstants.smallPadding),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.lightGray,
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            // Sombra sutil estilo minimalista
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow.withOpacity(0.08),
                offset: const Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Contenedor del ícono o imagen
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                  // Sombra muy suave para separar del fondo
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow.withOpacity(0.06),
                      offset: const Offset(0, 1),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: _buildCategoryIcon(),
              ),
              
              const SizedBox(height: 8),
              
              // Nombre de la categoría
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Muestra imagen PNG si existe, si no usa el ícono de Material
  Widget _buildCategoryIcon() {
    if (widget.imagePath != null) {
      return Image.asset(
        widget.imagePath!,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
        // Si la imagen falla, muestra el ícono como respaldo
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            widget.icon ?? Icons.category_rounded,
            color: widget.iconColor ?? AppColors.primaryRed,
            size: 28,
          );
        },
      );
    }
    
    // Si no hay imagen, usa el ícono
    return Icon(
      widget.icon ?? Icons.category_rounded,
      color: widget.iconColor ?? AppColors.primaryRed,
      size: 28,
    );
  }
}

// Lista horizontal de categorías que se puede deslizar
// Muestra el título y las tarjetas en scroll horizontal
class CategoriesList extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final Function(String)? onCategoryTap;

  const CategoriesList({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección "Categorías"
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
          child: Text(
            AppConstants.categoriesTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
              letterSpacing: 0.3,
            ),
          ),
        ),
        
        // Lista que se desliza horizontalmente con las categorías
        SizedBox(
          height: AppConstants.categoryCardSize + 20,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            // Para scroll suave en dispositivos
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(
                name: category['name'],
                icon: category['icon'],
                imagePath: category['imagePath'],  // Soporte para imágenes PNG
                backgroundColor: category['backgroundColor'],
                iconColor: category['iconColor'],
                onTap: () => onCategoryTap?.call(category['name']),
              );
            },
          ),
        ),
      ],
    );
  }
}
