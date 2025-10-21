import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Pantalla de seguimiento en tiempo real del pedido
// Muestra la ubicación del repartidor, tiempo estimado y progreso del pedido
// Incluye animaciones profesionales y actualización en tiempo real
class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  final String deliveryPerson;
  final String estimatedTime;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
    this.deliveryPerson = 'Juan Perez',
    this.estimatedTime = '14:00 - 14:35',
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _markerAnimationController;

  // Estado del pedido (0: Confirmado, 1: Preparando, 2: En camino, 3: Entregado)
  int _orderStatus = 2;

  // Timer para actualizar el tiempo estimado
  late Timer _updateTimer;
  int _minutesRemaining = 25;
  double _distanceKm = 2.3;

  // Progreso de la ruta (0.0 a 1.0)
  double _routeProgress = 0.4;

  @override
  void initState() {
    super.initState();

    // Controlador para animaciones de entrada
    _entryAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Controlador para pulso del badge "En Hora"
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Controlador para bounce del marcador
    _markerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _entryAnimationController.forward();

    // Simula actualización del pedido cada 3 segundos
    _updateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        if (_minutesRemaining > 0) {
          _minutesRemaining--;
        }
        if (_routeProgress < 1.0) {
          _routeProgress += 0.05;
        }
        if (_distanceKm > 0.1) {
          _distanceKm -= 0.1;
        }
      });
    });
  }

  @override
  void dispose() {
    _entryAnimationController.dispose();
    _pulseAnimationController.dispose();
    _markerAnimationController.dispose();
    _updateTimer.cancel();
    super.dispose();
  }

  // Determina si el pedido está en hora según el tiempo restante
  bool get _isOnTime => _minutesRemaining <= 35;

  // Formatea el tiempo restante
  String get _timeRemaining {
    if (_minutesRemaining < 1) return 'Llegando...';
    return '$_minutesRemaining min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
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
            'Seguimiento de Pedido',
            style: TextStyle(
              color: AppColors.backgroundWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Bordes redondeados en la parte inferior para continuidad visual
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTracking,
        color: AppColors.primaryRed,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Card de tiempo estimado
              _AnimatedItem(
                controller: _entryAnimationController,
                delay: 0,
                child: _buildEstimatedTimeCard(),
              ),

              // Mapa con ruta
              _AnimatedItem(
                controller: _entryAnimationController,
                delay: 100,
                child: _buildMapSection(),
              ),

              // Barra de progreso del pedido
              _AnimatedItem(
                controller: _entryAnimationController,
                delay: 200,
                child: _buildProgressBar(),
              ),

              // Card de producto
              _AnimatedItem(
                controller: _entryAnimationController,
                delay: 300,
                child: _buildProductCard(),
              ),

              // Información del repartidor
              _AnimatedItem(
                controller: _entryAnimationController,
                delay: 400,
                child: _buildDeliveryPersonInfo(),
              ),

              // Método de pago
              _AnimatedItem(
                controller: _entryAnimationController,
                delay: 500,
                child: _buildPaymentMethod(),
              ),

              // Botones de acción
              _AnimatedItem(
                controller: _entryAnimationController,
                delay: 600,
                child: _buildActionButtons(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Card superior con tiempo estimado de llegada
  Widget _buildEstimatedTimeCard() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Llegada estimada: Jueves',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              // Badge "En Hora" con animación de pulso
              ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 1.08).animate(
                  CurvedAnimation(
                    parent: _pulseAnimationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                  child: const Text(
                    'En Hora',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Tiempo estimado con animación
          Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Text(
                  widget.estimatedTime,
                  key: ValueKey(widget.estimatedTime),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Barra de progreso del tiempo
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _routeProgress,
              backgroundColor: AppColors.lightGray.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                _isOnTime ? Colors.green : Colors.orange,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // Sección del mapa con ruta y marcador animado
  Widget _buildMapSection() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Mapa (imagen estática - reemplazar con screenshot de Google Maps)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[300]!,
                    Colors.grey[400]!,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 64,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Mapa de Ruta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Reemplazar con:\nassets/images/map_route.png',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Marcador del repartidor con animación de bounce
            Positioned(
              top: 100 + (_markerAnimationController.value * 10),
              left: 150,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withOpacity(0.4),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delivery_dining_rounded,
                  color: AppColors.backgroundWhite,
                  size: 28,
                ),
              ),
            ),

            // Badge de tiempo restante
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: AppColors.primaryRed,
                    ),
                    const SizedBox(width: 6),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        _timeRemaining,
                        key: ValueKey(_minutesRemaining),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '• ${_distanceKm.toStringAsFixed(1)} km',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textBlack.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Barra de progreso del pedido con estados
  Widget _buildProgressBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estado del Pedido',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildProgressStep(0, 'Confirmado', Icons.check_circle_rounded),
              _buildProgressLine(0),
              _buildProgressStep(1, 'Preparando', Icons.restaurant_rounded),
              _buildProgressLine(1),
              _buildProgressStep(2, 'En camino', Icons.delivery_dining_rounded),
              _buildProgressLine(2),
              _buildProgressStep(3, 'Entregado', Icons.home_rounded),
            ],
          ),
        ],
      ),
    );
  }

  // Paso individual del progreso
  Widget _buildProgressStep(int step, String label, IconData icon) {
    final bool isCompleted = step <= _orderStatus;
    final bool isCurrent = step == _orderStatus;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : AppColors.lightGray.withOpacity(0.3),
            shape: BoxShape.circle,
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.4),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ]
                : [],
          ),
          child: Icon(
            icon,
            color: isCompleted ? AppColors.backgroundWhite : AppColors.lightGray,
            size: 22,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 60,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCompleted
                  ? AppColors.textBlack
                  : AppColors.textBlack.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  // Línea de conexión entre pasos
  Widget _buildProgressLine(int step) {
    final bool isCompleted = step < _orderStatus;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 3,
        margin: const EdgeInsets.only(bottom: 36),
        decoration: BoxDecoration(
          color: isCompleted ? Colors.green : AppColors.lightGray.withOpacity(0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // Card del producto pedido
  Widget _buildProductCard() {
    return Container(
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
      ),
      child: Row(
        children: [
          // Imagen del combo
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: AppColors.lightGray.withOpacity(0.2),
              child: const Icon(
                Icons.fastfood_rounded,
                size: 32,
                color: AppColors.primaryRed,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Información del producto
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Combo: CocaCola + Vaso',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '1 Producto',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.lightGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Información del repartidor con botón de mensaje
  Widget _buildDeliveryPersonInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightGray.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar del repartidor con badge online
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.lightGray.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 28,
                  color: AppColors.primaryRed,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.backgroundWhite,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Información del repartidor
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Entrega a cargo de',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.lightGray,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.deliveryPerson,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
          ),
          // Botón enviar mensaje
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidad de chat'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: const Text(
              'Enviar mensaje',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método de pago utilizado
  Widget _buildPaymentMethod() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightGray.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.qr_code_rounded,
              color: Colors.grey[700],
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Método de pago',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.lightGray,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Pago por QR',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Botones de compartir y ayuda
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Row(
        children: [
          // Botón Compartir
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad de compartir'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(
                  color: AppColors.lightGray.withOpacity(0.5),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Compartir',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Botón Necesitas Ayuda
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad de ayuda'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Necesitas Ayuda',
                style: TextStyle(
                  color: AppColors.backgroundWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Simula actualización del seguimiento al hacer pull-to-refresh
  Future<void> _refreshTracking() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      // Simula actualización de datos
      _routeProgress = (_routeProgress + 0.1).clamp(0.0, 1.0);
    });
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

