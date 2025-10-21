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
  final int index;  // Para animación escalonada

  const CategoryCard({
    super.key,
    required this.name,
    this.icon,
    this.imagePath,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.index = 0,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Animación de entrada: aparece con efecto suave
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Escala desde 0.8 hasta 1.0
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,  // Efecto de rebote suave
    ));

    // Fade desde 0 hasta 1
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Inicia la animación con un delay escalonado según el índice
    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap?.call();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            // Efecto sutil al tocar, estilo minimalista
            scale: _isPressed ? 0.92 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutBack,
            child: Container(
          width: AppConstants.categoryCardSize,
          height: AppConstants.categoryCardSize,
          margin: const EdgeInsets.only(right: 12),  // Espaciado más generoso
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.lightGray,
            borderRadius: BorderRadius.circular(16),  // Bordes más redondeados
            // Sombra sutil estilo minimalista
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow.withOpacity(0.06),  // Más sutil
                offset: const Offset(0, 2),
                blurRadius: 10,  // Más difuminado
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Contenedor del ícono o imagen más grande y atractivo
              Container(
                width: 68,  // Ligeramente más grande
                height: 68,
                padding: const EdgeInsets.all(14),  // Más espacioso
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(18),  // Más redondeado
                  // Sombra muy suave para separar del fondo
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow.withOpacity(0.08),  // Más sutil
                      offset: const Offset(0, 1),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: _buildCategoryIcon(),
              ),
              
              const SizedBox(height: 8),
              
              // Nombre de la categoría
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    height: 1.2,  // Mejor altura de línea
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
        ),
      ),
    );
  }

  // Muestra imagen PNG si existe, si no usa el ícono de Material
  // Las imágenes son grandes y se ven perfectas en pantallas modernas
  Widget _buildCategoryIcon() {
    if (widget.imagePath != null) {
      return Image.asset(
        widget.imagePath!,
        width: 40,  // Tamaño óptimo para pantallas modernas
        height: 40,
        fit: BoxFit.contain,
        // Si la imagen falla, muestra el ícono como respaldo
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            widget.icon ?? Icons.category_rounded,
            color: widget.iconColor ?? AppColors.primaryRed,
            size: 40,
          );
        },
      );
    }
    
    // Si no hay imagen, usa el ícono
    return Icon(
      widget.icon ?? Icons.category_rounded,
      color: widget.iconColor ?? AppColors.primaryRed,
      size: 40,
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
                index: index,  // Para animación escalonada
                onTap: () => onCategoryTap?.call(category['name']),
              );
            },
          ),
        ),
      ],
    );
  }
}
