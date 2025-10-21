import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/page_transitions.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/search_bar.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

// Pantalla de catálogo de productos con filtros y búsqueda
// Permite explorar productos por categoría, precio y disponibilidad
// Diseño en grid de 2 columnas para aprovechar el espacio
class CatalogScreen extends StatefulWidget {
  final String? initialCategory; // Categoría pre-seleccionada al abrir
  final String? searchQuery; // Término de búsqueda inicial

  const CatalogScreen({
    super.key,
    this.initialCategory,
    this.searchQuery,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _animationController;

  int _cartItemCount = 3; // Contador de items en el carrito
  String? _selectedCategory; // Categoría actualmente filtrada
  String _priceFilter = 'Todos'; // Filtro de precio actual
  bool _onlyAvailable = false; // Mostrar solo productos disponibles

  // Lista de todas las categorías disponibles con íconos
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Lácteos', 'icon': Icons.water_drop_rounded},
    {'name': 'Carnes', 'icon': Icons.fastfood_rounded},
    {'name': 'Bebidas', 'icon': Icons.local_drink_rounded},
    {'name': 'Panadería', 'icon': Icons.bakery_dining_rounded},
    {'name': 'Frutas', 'icon': Icons.apple_rounded},
    {'name': 'Verduras', 'icon': Icons.eco_rounded},
  ];

  // Opciones de filtro de precio
  final List<String> _priceOptions = [
    'Todos',
    'Menor a Bs. 20',
    'Bs. 20 - Bs. 50',
    'Mayor a Bs. 50',
  ];

  // Datos de productos de ejemplo con imágenes reales
  // En producción vendría de una API o base de datos
  final List<Map<String, dynamic>> _allProducts = [
    // Lácteos
    {
      'name': 'Leche Pil Light 1L',
      'price': 8.50,
      'originalPrice': 10.0,
      'discount': 15,
      'image': 'assets/images/leche_ligth.jpg',
      'category': 'Lácteos',
      'available': true,
    },
    {
      'name': 'Leche PIL Caja 1L',
      'price': 7.90,
      'originalPrice': 9.50,
      'discount': 17,
      'image': 'assets/images/leche_caja.jpg',
      'category': 'Lácteos',
      'available': true,
    },
    {
      'name': 'Leche Frutilla PIL',
      'price': 6.50,
      'originalPrice': 8.0,
      'discount': 19,
      'image': 'assets/images/leche_frutilla.jpeg',
      'category': 'Lácteos',
      'available': true,
    },
    
    // Carnes
    {
      'name': 'Carne de Res 1kg',
      'price': 45.0,
      'originalPrice': 52.0,
      'discount': 13,
      'image': 'assets/images/carne_res.jpg',
      'category': 'Carnes',
      'available': true,
    },
    {
      'name': 'Carne de Vacuno 1kg',
      'price': 48.0,
      'originalPrice': 55.0,
      'discount': 13,
      'image': 'assets/images/carne_vacuno.jpeg',
      'category': 'Carnes',
      'available': true,
    },
    
    // Bebidas
    {
      'name': 'CocaCola Vaso',
      'price': 3.50,
      'originalPrice': 4.0,
      'discount': 13,
      'image': 'assets/images/cocacola_vaso.jpg',
      'category': 'Bebidas',
      'available': true,
    },
    {
      'name': 'Pepsi 1L',
      'price': 8.0,
      'originalPrice': 10.0,
      'discount': 20,
      'image': 'assets/images/pepsi_1L.webp',
      'category': 'Bebidas',
      'available': true,
    },
    {
      'name': 'Pepsi 3L',
      'price': 16.0,
      'originalPrice': 20.0,
      'discount': 20,
      'image': 'assets/images/pepsi_3L.webp',
      'category': 'Bebidas',
      'available': false,
    },
    {
      'name': 'Maltin Power',
      'price': 5.0,
      'originalPrice': 6.0,
      'discount': 17,
      'image': 'assets/images/bebida_maltin.webp',
      'category': 'Bebidas',
      'available': true,
    },
    {
      'name': 'Rush Energy Drink',
      'price': 7.50,
      'originalPrice': 9.0,
      'discount': 17,
      'image': 'assets/images/bebida_rush_energy.webp',
      'category': 'Bebidas',
      'available': true,
    },
    
    // Panadería
    {
      'name': 'Pan Francés x6',
      'price': 4.50,
      'originalPrice': 5.50,
      'discount': 18,
      'image': 'assets/images/pan_frances.jpeg',
      'category': 'Panadería',
      'available': true,
    },
    {
      'name': 'Pan de Molde',
      'price': 12.0,
      'originalPrice': 14.0,
      'discount': 14,
      'image': 'assets/images/pan_molde.jpeg',
      'category': 'Panadería',
      'available': true,
    },
    {
      'name': 'Pan de Harina',
      'price': 8.50,
      'originalPrice': 10.0,
      'discount': 15,
      'image': 'assets/images/pan_harina.jpg',
      'category': 'Panadería',
      'available': true,
    },
    {
      'name': 'Pan Integral',
      'price': 9.0,
      'originalPrice': 11.0,
      'discount': 18,
      'image': 'assets/images/pan.jpeg',
      'category': 'Panadería',
      'available': false,
    },
    
    // Frutas
    {
      'name': 'Naranjas 1kg',
      'price': 12.0,
      'originalPrice': 15.0,
      'discount': 20,
      'image': 'assets/images/fruta_naranja.jpeg',
      'category': 'Frutas',
      'available': true,
    },
    {
      'name': 'Palta 1kg',
      'price': 18.0,
      'originalPrice': 22.0,
      'discount': 18,
      'image': 'assets/images/fruta_palta.jpeg',
      'category': 'Frutas',
      'available': true,
    },
    {
      'name': 'Kiwi 500g',
      'price': 14.0,
      'originalPrice': 17.0,
      'discount': 18,
      'image': 'assets/images/futa_kiwi.jpg',
      'category': 'Frutas',
      'available': true,
    },
    
    // Verduras (datos de ejemplo si no tienes imágenes)
    {
      'name': 'Chocolate Garoto',
      'price': 6.50,
      'originalPrice': 8.0,
      'discount': 19,
      'image': 'assets/images/garoto_chocolate.webp',
      'category': 'Verduras',
      'available': true,
    },
    {
      'name': 'Nescafé Clásico',
      'price': 22.0,
      'originalPrice': 26.0,
      'discount': 15,
      'image': 'assets/images/nescafe_clasico.webp',
      'category': 'Verduras',
      'available': true,
    },
    {
      'name': 'Nescafé Forte',
      'price': 24.0,
      'originalPrice': 28.0,
      'discount': 14,
      'image': 'assets/images/nescafe_forte.jpeg',
      'category': 'Verduras',
      'available': true,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador de búsqueda con query inicial si existe
    _searchController = TextEditingController(text: widget.searchQuery ?? '');

    // Establece la categoría inicial si fue proporcionada
    _selectedCategory = widget.initialCategory;

    // Inicializa el controlador de animaciones para efectos de entrada
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Inicia las animaciones al cargar la pantalla
    _animationController.forward();
  }

  @override
  void dispose() {
    // Limpia los controladores para liberar recursos
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Filtra los productos según los criterios seleccionados
  // Aplica filtros de categoría, precio, disponibilidad y búsqueda
  List<Map<String, dynamic>> _getFilteredProducts() {
    return _allProducts.where((product) {
      // Filtro de categoría
      if (_selectedCategory != null && product['category'] != _selectedCategory) {
        return false;
      }

      // Filtro de disponibilidad
      if (_onlyAvailable && !product['available']) {
        return false;
      }

      // Filtro de precio
      final price = product['price'] as double;
      switch (_priceFilter) {
        case 'Menor a Bs. 20':
          if (price >= 20) return false;
          break;
        case 'Bs. 20 - Bs. 50':
          if (price < 20 || price > 50) return false;
          break;
        case 'Mayor a Bs. 50':
          if (price <= 50) return false;
          break;
      }

      // Filtro de búsqueda por nombre
      final searchQuery = _searchController.text.toLowerCase();
      if (searchQuery.isNotEmpty) {
        final productName = product['name'].toString().toLowerCase();
        if (!productName.contains(searchQuery)) return false;
      }

      return true;
    }).toList();
  }

  // Cuenta cuántos productos hay por categoría
  // Usado para mostrar el número en los chips de categoría
  int _getProductCountByCategory(String category) {
    return _allProducts.where((p) => p['category'] == category).length;
  }

  // Verifica si hay filtros activos para mostrar el botón de limpiar
  bool _hasActiveFilters() {
    return _selectedCategory != null ||
        _priceFilter != 'Todos' ||
        _onlyAvailable ||
        _searchController.text.isNotEmpty;
  }

  // Limpia todos los filtros activos
  void _clearAllFilters() {
    setState(() {
      _selectedCategory = null;
      _priceFilter = 'Todos';
      _onlyAvailable = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomAppBar(
        cartItemCount: _cartItemCount,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: CustomSearchBar(
              controller: _searchController,
              onChanged: (value) {
                // Actualiza los resultados al escribir
                setState(() {});
              },
            ),
          ),

          // Filtros de categoría (scroll horizontal)
          _AnimatedItem(
            controller: _animationController,
            delay: 0,
            child: _buildCategoryFilters(),
          ),

          const SizedBox(height: 12),

          // Filtros de precio y disponibilidad
          _AnimatedItem(
            controller: _animationController,
            delay: 100,
            child: _buildPriceAndAvailabilityFilters(),
          ),

          const SizedBox(height: 12),

          // Badge mostrando cantidad de resultados
          _AnimatedItem(
            controller: _animationController,
            delay: 200,
            child: _buildResultsBadge(filteredProducts.length),
          ),

          const SizedBox(height: 12),

          // Grid de productos
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState()
                : _buildProductGrid(filteredProducts),
          ),
        ],
      ),
    );
  }

  // Construye los chips de filtro de categorías con íconos y contadores
  // Diseño profesional con feedback visual claro
  Widget _buildCategoryFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: _categories.length + (_hasActiveFilters() ? 1 : 0),
            itemBuilder: (context, index) {
              // Botón "Limpiar filtros" aparece al inicio si hay filtros activos
              if (_hasActiveFilters() && index == 0) {
                return _buildClearFiltersButton();
              }

              // Ajusta el índice si hay botón de limpiar
              final categoryIndex = _hasActiveFilters() ? index - 1 : index;
              final category = _categories[categoryIndex];
              final categoryName = category['name'] as String;
              final categoryIcon = category['icon'] as IconData;
              final isSelected = _selectedCategory == categoryName;
              final productCount = _getProductCountByCategory(categoryName);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _CategoryChip(
                  label: categoryName,
                  icon: categoryIcon,
                  count: productCount,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedCategory = isSelected ? null : categoryName;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Botón para limpiar todos los filtros activos
  // Solo aparece cuando hay al menos un filtro aplicado
  Widget _buildClearFiltersButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: _clearAllFilters,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.accentYellow,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentYellow.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.clear_all_rounded,
                size: 18,
                color: AppColors.textBlack,
              ),
              SizedBox(width: 6),
              Text(
                'Limpiar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Construye los filtros de precio y disponibilidad con mejor diseño
  Widget _buildPriceAndAvailabilityFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
          ),
          child: Row(
            children: [
              // Filtro de precio (dropdown) con badge si está activo
              Expanded(
                child: GestureDetector(
                  onTap: _showPriceFilterModal,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _priceFilter != 'Todos'
                          ? AppColors.primaryRed.withOpacity(0.1)
                          : AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _priceFilter != 'Todos'
                            ? AppColors.primaryRed
                            : AppColors.lightGray.withOpacity(0.5),
                        width: _priceFilter != 'Todos' ? 2 : 1.5,
                      ),
                      boxShadow: _priceFilter != 'Todos'
                          ? [
                              BoxShadow(
                                color: AppColors.primaryRed.withOpacity(0.1),
                                offset: const Offset(0, 2),
                                blurRadius: 8,
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.attach_money_rounded,
                                size: 18,
                                color: _priceFilter != 'Todos'
                                    ? AppColors.primaryRed
                                    : AppColors.textBlack.withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _priceFilter == 'Todos' ? 'Rango de precio' : _priceFilter,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: _priceFilter != 'Todos'
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: _priceFilter != 'Todos'
                                        ? AppColors.primaryRed
                                        : AppColors.textBlack,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 22,
                          color: _priceFilter != 'Todos'
                              ? AppColors.primaryRed
                              : AppColors.textBlack.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Filtro de disponibilidad (toggle) mejorado con texto claro
              GestureDetector(
                onTap: () {
                  setState(() {
                    _onlyAvailable = !_onlyAvailable;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _onlyAvailable
                        ? Colors.green
                        : AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _onlyAvailable
                          ? Colors.green
                          : AppColors.lightGray.withOpacity(0.5),
                      width: _onlyAvailable ? 2 : 1.5,
                    ),
                    boxShadow: _onlyAvailable
                        ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _onlyAvailable
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        size: 18,
                        color: _onlyAvailable
                            ? AppColors.backgroundWhite
                            : AppColors.textBlack.withOpacity(0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Disponible',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              _onlyAvailable ? FontWeight.bold : FontWeight.w600,
                          color: _onlyAvailable
                              ? AppColors.backgroundWhite
                              : AppColors.textBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Construye el grid de productos con 2 columnas
  Widget _buildProductGrid(List<Map<String, dynamic>> products) {
    return GridView.builder(
      padding: const EdgeInsets.only(
        left: AppConstants.defaultPadding,
        right: AppConstants.defaultPadding,
        top: 8,
        bottom: 80,  // Espacio extra para ver completamente el último producto
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columnas
        childAspectRatio: 0.72, // Proporción ancho/alto
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return _AnimatedItem(
          controller: _animationController,
          delay: 200 + (index * 50), // Animación escalonada
          child: ProductCard(
            name: product['name'],
            price: product['price'],
            originalPrice: product['originalPrice'],
            discount: product['discount'],
            imagePath: product['image'],
            onTap: () => _showProductDetail(product),
            onAddToCart: () => _addToCart(product),
          ),
        );
      },
    );
  }

  // Estado vacío cuando no hay productos que coincidan con los filtros
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: AppColors.lightGray,
          ),
          const SizedBox(height: 16),
          const Text(
            'No se encontraron productos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otros filtros',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textBlack.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  // Muestra modal con opciones de filtro de precio
  void _showPriceFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtrar por precio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 16),
            ..._priceOptions.map((option) {
              final isSelected = _priceFilter == option;
              return ListTile(
                title: Text(
                  option,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primaryRed
                        : AppColors.textBlack,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primaryRed,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _priceFilter = option;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Navega a la pantalla de detalle del producto
  // Usa Hero animation para transición suave de la imagen
  void _showProductDetail(Map<String, dynamic> product) {
    Navigator.of(context).push(
      PageTransitions.fadeScaleTransition(
        ProductDetailScreen(
          name: product['name'],
          price: product['price'],
          originalPrice: product['originalPrice'],
          discount: product['discount'],
          imagePath: product['image'],
          description: _getProductDescription(product['name']),
          category: product['category'],
          available: product['available'],
        ),
      ),
    );
  }

  // Genera una descripción para el producto
  // En producción vendría de la base de datos
  String _getProductDescription(String productName) {
    if (productName.contains('Leche')) {
      return 'Leche fresca y nutritiva de alta calidad. Ideal para toda la familia.';
    } else if (productName.contains('Carne')) {
      return 'Carne fresca de primera calidad. Perfecta para tus preparaciones favoritas.';
    } else if (productName.contains('Coca') || productName.contains('Pepsi')) {
      return 'Bebida refrescante y deliciosa. Perfecta para acompañar tus comidas.';
    } else if (productName.contains('Pan')) {
      return 'Pan fresco recién horneado. Ideal para el desayuno o merienda.';
    } else if (productName.contains('Naranja') || productName.contains('Palta') || productName.contains('Kiwi')) {
      return 'Fruta fresca y de temporada. Rica en vitaminas y nutrientes.';
    } else {
      return 'Producto de alta calidad seleccionado especialmente para ti.';
    }
  }

  // Agrega un producto al carrito
  // Incrementa el contador y muestra feedback visual al usuario
  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItemCount++;
    });

    // Feedback visual con SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.backgroundWhite,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${product['name']} agregado al carrito',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        ),
        margin: const EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  // Badge que muestra la cantidad de productos filtrados
  // Da feedback inmediato al usuario sobre sus filtros
  Widget _buildResultsBadge(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.lightGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 14,
                  color: AppColors.textBlack.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  count == 1
                      ? '1 producto'
                      : '$count productos',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Chip de categoría personalizado con ícono y contador de productos
// Diseño profesional con animaciones y feedback visual
class _CategoryChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primaryRed
                : AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primaryRed
                  : AppColors.lightGray.withOpacity(0.5),
              width: widget.isSelected ? 2 : 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryRed.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícono de la categoría
              Icon(
                widget.icon,
                size: 16,
                color: widget.isSelected
                    ? AppColors.backgroundWhite
                    : AppColors.primaryRed,
              ),
              const SizedBox(width: 6),
              
              // Nombre de la categoría
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      widget.isSelected ? FontWeight.bold : FontWeight.w600,
                  color: widget.isSelected
                      ? AppColors.backgroundWhite
                      : AppColors.textBlack,
                ),
              ),
              
              const SizedBox(width: 4),
              
              // Contador de productos
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? AppColors.backgroundWhite.withOpacity(0.2)
                      : AppColors.lightGray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${widget.count}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: widget.isSelected
                        ? AppColors.backgroundWhite
                        : AppColors.textBlack.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para animar la entrada de cada elemento con efecto escalonado
// Los items aparecen uno por uno con fade y slide desde abajo
class _AnimatedItem extends StatelessWidget {
  final AnimationController controller;
  final int delay; // Delay en milisegundos
  final Widget child;

  const _AnimatedItem({
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula el inicio de la animación según el delay
    final double start = delay / 600; // 600ms es la duración total

    // Animación de opacidad
    final Animation<double> fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start.clamp(0.0, 1.0), 1.0, curve: Curves.easeOut),
      ),
    );

    // Animación de desplazamiento vertical
    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start.clamp(0.0, 1.0), 1.0, curve: Curves.easeOutCubic),
      ),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}

