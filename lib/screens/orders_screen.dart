import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/page_transitions.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/recent_order_card.dart';
import 'offers_screen.dart';
import 'profile_screen.dart';
import 'order_tracking_screen.dart';

// Pantalla de pedidos y historial de compras
// Muestra todos los pedidos organizados por estado
// Permite repetir pedidos anteriores fácilmente
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 2; // Pedidos es el índice 2
  late TabController _tabController;
  int _cartItemCount = 3; // Contador de items en el carrito

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Agrega un producto al carrito y actualiza el contador
  void _addToCart(String productName) {
    setState(() {
      _cartItemCount++;
    });
    _showSnackBar('✓ $productName agregado al carrito');
  }

  // Historial completo de pedidos del usuario
  // En producción, estos datos vendrían de una API o base de datos local
  final List<Map<String, dynamic>> _allOrders = [
    {
      'name': 'CocaCola + Vaso',
      'price': 30.0,
      'originalPrice': 35.0,
      'discount': 10,
      'image': 'assets/images/cocacola_vaso.jpg',
      'status': 'entregado',
      'date': '15/10/2024',
    },
    {
      'name': 'Pepsi 3L',
      'price': 18.0,
      'originalPrice': 25.0,
      'discount': 28,
      'image': 'assets/images/pepsi_3L.webp',
      'status': 'en_camino',
      'date': '20/10/2024',
    },
    {
      'name': 'Garoto 250gr',
      'price': 20.90,
      'originalPrice': 28.70,
      'discount': 27,
      'image': 'assets/images/garoto.jpg',
      'status': 'entregado',
      'date': '18/10/2024',
    },
    {
      'name': 'Nescafé Clásico',
      'price': 28.0,
      'originalPrice': 35.0,
      'discount': 20,
      'image': 'assets/images/nescafe_clasico.webp',
      'status': 'en_camino',
      'date': '21/10/2024',
    },
  ];

  // Filtra y devuelve pedidos según su estado actual
  // Permite mostrar solo pedidos relevantes en cada pestaña
  List<Map<String, dynamic>> _getOrdersByStatus(String status) {
    if (status == 'todos') return _allOrders;
    return _allOrders.where((order) => order['status'] == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomAppBar(
        cartItemCount: _cartItemCount,
      ),
      body: Column(
        children: [
          // Encabezado con título
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.defaultPadding,
              AppConstants.defaultPadding,
              AppConstants.defaultPadding,
              AppConstants.smallPadding,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primaryRed,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Mis Pedidos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Tabs para filtrar pedidos con diseño mejorado
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.lightGray.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow.withOpacity(0.08),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRed.withOpacity(0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.backgroundWhite,
              unselectedLabelColor: AppColors.textBlack.withOpacity(0.6),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Todos'),
                Tab(text: 'En Camino'),
                Tab(text: 'Entregados'),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Lista de pedidos según el tab seleccionado con transición suave
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(), // Scroll suave
              children: [
                // Cada tab envuelto en AnimatedSwitcher para transiciones suaves
                _FadeInTab(key: const ValueKey('todos'), child: _buildOrdersList('todos')),
                _FadeInTab(key: const ValueKey('en_camino'), child: _buildOrdersList('en_camino')),
                _FadeInTab(key: const ValueKey('entregado'), child: _buildOrdersList('entregado')),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) return; // Ya estamos en Pedidos
          
          setState(() => _currentIndex = index);
          
          // Navegación con transición de fade rápida para mejor UX
          switch (index) {
            case 0:
              Navigator.of(context).pop(); // Volver a Home
              break;
            case 1:
              Navigator.of(context).pushReplacement(
                PageTransitions.fadeTransition(const OffersScreen()),
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

  // Construye y muestra la lista de pedidos filtrados por estado
  // Incluye animaciones de entrada y pull-to-refresh para mejor UX
  Widget _buildOrdersList(String status) {
    final orders = _getOrdersByStatus(status);

    // Si no hay pedidos en esta categoría, muestra un estado vacío informativo
    if (orders.isEmpty) {
      return _buildEmptyState(status);
    }

    // Lista scrolleable con pull-to-refresh para actualizar pedidos
    return RefreshIndicator(
      onRefresh: _refreshOrders,
      color: AppColors.primaryRed,
      backgroundColor: AppColors.backgroundWhite,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.defaultPadding,
          0,
          AppConstants.defaultPadding,
          AppConstants.bottomNavHeight + 20,
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          // Envuelve cada item en animación de entrada
          return _AnimatedOrderItem(
            index: index,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado del pedido: fecha + badge de estado
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Fecha del pedido
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: AppColors.textBlack.withOpacity(0.4),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Pedido del ${order['date']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textBlack.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Badge de estado
                    _buildStatusBadge(order['status']),
                  ],
                ),
              ),

              // Card del pedido (reutilizando RecentOrderCard)
              RecentOrderCard(
                name: order['name'],
                price: order['price'],
                originalPrice: order['originalPrice'],
                discount: order['discount'],
                imagePath: order['image'],
                onTap: () {
                  // Si el pedido está en camino, navega a seguimiento
                  if (order['status'] == 'En camino') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderTrackingScreen(
                          orderId: order['id'],
                          deliveryPerson: 'Juan Perez',
                          estimatedTime: '14:00 - 14:35',
                        ),
                      ),
                    );
                  } else {
                    _showSnackBar('Pedido: ${order['name']}');
                  }
                },
                onOrderAgain: () => _addToCart(order['name']),
                buttonOnRight: true, // Botón a la derecha
              ),

              const SizedBox(height: 16),
            ],
          ),
          );
        },
      ),
    );
  }

  // Actualiza la lista de pedidos cuando el usuario desliza hacia abajo
  // En producción, haría una petición al servidor para obtener pedidos nuevos
  Future<void> _refreshOrders() async {
    // Simula la carga de datos desde el servidor
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Reconstruye la UI con los datos actualizados
    });
    _showSnackBar('✓ Pedidos actualizados');
  }

  // Crea un badge visual que indica el estado actual del pedido
  // Los pedidos "en camino" tienen animación de pulso para llamar la atención
  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'en_camino':
        color = AppColors.accentYellow;
        label = 'En camino';
        icon = Icons.local_shipping_rounded;
        // Badge con pulso para pedidos en camino
        return _PulsingStatusBadge(
          color: color,
          label: label,
          icon: icon,
        );
      case 'entregado':
        color = Colors.green;
        label = 'Entregado';
        icon = Icons.check_circle_rounded;
        break;
      default:
        color = AppColors.textLightGray;
        label = 'Pendiente';
        icon = Icons.schedule_rounded;
    }

    // Badge estático para otros estados
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Muestra una pantalla informativa cuando no hay pedidos en una categoría
  // Personaliza el mensaje según el tipo de filtro aplicado
  Widget _buildEmptyState(String status) {
    String title;
    String message;
    IconData icon;

    switch (status) {
      case 'en_camino':
        title = 'Sin pedidos en camino';
        message = 'Tus pedidos activos aparecerán aquí';
        icon = Icons.local_shipping_outlined;
        break;
      case 'entregado':
        title = 'Sin pedidos entregados';
        message = 'Tu historial de compras aparecerá aquí';
        icon = Icons.check_circle_outline;
        break;
      default:
        title = 'Sin pedidos';
        message = 'Aún no has realizado ningún pedido';
        icon = Icons.receipt_long_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.textLightGray,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textBlack.withOpacity(0.6),
              ),
            ),
          ),
        ],
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

