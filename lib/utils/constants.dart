/// Constantes de la aplicación Tienda App
class AppConstants {
  // Información de la aplicación
  static const String appName = 'La Canasta';
  static const String appDescription = 'Tu supermercado digital';
  static const String appVersion = '1.0.0';
  
  // Dimensiones y espaciado
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  // Tamaños de widgets
  static const double headerHeight = 80.0;
  static const double bottomNavHeight = 80.0;
  static const double searchBarHeight = 50.0;
  static const double categoryCardSize = 105.0;  // Aumentado para mejor visibilidad
  static const double productCardHeight = 200.0;
  static const double bannerHeight = 200.0;
  
  // Border radius
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;
  
  // Elevación y sombras
  static const double defaultElevation = 2.0;
  static const double cardElevation = 4.0;
  static const double buttonElevation = 6.0;
  
  // Animaciones
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
  
  // Textos de la aplicación
  static const String searchHint = 'Buscar Producto';
  static const String categoriesTitle = 'Categorías';
  static const String recentOrdersTitle = 'Tus pedidos recientes';
  static const String suggestionsTitle = 'Sugerencias para ti';
  static const String orderAgainText = 'Volver a Pedir';
  static const String discountText = 'OFF';
  
  // Iconos
  static const String menuIcon = 'menu';
  static const String searchIcon = 'search';
  static const String cartIcon = 'shopping_cart';
  static const String homeIcon = 'home';
  static const String offersIcon = 'local_offer';
  static const String ordersIcon = 'receipt';
  static const String profileIcon = 'person';
  
  // Categorías principales
  static const List<String> mainCategories = [
    'Lácteos',
    'Carnes',
    'Bebidas',
    'Frutas y Verduras',
    'Panadería',
    'Limpieza',
    'Cuidado Personal',
    'Bebé',
  ];
  
  // Productos de ejemplo
  static const List<Map<String, dynamic>> sampleProducts = [
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
    {
      'name': 'Nescafé Clásico',
      'price': 45.0,
      'originalPrice': 50.0,
      'discount': 10,
      'image': 'assets/images/nescafe.png',
    },
  ];
  
  // Banner promocional
  static const Map<String, dynamic> promoBanner = {
    'title': 'CHOCOLATE BOMBOM SURTIDO GAROTO 250 GR',
    'currentPrice': 20.90,
    'originalPrice': 28.70,
    'discount': 27,
    'image': 'assets/images/garoto_chocolate.png',
  };
}
