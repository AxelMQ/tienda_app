import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Pantalla de confirmación de pedido exitoso
// Se muestra después de completar el pago (QR, Tarjeta o Efectivo)
// Diferencia entre pago realizado y pedido confirmado según el método
class OrderSuccessScreen extends StatefulWidget {
  final String paymentMethod; // 'qr', 'card', 'cash'
  final double total;

  const OrderSuccessScreen({
    super.key,
    required this.paymentMethod,
    required this.total,
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Controlador de animaciones para el ícono de éxito
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Inicia la animación
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Determina si el pago fue procesado o es en efectivo
  bool get _isPaid => widget.paymentMethod != 'cash';

  // Título según el método de pago
  String get _title => _isPaid ? 'Pago Realizado' : 'Pedido Confirmado';

  // Mensaje principal según el método de pago
  String get _mainMessage {
    if (_isPaid) {
      return 'Pago Realizado Exitosamente';
    } else {
      return 'Pedido Confirmado Exitosamente';
    }
  }

  // Submensaje según el método de pago
  String get _subMessage {
    if (_isPaid) {
      return 'Su pedido llegará en minutos';
    } else {
      return 'Pagará Bs. ${widget.total.toStringAsFixed(0)} al recibir su pedido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Previene que el usuario regrese con el botón back
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: AppColors.primaryRed,
            elevation: 0,
            automaticallyImplyLeading: false, // Sin botón back
            title: Text(
              _title,
              style: const TextStyle(
                color: AppColors.backgroundWhite,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            // Bordes redondeados en la parte inferior para continuidad visual
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: 24,
            ),
            child: Column(
              children: [
                // Spacer superior para centrar visualmente el contenido
                const Spacer(flex: 2),

                // Ícono de éxito animado con rebote
                ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.elasticOut,
                  ),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: (_isPaid ? Colors.green : Colors.orange)
                          .withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: _isPaid ? Colors.green : Colors.orange[700],
                      size: 100,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Mensaje principal con fade
                FadeTransition(
                  opacity: _animationController,
                  child: Text(
                    _mainMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Submensaje con fade y slide
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Text(
                      _subMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textBlack.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Información adicional con slide y fade
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
                    ),
                    child: _isPaid ? _buildPaymentInfo() : _buildCashInfo(),
                  ),
                ),

                // Spacer inferior para centrar visualmente
                const Spacer(flex: 3),

                // Botón Ver mi pedido con fade
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Regresa al home y limpia el stack de navegación
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Ver mi pedido',
                        style: TextStyle(
                          color: AppColors.backgroundWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
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

  // Información para pagos procesados (QR/Tarjeta)
  Widget _buildPaymentInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green[700],
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pago procesado correctamente',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.delivery_dining_rounded,
                color: AppColors.textBlack.withOpacity(0.6),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tiempo estimado: 25-40 minutos',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textBlack.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: AppColors.textBlack.withOpacity(0.6),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Total pagado: Bs. ${widget.total.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textBlack.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Información para pago en efectivo
  Widget _buildCashInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.orange[700],
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pago al recibir',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.delivery_dining_rounded,
                color: AppColors.textBlack.withOpacity(0.6),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tiempo estimado: 25-40 minutos',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textBlack.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.payments_rounded,
                color: AppColors.textBlack.withOpacity(0.6),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ten listo Bs. ${widget.total.toStringAsFixed(0)} en efectivo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

