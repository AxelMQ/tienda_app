import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Pantalla del carrito de compras con productos agregados
// Permite modificar cantidades, eliminar productos y ver sugerencias
// Diseño enfocado en conversión y facilidad de modificación del pedido
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Datos de ejemplo del carrito (en producción vendría de un state manager)
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': '1',
      'name': 'CocaCola + Vaso',
      'price': 30.0,
      'originalPrice': 35.0,
      'discount': 10,
      'quantity': 1,
      'image': 'assets/images/cocacola_vaso.jpg',
      'maxStock': 10,
    },
    {
      'id': '2',
      'name': 'Sprite - 300ml',
      'price': 30.0,
      'originalPrice': 35.0,
      'discount': 10,
      'quantity': 1,
      'image': 'assets/images/bebida_rush_energy.webp',
      'maxStock': 5,
    },
    {
      'id': '3',
      'name': 'Cafe Premium',
      'price': 30.0,
      'originalPrice': 35.0,
      'discount': 10,
      'quantity': 1,
      'image': 'assets/images/nescafe_clasico.webp',
      'maxStock': 8,
    },
  ];

  // Sugerencias de productos adicionales
  final List<Map<String, dynamic>> _suggestions = [
    {
      'name': 'Pepsi Cola',
      'price': 25.0,
      'image': 'assets/images/pepsi_1L.webp',
      'subtitle': '500ml',
    },
    {
      'name': 'Nescafe',
      'price': 100.0,
      'image': 'assets/images/nescafe_forte.jpeg',
      'subtitle': 'Combo Cafe + Taza',
    },
    {
      'name': 'Leche PIL',
      'price': 42.0,
      'image': 'assets/images/leche_caja.jpg',
      'subtitle': '1L',
    },
  ];

  // Constantes de entrega
  final double _deliveryFee = 5.0;
  final String _deliveryTime = '25-40min';

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador de animaciones para efectos de entrada
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Inicia las animaciones al cargar la pantalla
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Calcula el subtotal de todos los productos en el carrito
  double get _subtotal {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  // Calcula el total de descuentos aplicados
  double get _totalDiscount {
    return _cartItems.fold(
      0.0,
      (sum, item) {
        final originalPrice = item['originalPrice'] ?? item['price'];
        final discount = (originalPrice - item['price']) * item['quantity'];
        return sum + discount;
      },
    );
  }

  // Incrementa la cantidad de un producto
  void _incrementQuantity(int index) {
    final item = _cartItems[index];
    if (item['quantity'] < item['maxStock']) {
      setState(() {
        item['quantity']++;
      });
    } else {
      // Muestra mensaje si alcanzó el stock máximo
      _showStockLimitMessage(item['name'], item['maxStock']);
    }
  }

  // Decrementa la cantidad de un producto
  void _decrementQuantity(int index) {
    final item = _cartItems[index];
    if (item['quantity'] > 1) {
      setState(() {
        item['quantity']--;
      });
    } else {
      // Si la cantidad es 1, pregunta si quiere eliminar
      _confirmRemoveItem(index);
    }
  }

  // Elimina un producto del carrito
  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });

    // Muestra confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(
              Icons.delete_rounded,
              color: AppColors.backgroundWhite,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(  // Evita overflow en textos largos
              child: Text(
                'Producto eliminado del carrito',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        ),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: AppColors.backgroundWhite,
          onPressed: () {
            // TODO: Implementar deshacer eliminación
          },
        ),
      ),
    );
  }

  // Muestra confirmación antes de eliminar un producto
  void _confirmRemoveItem(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '¿Eliminar producto?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '¿Estás seguro que deseas eliminar "${_cartItems[index]['name']}" del carrito?',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textBlack.withOpacity(0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: AppColors.textBlack.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _removeItem(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Eliminar',
              style: TextStyle(
                color: AppColors.backgroundWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Muestra mensaje cuando se alcanza el límite de stock
  void _showStockLimitMessage(String productName, int maxStock) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_rounded,
              color: AppColors.accentYellow,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Stock máximo alcanzado: $maxStock unidades',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.textBlack,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        ),
      ),
    );
  }

  // Agrega un producto sugerido al carrito
  void _addSuggestionToCart(Map<String, dynamic> suggestion) {
    setState(() {
      _cartItems.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': suggestion['name'],
        'price': suggestion['price'],
        'quantity': 1,
        'image': suggestion['image'],
        'maxStock': 10,
      });
    });

    // Muestra confirmación
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
                '${suggestion['name']} agregado al carrito',
                style: const TextStyle(fontWeight: FontWeight.w600),
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
      ),
    );
  }

  // Vacía todo el carrito con confirmación
  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '¿Vaciar carrito?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Se eliminarán todos los productos del carrito.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: AppColors.textBlack.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _cartItems.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Vaciar',
              style: TextStyle(
                color: AppColors.backgroundWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Procede al pago (placeholder)
  void _proceedToCheckout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.payment_rounded,
              color: AppColors.backgroundWhite,
              size: 20,
            ),
            SizedBox(width: 12),
            Text(
              'Procesando pago...',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.primaryRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.backgroundWhite,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tu carrito',
          style: TextStyle(
            color: AppColors.backgroundWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Botón para vaciar carrito
          if (_cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.backgroundWhite,
              ),
              onPressed: _clearCart,
              tooltip: 'Vaciar carrito',
            ),
        ],
      ),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
    );
  }

  // Estado vacío cuando no hay productos en el carrito
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: AppColors.lightGray.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Agrega productos para comenzar tu pedido',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textBlack.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Explorar productos',
              style: TextStyle(
                color: AppColors.backgroundWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Contenido principal del carrito con productos
  Widget _buildCartContent() {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Información de entrega
            SliverToBoxAdapter(
              child: _AnimatedItem(
                controller: _animationController,
                delay: 0,
                child: _buildDeliveryInfo(),
              ),
            ),

            // Lista de productos en el carrito
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _AnimatedItem(
                    controller: _animationController,
                    delay: 100 + (index * 50),
                    child: _buildCartItem(index),
                  );
                },
                childCount: _cartItems.length,
              ),
            ),

            // Sección de sugerencias
            SliverToBoxAdapter(
              child: _AnimatedItem(
                controller: _animationController,
                delay: 100 + (_cartItems.length * 50),
                child: _buildSuggestionsSection(),
              ),
            ),

            // Espacio para el footer
            const SliverToBoxAdapter(
              child: SizedBox(height: 200),
            ),
          ],
        ),

        // Footer fijo con total y botón de pago
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildFooter(),
        ),
      ],
    );
  }

  // Información de entrega (tiempo y costo)
  Widget _buildDeliveryInfo() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightGray.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.delivery_dining_rounded,
              color: AppColors.primaryRed,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: AppColors.textBlack,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Recibes en $_deliveryTime',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.local_shipping_rounded,
                      size: 16,
                      color: AppColors.textBlack,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Envío Bs. ${_deliveryFee.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textBlack.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card de producto en el carrito con swipe para eliminar
  Widget _buildCartItem(int index) {
    final item = _cartItems[index];

    return Dismissible(
      key: Key(item['id']),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        // Muestra diálogo de confirmación antes de eliminar
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              '¿Eliminar producto?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              '¿Estás seguro que deseas eliminar "${item['name']}" del carrito?',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textBlack.withOpacity(0.7),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: AppColors.textBlack.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(
                    color: AppColors.backgroundWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        // Elimina el producto después de confirmar
        setState(() {
          _cartItems.removeAt(index);
        });

        // Muestra confirmación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(
                  Icons.delete_rounded,
                  color: AppColors.backgroundWhite,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Producto eliminado del carrito',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.smallRadius),
            ),
          ),
        );
      },
      // Fondo rojo con ícono de basura al deslizar
      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_rounded,
          color: AppColors.backgroundWhite,
          size: 32,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: 8,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.lightGray.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: AppColors.lightGray.withOpacity(0.3),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.lightGray,
                  size: 40,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Precio y descuento
                Row(
                  children: [
                    Text(
                      'Bs. ${item['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                      ),
                    ),
                    if (item['discount'] != null && item['discount'] > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${item['discount']}% OFF',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                // Contador de cantidad
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total por producto con animación
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: Text(
                        'Total: Bs. ${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                        key: ValueKey(item['price'] * item['quantity']),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack.withOpacity(0.7),
                        ),
                      ),
                    ),

                    // Contador con icono delete cuando quantity = 1 (mejor UX)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightGray.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CartButton(
                            // Muestra icono de delete cuando quantity = 1 para claridad
                            icon: item['quantity'] == 1
                                ? Icons.delete_outline_rounded
                                : Icons.remove_rounded,
                            onPressed: () => _decrementQuantity(index),
                            isDelete: item['quantity'] == 1,  // Color diferente
                          ),
                          // AnimatedSwitcher para animar cambios en la cantidad
                          Container(
                            width: 32,
                            alignment: Alignment.center,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Text(
                                '${item['quantity']}',
                                key: ValueKey(item['quantity']),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textBlack,
                                ),
                              ),
                            ),
                          ),
                          _CartButton(
                            icon: Icons.add_rounded,
                            onPressed: () => _incrementQuantity(index),
                          ),
                        ],
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
    );
  }

  // Sección "Te tientas algo más?" con productos sugeridos
  Widget _buildSuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: 16,
          ),
          child: Text(
            '¿Te tientas algo más?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
        ),
        SizedBox(
          height: 170,  // Aumentado de 160 a 170 para evitar overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              return _buildSuggestionCard(_suggestions[index]);
            },
          ),
        ),
      ],
    );
  }

  // Card de producto sugerido
  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightGray.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  suggestion['image'],
                  width: double.infinity,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 90,
                    color: AppColors.lightGray.withOpacity(0.3),
                    child: const Icon(
                      Icons.image_not_supported_rounded,
                      color: AppColors.lightGray,
                      size: 40,
                    ),
                  ),
                ),
              ),

              // Info
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,  // Evita que se expanda más de lo necesario
                  children: [
                    Text(
                      suggestion['name'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (suggestion['subtitle'] != null)
                      Text(
                        suggestion['subtitle'],
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textBlack.withOpacity(0.6),
                        ),
                        maxLines: 1,  // Limita a 1 línea
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 2),  // Reducido de 4 a 2
                    Text(
                      'Bs. ${suggestion['price'].toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Botón agregar
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _addSuggestionToCart(suggestion),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primaryRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4,
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
    );
  }

  // Footer con subtotal y botón de pagar
  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.only(
        left: AppConstants.defaultPadding,
        right: AppConstants.defaultPadding,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Desglose de precios
          if (_totalDiscount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ahorras',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textBlack.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '- Bs. ${_totalDiscount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              // AnimatedSwitcher para animar cambios en el total
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  'Bs. ${_subtotal.toStringAsFixed(2)}',
                  key: ValueKey(_subtotal),  // Cambia cuando el total cambia
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Botón IR A PAGAR
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _proceedToCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'IR A PAGAR',
                style: TextStyle(
                  color: AppColors.backgroundWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Botón para incrementar/decrementar cantidad en el carrito
// Cambia a color naranja cuando es un botón de eliminar (mejor affordance)
class _CartButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDelete;  // Indica si es un botón de eliminar

  const _CartButton({
    required this.icon,
    required this.onPressed,
    this.isDelete = false,
  });

  @override
  State<_CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<_CartButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Color diferenciado: Naranja para delete, Rojo para otras acciones
    final buttonColor = widget.isDelete ? Colors.orange : AppColors.primaryRed;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: buttonColor.withOpacity(_isPressed ? 1.0 : 0.9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            widget.icon,
            color: AppColors.backgroundWhite,
            size: 18,
          ),
        ),
      ),
    );
  }
}

// Widget para animar la entrada de elementos con efecto escalonado
class _AnimatedItem extends StatelessWidget {
  final AnimationController controller;
  final int delay;
  final Widget child;

  const _AnimatedItem({
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double start = delay / 800;

    final Animation<double> fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start.clamp(0.0, 1.0), 1.0, curve: Curves.easeOut),
      ),
    );

    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
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

