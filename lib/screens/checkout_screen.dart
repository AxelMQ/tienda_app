import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Pantalla final de pago donde el usuario confirma su pedido
// Incluye selección de método de pago, datos de entrega y resumen del pedido
// Diseño enfocado en claridad y prevención de errores antes de confirmar
class CheckoutScreen extends StatefulWidget {
  final double subtotal;
  final double discount;

  const CheckoutScreen({
    super.key,
    required this.subtotal,
    required this.discount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Método de pago seleccionado (0: QR, 1: Tarjeta, 2: Efectivo)
  int _selectedPaymentMethod = 0;

  // Datos de entrega (en producción vendrían del state manager)
  final String _deliveryAddress = 'Santa Cruz, calle 13';
  final String _deliveryInstructions = 'Dejar en la puerta del edificio';
  final String _billingName = 'Perez Juan';
  final String _billingNIT = '8456671';

  // Costos adicionales
  final double _deliveryFee = 5.0;
  final double _serviceFee = 2.0;

  // Estado del proceso de pago
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    // Controlador de animaciones para entrada escalonada
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Calcula el total final incluyendo todos los costos
  double get _total {
    return widget.subtotal + _deliveryFee + _serviceFee;
  }

  // Procesa el pago según el método seleccionado
  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simula procesamiento de pago (en producción sería llamada a API)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    // Muestra confirmación de pago exitoso
    _showSuccessDialog();
  }

  // Muestra diálogo de confirmación de pago exitoso
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Pago Exitoso!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tu pedido ha sido procesado correctamente',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textBlack.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Regresa al home y limpia el stack de navegación
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Volver al inicio',
                  style: TextStyle(
                    color: AppColors.backgroundWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Abre modal para cambiar dirección de entrega
  void _changeDeliveryAddress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de cambiar dirección'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Abre modal para editar instrucciones de entrega
  void _editDeliveryInstructions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de editar instrucciones'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Abre modal para cambiar datos de facturación
  void _changeBillingData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de cambiar facturación'),
        duration: Duration(seconds: 1),
      ),
    );
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
            'Último Paso',
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
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Métodos de pago
              SliverToBoxAdapter(
                child: _AnimatedItem(
                  controller: _animationController,
                  delay: 0,
                  child: _buildPaymentMethods(),
                ),
              ),

              // Datos de entrega
              SliverToBoxAdapter(
                child: _AnimatedItem(
                  controller: _animationController,
                  delay: 100,
                  child: _buildDeliveryData(),
                ),
              ),

              // Datos de facturación
              SliverToBoxAdapter(
                child: _AnimatedItem(
                  controller: _animationController,
                  delay: 200,
                  child: _buildBillingData(),
                ),
              ),

              // Resumen del pedido
              SliverToBoxAdapter(
                child: _AnimatedItem(
                  controller: _animationController,
                  delay: 300,
                  child: _buildOrderSummary(),
                ),
              ),

