import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/page_transitions.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/search_bar.dart';
import '../widgets/promo_banner.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import '../widgets/bottom_navigation.dart';
import 'offers_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

/// Pantalla principal de la aplicación
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0;
  int _cartItemCount = 3; // Número de items en el carrito (empieza en 3 para demo)
  final TextEditingController _searchController = TextEditingController();

  // Función para agregar un producto al carrito
  // Incrementa el contador y muestra una confirmación al usuario
  void _addToCart(String productName) {
    setState(() {
      _cartItemCount++;
    });
    _showSnackBar('✓ $productName agregado al carrito');
  }

  // Función para quitar un producto del carrito (para pruebas)
  void _removeFromCart() {
    if (_cartItemCount > 0) {
      setState(() {
        _cartItemCount--;
      });
      _showSnackBar('Producto eliminado del carrito');
    }
  }

  // Datos de ejemplo para las categorías
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Lácteos',
      'icon': Icons.local_drink,
      'backgroundColor': AppColors.lightGray,
      'iconColor': AppColors.primaryRed,
    },
    {
      'name': 'Carnes',
      'icon': Icons.restaurant,
      'backgroundColor': AppColors.lightGray,
      'iconColor': AppColors.primaryRed,
    },
    {
      'name': 'Bebidas',
      'icon': Icons.local_bar,
      'backgroundColor': AppColors.lightGray,
      'iconColor': AppColors.primaryRed,
    },
    {
      'name': 'Frutas y Verduras',
      'icon': Icons.eco,
      'backgroundColor': AppColors.lightGray,
      'iconColor': AppColors.primaryRed,
    },
    {
      'name': 'Panadería',
      'icon': Icons.bakery_dining,
      'backgroundColor': AppColors.lightGray,
      'iconColor': AppColors.primaryRed,
    },
    {
      'name': 'Limpieza',
      'icon': Icons.cleaning_services,
      'backgroundColor': AppColors.lightGray,
      'iconColor': AppColors.primaryRed,
    },
  ];

  // Datos de ejemplo para el banner promocional
  final List<Map<String, dynamic>> _promoBanners = [
    {
      'title': 'CHOCOLATE BOMBOM SURTIDO GAROTO 250 GR',
      'currentPrice': 20.90,
      'originalPrice': 28.70,
      'discount': 27,
      'image': 'assets/images/garoto_chocolate.png',
    },
    {
      'title': 'OFERTA ESPECIAL - PRODUCTOS SELECCIONADOS',
      'currentPrice': 15.50,
      'originalPrice': 25.00,
      'discount': 38,
      'image': 'assets/images/oferta_especial.png',
    },
  ];

  // Datos de ejemplo para pedidos recientes
  final List<Map<String, dynamic>> _recentOrders = [
    {
      'name': 'CocaCola + Vaso',
      'price': 30.0,
      'originalPrice': 35.0,
      'discount': 10,
      'image': 'assets/images/coca_cola.png',
    },
    {
      'name': 'Pepsi 250ml',
      'price': 20.0,
      'originalPrice': 25.0,
      'discount': 20,
      'image': 'assets/images/pepsi.png',
    },
  ];

  // Datos de ejemplo para sugerencias
  final List<Map<String, dynamic>> _suggestions = [
    {
      'name': 'Pepsi 250ml',
      'price': 20.0,
      'originalPrice': 25.0,
      'discount': 20,
      'image': 'assets/images/pepsi.png',
    },
    {
      'name': 'Nescafé Clásico',
      'price': 45.0,
      'originalPrice': 50.0,
      'discount': 10,
      'image': 'assets/images/nescafe.png',
    },
    {
      'name': 'Leche Entera 1L',
      'price': 8.50,
      'originalPrice': 10.00,
      'discount': 15,
      'image': 'assets/images/leche.png',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomAppBar(
        cartItemCount: _cartItemCount,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de búsqueda
            CustomSearchBar(
              controller: _searchController,
              onChanged: (value) {
                // TODO: Implementar búsqueda de productos
                print('Buscando: $value');
              },
            ),

            // Banner promocional
            PromoBanner(
              banners: _promoBanners,
              onTap: () {
                // TODO: Implementar navegación al producto
                _showSnackBar('Banner promocional tocado');
              },
            ),

            // Categorías
            CategoriesList(
              categories: _categories,
              onCategoryTap: (categoryName) {
                _showSnackBar('Categoría seleccionada: $categoryName');
              },
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Pedidos recientes
            ProductsList(
              title: AppConstants.recentOrdersTitle,
              products: _recentOrders,
              showOrderAgainButton: true,
              onProductTap: (productName) {
                _showSnackBar('Producto seleccionado: $productName');
              },
              onOrderAgain: (productName) {
                // Usa el método para agregar al carrito
                _addToCart(productName);
              },
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Sugerencias
            ProductsList(
              title: AppConstants.suggestionsTitle,
              products: _suggestions,
              onProductTap: (productName) {
                // Cuando tocas un producto sugerido, también se agrega al carrito
                _addToCart(productName);
              },
            ),

            // Espacio adicional para la navegación inferior
            const SizedBox(height: AppConstants.bottomNavHeight + 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          _handleBottomNavTap(index);
        },
      ),
      // Botones flotantes para probar el contador del carrito
      // Elimínalos cuando ya no los necesites
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón para agregar items (prueba la animación de rebote)
          FloatingActionButton.small(
            heroTag: 'add',
            onPressed: () => _addToCart('Producto de prueba'),
            backgroundColor: AppColors.primaryRed,
            child: const Icon(Icons.add, color: AppColors.backgroundWhite),
          ),
          const SizedBox(height: 8),
          // Botón para quitar items
          FloatingActionButton.small(
            heroTag: 'remove',
            onPressed: _removeFromCart,
            backgroundColor: AppColors.textLightGray,
            child: const Icon(Icons.remove, color: AppColors.backgroundWhite),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    // Navegación a diferentes pantallas con transiciones personalizadas
    switch (index) {
      case 0:
        // Ya estamos en la pantalla de inicio, no hacer nada
        break;
      case 1:
        // Navegar a pantalla de ofertas con fade rápido
        Navigator.of(context).push(
          PageTransitions.fadeTransition(const OffersScreen()),
        );
        // Resetear el índice cuando volvamos
        setState(() => _currentBottomNavIndex = 0);
        break;
      case 2:
        // Navegar a pantalla de pedidos con fade rápido
        Navigator.of(context).push(
          PageTransitions.fadeTransition(const OrdersScreen()),
        );
        setState(() => _currentBottomNavIndex = 0);
        break;
      case 3:
        // Navegar a pantalla de perfil con fade rápido
        Navigator.of(context).push(
          PageTransitions.fadeTransition(const ProfileScreen()),
        );
        setState(() => _currentBottomNavIndex = 0);
        break;
    }
  }

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
