import 'package:flutter/material.dart';
import '../utils/colors.dart';

// Tarjeta de oferta con carousel manual integrado
// Diseño para mostrar múltiples ofertas en un mismo espacio
// El usuario desliza manualmente para ver más contenido
class OfferBannerCard extends StatefulWidget {
  final String categoryTitle; // Título de la categoría (ej: "Combos")
  final List<Map<String, dynamic>> offers; // Lista de ofertas en este carousel
  final Function(String)? onOfferTap;
  final int index; // Índice para animación escalonada

  const OfferBannerCard({
    super.key,
    required this.categoryTitle,
    required this.offers,
    this.onOfferTap,
    this.index = 0,
  });

  @override
  State<OfferBannerCard> createState() => _OfferBannerCardState();
}

class _OfferBannerCardState extends State<OfferBannerCard>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Controlador para animación de entrada
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Animación de opacidad (fade in)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    ));

    // Animación de escala (zoom in sutil)
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutBack,
    ));

    // Inicia animación con delay escalonado según el índice
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _entryController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si no hay ofertas, mostramos un placeholder
    if (widget.offers.isEmpty) {
      return _buildEmptyCard();
    }

    // Envolvemos en animaciones de entrada
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Carousel de imágenes (controlado manualmente por el usuario)
          Expanded(
            child: Stack(
              children: [
                // PageView para las ofertas
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: widget.offers.length,
                  itemBuilder: (context, index) {
                    return _buildOfferPage(widget.offers[index], index);
                  },
                ),

                // Indicadores de página (puntos)
                if (widget.offers.length > 1)
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: _buildPageIndicators(),
                  ),
              ],
            ),
          ),

          // Título de la categoría (footer fijo)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(
              widget.categoryTitle,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }

  // Construye cada página del carousel
  Widget _buildOfferPage(Map<String, dynamic> offer, int index) {
    return GestureDetector(
      onTap: () {
        widget.onOfferTap?.call(offer['title'] ?? widget.categoryTitle);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo con shimmer loading
            offer['image'] != null
                ? Image.asset(
                    offer['image'],
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      // Si la imagen ya está en caché, muestra directamente
                      if (wasSynchronouslyLoaded) return child;
                      
                      // Muestra shimmer mientras carga
                      return frame != null
                          ? child
                          : const _ShimmerPlaceholder();
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(),
                  )
                : _buildPlaceholder(),

            // Overlay con información de la oferta
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de la oferta
                  if (offer['title'] != null)
                    Text(
                      offer['title'],
                      style: const TextStyle(
                        color: AppColors.backgroundWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // Descuento con animación de pulso (si existe)
                  if (offer['discount'] != null) ...[
                    const SizedBox(height: 4),
                    _PulsingBadge(discount: offer['discount']),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Indicadores de página (puntos)
  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.offers.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: _currentPage == index ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.backgroundWhite
                : AppColors.backgroundWhite.withOpacity(0.4),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Placeholder cuando no hay imagen
  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.lightGray.withOpacity(0.3),
      child: Center(
        child: Icon(
          Icons.local_offer_rounded,
          size: 48,
          color: AppColors.textLightGray.withOpacity(0.5),
        ),
      ),
    );
  }

  // Card vacía cuando no hay ofertas
  Widget _buildEmptyCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          widget.categoryTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

// Badge de descuento con animación de pulso sutil
// Llama la atención sin ser molesto
class _PulsingBadge extends StatefulWidget {
  final int discount;

  const _PulsingBadge({required this.discount});

  @override
  State<_PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<_PulsingBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador para animación de pulso
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Animación de escala que va y vuelve
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08, // Crece 8% sutilmente
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Repite la animación indefinidamente
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withOpacity(0.4),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          '${widget.discount}% OFF',
          style: const TextStyle(
            color: AppColors.backgroundWhite,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Placeholder con efecto shimmer mientras cargan las imágenes
// Mejora la percepción de velocidad de carga
class _ShimmerPlaceholder extends StatefulWidget {
  const _ShimmerPlaceholder();

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.lightGray.withOpacity(0.3),
                AppColors.lightGray.withOpacity(0.1),
                AppColors.lightGray.withOpacity(0.3),
              ],
              stops: [
                _shimmerController.value - 0.3,
                _shimmerController.value,
                _shimmerController.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}