              // Espacio para el footer
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),

          // Footer fijo con total y botón de pagar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildFooter(),
          ),
        ],
      ),
    );
  }

  // Sección de métodos de pago
  Widget _buildPaymentMethods() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Métodos de Pago',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 16),

          // Opción: Pago QR
          _PaymentMethodOption(
            icon: Icons.qr_code_rounded,
            iconColor: Colors.grey[700]!,
            iconBackground: Colors.grey[200]!,
            label: 'Pago QR',
            isSelected: _selectedPaymentMethod == 0,
            onTap: () => setState(() => _selectedPaymentMethod = 0),
          ),

          const SizedBox(height: 12),

          // Opción: Tarjeta
          _PaymentMethodOption(
            icon: Icons.credit_card_rounded,
            iconColor: Colors.blue[700]!,
            iconBackground: Colors.blue[100]!,
            label: 'Tarjeta',
            isSelected: _selectedPaymentMethod == 1,
            onTap: () => setState(() => _selectedPaymentMethod = 1),
          ),

          const SizedBox(height: 12),

          // Opción: Efectivo
          _PaymentMethodOption(
            icon: Icons.payments_rounded,
            iconColor: Colors.green[700]!,
            iconBackground: Colors.green[100]!,
            label: 'Efectivo',
            isSelected: _selectedPaymentMethod == 2,
            onTap: () => setState(() => _selectedPaymentMethod = 2),
          ),
        ],
      ),
    );
  }

  // Sección de datos de entrega
  Widget _buildDeliveryData() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Datos de Entrega',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 16),

          // Dirección de entrega
          _DataRow(
            icon: Icons.delivery_dining_rounded,
            title: 'Delivery',
            subtitle: 'Casa',
            description: _deliveryAddress,
            actionLabel: 'Cambiar',
            onActionTap: _changeDeliveryAddress,
          ),

          const SizedBox(height: 12),

          // Instrucciones de entrega
          _DataRow(
            icon: Icons.description_outlined,
            title: 'Instrucciones de Entrega',
            subtitle: '',
            description: _deliveryInstructions,
            actionLabel: 'Editar',
            onActionTap: _editDeliveryInstructions,
          ),
        ],
      ),
    );
  }

  // Sección de datos de facturación
  Widget _buildBillingData() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Datos de Facturación',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 16),

          // Nombre y NIT
          _DataRow(
            icon: Icons.receipt_long_rounded,
            title: _billingName,
            subtitle: '',
            description: _billingNIT,
            actionLabel: 'Cambiar',
            onActionTap: _changeBillingData,
          ),
        ],
      ),
    );
  }

  // Resumen del pedido con desglose de costos
  Widget _buildOrderSummary() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 16),

          // Productos
          _SummaryRow(
            label: 'Productos',
            value: 'Bs. ${widget.subtotal.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 8),

          // Envío
          _SummaryRow(
            label: 'Envío',
            value: 'Bs. ${_deliveryFee.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 8),

          // Costo de Servicio
          _SummaryRow(
            label: 'Costo de Servicio',
            value: 'Bs. ${_serviceFee.toStringAsFixed(2)}',
          ),

          // Descuento (si existe)
          if (widget.discount > 0) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            const Text(
              'Descuento',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              label: 'Productos',
              value: '- Bs. ${widget.discount.toStringAsFixed(2)}',
              valueColor: Colors.green,
            ),
          ],
        ],
      ),
    );
  }

  // Footer con total y botón de pagar
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
        // Bordes redondeados en la parte superior para continuidad visual
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Text(
                  'Bs. ${_total.toStringAsFixed(0)}',
                  key: ValueKey(_total),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Botón PAGAR
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                disabledBackgroundColor: AppColors.primaryRed.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.backgroundWhite,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'PAGAR',
                      style: TextStyle(
                        color: AppColors.backgroundWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para cada opción de método de pago
// Muestra ícono, label y estado de selección con animación
class _PaymentMethodOption extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodOption({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_PaymentMethodOption> createState() => _PaymentMethodOptionState();
}

class _PaymentMethodOptionState extends State<_PaymentMethodOption> {
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
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primaryRed.withOpacity(0.05)
                : AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primaryRed
                  : AppColors.lightGray.withOpacity(0.4),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
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
            children: [
              // Ícono del método de pago
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: 26,
                ),
              ),

              const SizedBox(width: 16),

              // Label
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        widget.isSelected ? FontWeight.bold : FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
              ),

              // Indicador de selección
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSelected
                        ? AppColors.primaryRed
                        : AppColors.lightGray,
                    width: 2,
                  ),
                  color: widget.isSelected
                      ? AppColors.primaryRed
                      : Colors.transparent,
                ),
                child: widget.isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.backgroundWhite,
                        size: 16,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para mostrar información con opción de editar/cambiar
class _DataRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final String actionLabel;
  final VoidCallback onActionTap;

  const _DataRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Ícono
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryRed,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textBlack.withOpacity(0.6),
                    ),
                  ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textBlack.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Botón de acción
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para mostrar filas de resumen
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textBlack.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textBlack,
          ),
        ),
      ],
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