// Widget para animar la entrada de cada pedido con efecto escalonado
// Los items aparecen uno por uno para un efecto más profesional
class _AnimatedOrderItem extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedOrderItem({
    required this.index,
    required this.child,
  });

  @override
  State<_AnimatedOrderItem> createState() => _AnimatedOrderItemState();
}

class _AnimatedOrderItemState extends State<_AnimatedOrderItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Animación de opacidad
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Animación de deslizamiento desde abajo
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Inicia la animación con delay según el índice
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

// Widget para transición suave entre tabs
// Fade in al cambiar de pestaña para mejor UX
class _FadeInTab extends StatefulWidget {
  final Widget child;

  const _FadeInTab({
    super.key,
    required this.child,
  });

  @override
  State<_FadeInTab> createState() => _FadeInTabState();
}

class _FadeInTabState extends State<_FadeInTab>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  bool get wantKeepAlive => true; // Mantiene el estado al cambiar tabs

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Inicia la animación
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Requerido por AutomaticKeepAliveClientMixin
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}

// Badge con animación de pulso para pedidos "En camino"
// Llama la atención sobre pedidos activos
class _PulsingStatusBadge extends StatefulWidget {
  final Color color;
  final String label;
  final IconData icon;

  const _PulsingStatusBadge({
    required this.color,
    required this.label,
    required this.icon,
  });

  @override
  State<_PulsingStatusBadge> createState() => _PulsingStatusBadgeState();
}

class _PulsingStatusBadgeState extends State<_PulsingStatusBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.06, // Crece 6% sutilmente
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.color.withOpacity(0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 12, color: widget.color),
            const SizedBox(width: 4),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

