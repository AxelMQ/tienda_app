import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Banner promocional que se desliza automáticamente mostrando las mejores ofertas
// El carrusel avanza solo cada 4 segundos, pero se detiene si el usuario lo toca
class PromoBanner extends StatefulWidget {
  final List<Map<String, dynamic>> banners;
  final double height;
  final VoidCallback? onTap;

  const PromoBanner({
    super.key,
    required this.banners,
    this.height = AppConstants.bannerHeight,
    this.onTap,
  });

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Iniciamos el carrusel automático si hay más de un banner
    if (widget.banners.length > 1) {
      _startAutoScroll();
    }
  }

  @override
  void didUpdateWidget(PromoBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambió la cantidad de banners, reiniciamos el auto-scroll
    if (widget.banners.length != oldWidget.banners.length) {
      _stopAutoScroll();
      if (widget.banners.length > 1) {
        _startAutoScroll();
      }
    }
  }

  @override
  void dispose() {
    // Importante: limpiamos el timer para no tener fugas de memoria
    _stopAutoScroll();
    _pageController.dispose();
    super.dispose();
  }

  // Inicia el carrusel automático que avanza cada 4 segundos
  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentIndex + 1) % widget.banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Detiene el carrusel automático cuando el usuario interactúa
  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  // Reinicia el timer después de que el usuario deje de interactuar
  void _resetAutoScroll() {
    _stopAutoScroll();
    if (widget.banners.length > 1) {
      _startAutoScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      // Cuando el usuario empieza a arrastrar, pausamos el auto-scroll
      onPanStart: (_) => _stopAutoScroll(),
      // Cuando termina de arrastrar, reiniciamos el auto-scroll después de 3 segundos
      onPanEnd: (_) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) _resetAutoScroll();
        });
      },
      child: Container(
        height: widget.height,
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.smallPadding,
        ),
        child: Stack(
          children: [
            // Carrusel que puedes deslizar con el dedo
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.banners.length,
              itemBuilder: (context, index) {
                final banner = widget.banners[index];
                return _buildBannerCard(banner);
              },
            ),
            
            // Puntitos que indican en qué página estás
            if (widget.banners.length > 1)
              Positioned(
                bottom: AppConstants.smallPadding,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.banners.length,
                    (index) => _buildPageIndicator(index),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCard(Map<String, dynamic> banner) {
    return _BannerCard(
      banner: banner,
      onTap: widget.onTap,
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = _currentIndex == index;
    return AnimatedContainer(
      // Los indicadores se animan suavemente al cambiar de página
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive 
            ? AppColors.backgroundWhite 
            : AppColors.backgroundWhite.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// Card individual del banner con efecto al tocar
class _BannerCard extends StatefulWidget {
  final Map<String, dynamic> banner;
  final VoidCallback? onTap;

  const _BannerCard({
    required this.banner,
    this.onTap,
  });

  @override
  State<_BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<_BannerCard> {
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
        // El banner se encoge ligeramente cuando lo tocas
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                offset: const Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            child: Stack(
              children: [
                // Imagen del producto en oferta
                if (widget.banner['image'] != null)
                  Image.asset(
                    widget.banner['image'],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    // Si la imagen no carga, mostramos un fondo con gradiente
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryRed,
                              AppColors.secondaryRed,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image_rounded,
                            color: AppColors.backgroundWhite,
                            size: 60,
                          ),
                        ),
                      );
                    },
                  )
                else
                  // Si no hay imagen, mostramos el gradiente por defecto
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryRed,
                          AppColors.secondaryRed,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_rounded,
                        color: AppColors.backgroundWhite,
                        size: 60,
                      ),
                    ),
                  ),
                
                // Capa oscura degradada para que el texto siempre se vea bien
                // Sin importar si la imagen es clara u oscura
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.9),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Nombre del producto en oferta con sombra para mejor legibilidad
                        Text(
                          widget.banner['title'] ?? 'Producto en Oferta',
                          style: const TextStyle(
                            color: AppColors.backgroundWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        
                        // Precio actual con descuento (color amarillo que se ve en cualquier fondo)
                        Text(
                          'Bs. ${widget.banner['currentPrice']?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                            color: AppColors.accentYellow,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        
                        // Precio anterior tachado para mostrar cuánto ahorras
                        if (widget.banner['originalPrice'] != null)
                          Text(
                            'ANTES: ${widget.banner['originalPrice']?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(
                              color: AppColors.backgroundWhite,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                ),
                              ],
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
      ),
    );
  }
}
