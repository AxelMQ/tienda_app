import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/page_transitions.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/promo_banner.dart';
import '../widgets/offer_banner_card.dart';
import '../widgets/suggestion_card.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

// Pantalla de ofertas especiales y promociones
// Muestra todas las ofertas activas organizadas por categorías
// Diseñada para que el usuario encuentre rápidamente los mejores descuentos
class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  int _currentIndex = 1; // Ofertas es el índice 1 en el bottom navigation
  int _cartItemCount = 3; // Contador de items en el carrito
  late Timer _countdownTimer; // Timer para el contador regresivo
  Duration _timeRemaining = const Duration(hours: 2, minutes: 30); // Tiempo inicial

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  // Inicia el contador regresivo para ofertas flash
  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeRemaining.inSeconds > 0) {
            _timeRemaining = Duration(seconds: _timeRemaining.inSeconds - 1);
          } else {
            // Cuando llega a 0, reinicia (en producción sería recarga de ofertas)
            _timeRemaining = const Duration(hours: 2, minutes: 30);
          }
        });
      }
    });
  }

  // Formatea el tiempo restante como "2h 30m"
  String _formatTimeRemaining() {
    final hours = _timeRemaining.inHours;
    final minutes = _timeRemaining.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      final seconds = _timeRemaining.inSeconds.remainder(60);
      return '${minutes}m ${seconds}s';
    }
  }

  // Función para agregar productos al carrito desde ofertas
  void _addToCart(String productName) {
    setState(() {
      _cartItemCount++;
    });
    _showSnackBar('✓ $productName agregado al carrito');
  }

  // Función para refrescar las ofertas (Pull-to-Refresh)
  Future<void> _refreshOffers() async {
    // Simula carga de nuevas ofertas (en producción sería una llamada API)
    await Future.delayed(const Duration(seconds: 1));
    _showSnackBar('✓ Ofertas actualizadas');
  }

  // Banners de ofertas destacadas del día
  final List<Map<String, dynamic>> _featuredOffers = [
    {
      'title': 'CHOCOLATE SURTIDO GAROTO 250 GR',
      'currentPrice': 20.90,
      'originalPrice': 28.70,
      'discount': 27,
      'image': 'assets/images/garoto.jpg',
    },
    {
      'title': 'COMBO ESPECIAL - AHORRA MÁS',
      'currentPrice': 15.50,
      'originalPrice': 25.00,
      'discount': 38,
      'image': 'assets/images/pic_chocolates.jpg',
    },
  ];

  // Categorías de ofertas con sus respectivos carruseles
  final List<Map<String, dynamic>> _offerCategories = [
    {
      'category': 'Combos',
      'offers': [
        {
          'title': '2x1 en Chocolates',
          'discount': 50,
          'image': 'assets/images/pic_chocolates.jpg',
        },
        {
          'title': 'Combo Bebidas',
          'discount': 30,
          'image': 'assets/images/pepsi_3L.webp',
        },
      ],
    },
    {
      'category': 'Envíos Gratis',
      'offers': [
        {
          'title': 'Compras +Bs.50',
          'discount': null,
          'image': 'assets/images/garoto.jpg',
        },
        {
          'title': 'Zona Centro',
          'discount': null,
          'image': 'assets/images/nescafe_clasico.webp',
        },
      ],
    },
    {
      'category': 'Nuevos',
      'offers': [
        {
          'title': 'Nescafé Clásico',
          'discount': 20,
          'image': 'assets/images/nescafe_clasico.webp',
        },
        {
          'title': 'Garoto 250gr',
          'discount': 27,
          'image': 'assets/images/garoto.jpg',
        },
      ],
    },
    {
      'category': 'Especiales',
      'offers': [
        {
          'title': 'Pepsi 3L',
          'discount': 28,
          'image': 'assets/images/pepsi_3L.webp',
        },
        {
          'title': 'Mix Chocolates',
          'discount': 33,
          'image': 'assets/images/pic_chocolates.jpg',
        },
      ],
    },
  ];

  // Ofertas flash - descuentos por tiempo limitado
  final List<Map<String, dynamic>> _flashOffers = [
    {
      'name': 'Chocolate Mix',
      'price': 12.0,
      'originalPrice': 18.00,
      'discount': 33,
      'image': 'assets/images/pic_chocolates.jpg',
    },
    {
      'name': 'Garoto 250gr',
      'price': 20.90,
      'originalPrice': 28.70,
      'discount': 27,
      'image': 'assets/images/garoto.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomAppBar(
        cartItemCount: _cartItemCount,
      ),
      // Pull-to-Refresh para actualizar ofertas
      body: RefreshIndicator(
        onRefresh: _refreshOffers,
        color: AppColors.primaryRed,
        backgroundColor: AppColors.backgroundWhite,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Permite pull siempre
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de la sección de ofertas
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.defaultPadding,
                AppConstants.defaultPadding,
                AppConstants.defaultPadding,
                AppConstants.smallPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título principal
                  const Text(
                    '🔥 Ofertas Especiales',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtítulo
                  Text(
                    'Los mejores descuentos para ti',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textBlack.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Carousel de ofertas flash (horizontal)
            PromoBanner(
              banners: _featuredOffers,
              onTap: () {
                _showSnackBar('¡Oferta destacada!');
              },
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Título para grid de banners
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: Text(
                '🎯 Más Ofertas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            // Grid 2x2 con carruseles manuales en cada card
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              child: GridView.builder(
                shrinkWrap: true, // Permite que el grid se ajuste al contenido
                physics: const NeverScrollableScrollPhysics(), // El scroll lo maneja el padre
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columnas
                  crossAxisSpacing: 12, // Espacio horizontal entre cards
                  mainAxisSpacing: 12, // Espacio vertical entre cards
                  childAspectRatio: 0.70, // Cards más altas para mayor impacto visual
                ),
                itemCount: _offerCategories.length,
                itemBuilder: (context, index) {
                  final category = _offerCategories[index];
                  return OfferBannerCard(
                    categoryTitle: category['category'],
                    offers: List<Map<String, dynamic>>.from(category['offers']),
                    onOfferTap: (offerTitle) => _showSnackBar('Oferta: $offerTitle'),
                    index: index, // Para animación escalonada
                  );
                },
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Sección: Ofertas Flash con contador regresivo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título con contador regresivo
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                    vertical: AppConstants.smallPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Título
                      const Text(
                        '⚡ Ofertas Flash',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                          letterSpacing: 0.3,
                        ),
                      ),
                      // Contador regresivo
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryRed.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              color: AppColors.backgroundWhite,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTimeRemaining(),
                              style: const TextStyle(
                                color: AppColors.backgroundWhite,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Subtítulo
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppConstants.defaultPadding,
                    right: AppConstants.defaultPadding,
                    bottom: AppConstants.smallPadding,
                  ),
                  child: Text(
                    'Toca + para agregar rápidamente',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textBlack.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                // Lista de productos
                SizedBox(
                  height: 192,
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
                    itemCount: _flashOffers.length,
                    itemBuilder: (context, index) {
                      final suggestion = _flashOffers[index];
                      return SuggestionCard(
                        name: suggestion['name'],
                        price: suggestion['price'],
                        originalPrice: suggestion['originalPrice'],
                        discount: suggestion['discount'],
                        imagePath: suggestion['image'],
                        onTap: () => _showSnackBar('Producto: ${suggestion['name']}'),
                        onAddToCart: () => _addToCart(suggestion['name']),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Espacio para el bottom navigation
            const SizedBox(height: AppConstants.bottomNavHeight + 20),
          ],
        ),
          ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) return; // Ya estamos en Ofertas
          
          setState(() => _currentIndex = index);
          
          // Navegación con transición de fade rápida para mejor UX
          switch (index) {
            case 0:
              Navigator.of(context).pop(); // Volver a Home
              break;
            case 2:
              Navigator.of(context).pushReplacement(
                PageTransitions.fadeTransition(const OrdersScreen()),
              );
              break;
            case 3:
              Navigator.of(context).pushReplacement(
                PageTransitions.fadeTransition(const ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }

  // Muestra mensajes de confirmación al usuario
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        ),
      ),
    );
  }
}

