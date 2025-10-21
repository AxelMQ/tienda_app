import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Pantalla de pago con código QR
// Muestra un QR generado para el pago y permite al usuario confirmar cuando pagó
// Incluye opción de guardar el QR en galería y verificación del pago
class PaymentQRScreen extends StatefulWidget {
  final double total;

  const PaymentQRScreen({
    super.key,
    required this.total,
  });

  @override
  State<PaymentQRScreen> createState() => _PaymentQRScreenState();
}

class _PaymentQRScreenState extends State<PaymentQRScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Fecha de vencimiento del QR (24 horas desde ahora)
  late DateTime _expirationDate;
  
  // Estado de verificación de pago
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();

    // Controlador de animaciones para entrada escalonada
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animationController.forward();

    // Calcula fecha de vencimiento (24 horas)
    _expirationDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Formatea la fecha de vencimiento
  String get _formattedExpirationDate {
    return '${_expirationDate.day.toString().padLeft(2, '0')}-${_expirationDate.month.toString().padLeft(2, '0')}-${_expirationDate.year}';
  }

  // Guarda el QR en la galería (simulado)
  void _saveToGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(
              Icons.download_done_rounded,
              color: AppColors.backgroundWhite,
              size: 20,
            ),
            SizedBox(width: 12),
            Text(
              'QR guardado en galería',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Verifica el pago y procesa la confirmación
  Future<void> _confirmPayment() async {
    setState(() {
      _isVerifying = true;
    });

    // Simula verificación del pago (en producción sería llamada a API)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isVerifying = false;
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
              '¡Pago Confirmado!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tu pago con QR ha sido verificado exitosamente',
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
            'Pago QR',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Título
              _AnimatedItem(
                controller: _animationController,
                delay: 0,
                child: const Text(
                  'Escanea el QR',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Código QR (simulado con placeholder)
              _AnimatedItem(
                controller: _animationController,
                delay: 100,
                child: _buildQRCode(),
              ),

              const SizedBox(height: 24),

              // Total y vencimiento
              _AnimatedItem(
                controller: _animationController,
                delay: 200,
                child: _buildPaymentInfo(),
              ),

              const SizedBox(height: 24),

              // Botón guardar en galería
              _AnimatedItem(
                controller: _animationController,
                delay: 300,
                child: _buildSaveButton(),
              ),

              const SizedBox(height: 32),

              // Divisor
              const Divider(height: 1),

              const SizedBox(height: 32),

              // Texto de verificación
              _AnimatedItem(
                controller: _animationController,
                delay: 400,
                child: Text(
                  'Verificar mi pago ...',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textBlack.withOpacity(0.7),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botón Ya Pague
              _AnimatedItem(
                controller: _animationController,
                delay: 500,
                child: _buildConfirmButton(),
              ),

              const SizedBox(height: 24),

              // Instrucciones adicionales
              _AnimatedItem(
                controller: _animationController,
                delay: 600,
                child: _buildInstructions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Código QR con borde y sombra
  Widget _buildQRCode() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightGray.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          // QR Code placeholder (en producción sería un QR real con paquete qr_flutter)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.lightGray.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.qr_code_2_rounded,
                size: 160,
                color: AppColors.textBlack.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Información de pago (total y vencimiento)
  Widget _buildPaymentInfo() {
    return Container(
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
        children: [
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              Text(
                'Bs. ${widget.total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Vencimiento
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 16,
                color: AppColors.textBlack.withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              Text(
                'Vencimiento: $_formattedExpirationDate',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textBlack.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Botón guardar en galería
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _saveToGallery,
        icon: const Icon(Icons.download_rounded, size: 20),
        label: const Text(
          'Guardar en Galería',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
          side: const BorderSide(color: AppColors.primaryRed, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Botón Ya Pague
  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isVerifying ? null : _confirmPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          disabledBackgroundColor: AppColors.primaryRed.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isVerifying
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.backgroundWhite,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Ya Pague',
                style: TextStyle(
                  color: AppColors.backgroundWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  // Instrucciones para el usuario
  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.blue[700],
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instrucciones',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '1. Escanea el código QR con tu app de banco\n2. Confirma el pago de Bs. ${widget.total.toStringAsFixed(0)}\n3. Presiona "Ya Pague" cuando hayas completado',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textBlack.withOpacity(0.7),
                    height: 1.5,
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

