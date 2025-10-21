import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'order_success_screen.dart';

// Pantalla de pago con tarjeta de crédito/débito
// Permite ingresar datos de la tarjeta y procesar el pago de forma segura
// Incluye validaciones en tiempo real y feedback visual
class PaymentCardScreen extends StatefulWidget {
  final double total;

  const PaymentCardScreen({
    super.key,
    required this.total,
  });

  @override
  State<PaymentCardScreen> createState() => _PaymentCardScreenState();
}

class _PaymentCardScreenState extends State<PaymentCardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Controladores de texto para los campos del formulario
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  // FocusNodes para gestionar el foco entre campos
  final FocusNode _cardHolderFocus = FocusNode();
  final FocusNode _cardNumberFocus = FocusNode();
  final FocusNode _expiryDateFocus = FocusNode();
  final FocusNode _cvvFocus = FocusNode();

  // Estado del procesamiento de pago
  bool _isProcessing = false;

  // Validaciones
  String? _cardHolderError;
  String? _cardNumberError;
  String? _expiryDateError;
  String? _cvvError;

  @override
  void initState() {
    super.initState();

    // Controlador de animaciones para entrada escalonada
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animationController.forward();

    // Listeners para formateo automático
    _cardNumberController.addListener(_formatCardNumber);
    _expiryDateController.addListener(_formatExpiryDate);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderFocus.dispose();
    _cardNumberFocus.dispose();
    _expiryDateFocus.dispose();
    _cvvFocus.dispose();
    super.dispose();
  }

  // Formatea el número de tarjeta con espacios cada 4 dígitos
  void _formatCardNumber() {
    final text = _cardNumberController.text.replaceAll(' ', '');
    if (text.length > 16) {
      _cardNumberController.text = text.substring(0, 16);
      _cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: _cardNumberController.text.length),
      );
      return;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      final nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    if (formatted != _cardNumberController.text) {
      _cardNumberController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  // Formatea la fecha de expiración MM/AA
  void _formatExpiryDate() {
    final text = _expiryDateController.text.replaceAll('/', '');
    if (text.length > 4) {
      _expiryDateController.text = text.substring(0, 4);
      return;
    }

    if (text.length >= 2) {
      final formatted = '${text.substring(0, 2)}/${text.substring(2)}';
      if (formatted != _expiryDateController.text) {
        _expiryDateController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }
  }

  // Valida el titular de la tarjeta
  bool _validateCardHolder() {
    final value = _cardHolderController.text.trim();
    if (value.isEmpty) {
      setState(() {
        _cardHolderError = 'Ingrese el nombre del titular';
      });
      return false;
    }
    if (value.length < 3) {
      setState(() {
        _cardHolderError = 'Nombre muy corto';
      });
      return false;
    }
    setState(() {
      _cardHolderError = null;
    });
    return true;
  }

  // Valida el número de tarjeta (algoritmo de Luhn simplificado)
  bool _validateCardNumber() {
    final value = _cardNumberController.text.replaceAll(' ', '');
    if (value.isEmpty) {
      setState(() {
        _cardNumberError = 'Ingrese el número de tarjeta';
      });
      return false;
    }
    if (value.length != 16) {
      setState(() {
        _cardNumberError = 'Número de tarjeta incompleto';
      });
      return false;
    }
    setState(() {
      _cardNumberError = null;
    });
    return true;
  }

  // Valida la fecha de expiración
  bool _validateExpiryDate() {
    final value = _expiryDateController.text;
    if (value.isEmpty) {
      setState(() {
        _expiryDateError = 'Ingrese la fecha';
      });
      return false;
    }
    if (value.length != 5) {
      setState(() {
        _expiryDateError = 'Formato: MM/AA';
      });
      return false;
    }

    final parts = value.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || month < 1 || month > 12) {
      setState(() {
        _expiryDateError = 'Mes inválido';
      });
      return false;
    }

    // Valida que no esté vencida
    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;

    if (year! < currentYear || (year == currentYear && month < currentMonth)) {
      setState(() {
        _expiryDateError = 'Tarjeta vencida';
      });
      return false;
    }

    setState(() {
      _expiryDateError = null;
    });
    return true;
  }

  // Valida el CVV
  bool _validateCVV() {
    final value = _cvvController.text;
    if (value.isEmpty) {
      setState(() {
        _cvvError = 'Ingrese CVV';
      });
      return false;
    }
    if (value.length != 3) {
      setState(() {
        _cvvError = 'CVV incompleto';
      });
      return false;
    }
    setState(() {
      _cvvError = null;
    });
    return true;
  }

  // Procesa el pago validando todos los campos
  Future<void> _processPayment() async {
    // Cierra el teclado
    FocusScope.of(context).unfocus();

    // Valida todos los campos
    final isCardHolderValid = _validateCardHolder();
    final isCardNumberValid = _validateCardNumber();
    final isExpiryDateValid = _validateExpiryDate();
    final isCVVValid = _validateCVV();

    if (!isCardHolderValid ||
        !isCardNumberValid ||
        !isExpiryDateValid ||
        !isCVVValid) {
      // Muestra mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(
                Icons.error_outline_rounded,
                color: AppColors.backgroundWhite,
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'Por favor complete todos los campos',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simula procesamiento de pago (en producción sería llamada a API segura)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    // Navega a la pantalla de éxito
    _showSuccessDialog();
  }

  // Navega a la pantalla de éxito después de procesar el pago
  void _showSuccessDialog() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          paymentMethod: 'card',
          total: widget.total,
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
            'Pago con Tarjeta',
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
      body: GestureDetector(
        // Cierra el teclado al tocar fuera de los campos
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Título
              _AnimatedItem(
                controller: _animationController,
                delay: 0,
                child: const Text(
                  'Agregar Tarjeta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Ícono de tarjeta
              _AnimatedItem(
                controller: _animationController,
                delay: 100,
                child: _buildCardIcon(),
              ),

              const SizedBox(height: 32),

              // Titular de la tarjeta
              _AnimatedItem(
                controller: _animationController,
                delay: 200,
                child: _buildTextField(
                  controller: _cardHolderController,
                  focusNode: _cardHolderFocus,
                  label: 'Titular de la tarjeta',
                  hint: 'Nombre completo',
                  icon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  error: _cardHolderError,
                  onSubmitted: (_) => _cardNumberFocus.requestFocus(),
                ),
              ),

              const SizedBox(height: 20),

              // Número de tarjeta
              _AnimatedItem(
                controller: _animationController,
                delay: 300,
                child: _buildTextField(
                  controller: _cardNumberController,
                  focusNode: _cardNumberFocus,
                  label: 'Numero de Tarjeta',
                  hint: '0000 0000 0000 0000',
                  icon: Icons.credit_card_rounded,
                  keyboardType: TextInputType.number,
                  error: _cardNumberError,
                  onSubmitted: (_) => _expiryDateFocus.requestFocus(),
                ),
              ),

              const SizedBox(height: 20),

              // Fecha de expiración y CVV en una fila
              _AnimatedItem(
                controller: _animationController,
                delay: 400,
                child: Row(
                  children: [
                    // MM/AA
                    Expanded(
                      child: _buildTextField(
                        controller: _expiryDateController,
                        focusNode: _expiryDateFocus,
                        label: 'MM/AA',
                        hint: '12/25',
                        icon: Icons.calendar_today_rounded,
                        keyboardType: TextInputType.number,
                        error: _expiryDateError,
                        onSubmitted: (_) => _cvvFocus.requestFocus(),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // CVS
                    Expanded(
                      child: _buildTextField(
                        controller: _cvvController,
                        focusNode: _cvvFocus,
                        label: 'CVS',
                        hint: '123',
                        icon: Icons.lock_outline_rounded,
                        keyboardType: TextInputType.number,
                        error: _cvvError,
                        maxLength: 3,
                        obscureText: true,
                        onSubmitted: (_) => _processPayment(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Total a pagar
              _AnimatedItem(
                controller: _animationController,
                delay: 500,
                child: _buildTotalInfo(),
              ),

              const SizedBox(height: 24),

              // Botón Procesar Pago
              _AnimatedItem(
                controller: _animationController,
                delay: 600,
                child: _buildProcessButton(),
              ),

              const SizedBox(height: 24),

              // Información de seguridad
              _AnimatedItem(
                controller: _animationController,
                delay: 700,
                child: _buildSecurityInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ícono de tarjeta
  Widget _buildCardIcon() {
    return Center(
      child: Container(
        width: 200,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.lightGray.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.credit_card_rounded,
          size: 80,
          color: AppColors.textBlack.withOpacity(0.6),
        ),
      ),
    );
  }

  // Campo de texto personalizado con validación
  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    String? error,
    int? maxLength,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Function(String)? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          maxLength: maxLength,
          onSubmitted: onSubmitted,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon),
            errorText: error,
            counterText: '', // Oculta el contador de caracteres
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.lightGray.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.lightGray.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryRed,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Información del total a pagar
  Widget _buildTotalInfo() {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total a pagar:',
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
    );
  }

  // Botón Procesar Pago
  Widget _buildProcessButton() {
    return SizedBox(
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
                'Procesar Pago',
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

  // Información de seguridad
  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            color: Colors.green[700],
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tus datos están protegidos con encriptación SSL',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textBlack.withOpacity(0.7),
              ),
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

