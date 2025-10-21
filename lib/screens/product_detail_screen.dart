import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Pantalla de detalle del producto con toda la información
// Permite ver imágenes, agregar al carrito con cantidad personalizada y añadir notas
// Diseño enfocado en conversión y experiencia de usuario fluida
class ProductDetailScreen extends StatefulWidget {
  final String name;
  final double price;
  final double? originalPrice;
  final int? discount;
  final String? imagePath;
  final String? description;
  final String? category;
  final bool available;

  const ProductDetailScreen({
    super.key,
    required this.name,
    required this.price,
    this.originalPrice,
    this.discount,
    this.imagePath,
    this.description,
    this.category,
    this.available = true,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _notesController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();

  int _quantity = 1; // Cantidad de productos a agregar
  bool _isAddingToCart = false; // Estado de animación del botón

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
    // Limpia los controladores para liberar recursos
    _animationController.dispose();
    _notesController.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  // Incrementa la cantidad de productos
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  // Decrementa la cantidad (mínimo 1)
  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  // Agrega el producto al carrito con animación
  void _addToCart() {
    // Cierra el teclado si está abierto
    FocusScope.of(context).unfocus();

    setState(() {
      _isAddingToCart = true;
    });

    // Simula la acción de agregar al carrito
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });

        // Muestra confirmación y regresa a la pantalla anterior
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
                    '$_quantity x ${widget.name} agregado al carrito',
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

        // Regresa a la pantalla anterior después de un breve delay
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  // Calcula el total según la cantidad seleccionada
  double get _totalPrice => widget.price * _quantity;

  @override
  Widget build(BuildContext context) {
    // Detecta si el teclado está visible para ocultar el footer
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      resizeToAvoidBottomInset: true,  // El contenido se ajusta al teclado
      body: GestureDetector(
        // Cierra el teclado al tocar fuera del campo de texto
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            // Contenido principal con scroll
            CustomScrollView(
              slivers: [
              // Imagen del producto con Hero animation
              _buildImageHeader(),

              // Contenido del producto
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información principal del producto
                    _AnimatedItem(
                      controller: _animationController,
                      delay: 0,
                      child: _buildProductInfo(),
                    ),

                    const SizedBox(height: 20),

                    // Divisor visual entre secciones
                    _buildDivider(),

                    const SizedBox(height: 20),

                    // Descripción del producto
                    if (widget.description != null)
                      _AnimatedItem(
                        controller: _animationController,
                        delay: 100,
                        child: _buildDescription(),
                      ),

                    const SizedBox(height: 20),

                    // Divisor visual
                    _buildDivider(),

                    const SizedBox(height: 20),

                    // Campo de notas para instrucciones especiales
                    _AnimatedItem(
                      controller: _animationController,
                      delay: 200,
                      child: _buildNotesSection(),
                    ),

                    const SizedBox(height: 20),

                    // Divisor visual
                    _buildDivider(),

                    const SizedBox(height: 20),

                    // Información adicional (stock, categoría)
                    _AnimatedItem(
                      controller: _animationController,
                      delay: 300,
                      child: _buildAdditionalInfo(),
                    ),

                    // Espacio para el footer fijo o para el teclado
                    SizedBox(height: isKeyboardVisible ? 40 : 120),
                  ],
                ),
              ),
            ],
          ),

          // Botón flotante de agregar al carrito (se oculta cuando el teclado está visible)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            left: 0,
            right: 0,
            bottom: isKeyboardVisible ? -200 : 0,  // Se oculta cuando aparece el teclado
            child: _buildFooter(),
          ),

          // Botón de volver en la esquina superior izquierda
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: _buildBackButton(),
          ),
        ],
      ),
      ),
    );
  }

  // Construye la cabecera con la imagen del producto
  // Usa Hero animation para transición suave desde el card
  Widget _buildImageHeader() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: false,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.lightGray.withOpacity(0.3),
      flexibleSpace: FlexibleSpaceBar(
        background: widget.imagePath != null
            ? Hero(
                tag: 'product_${widget.name}', // Tag para Hero animation
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                  ),
                  child: Stack(
                    children: [
                      // Imagen del producto centrada
                      Center(
                        child: Image.asset(
                          widget.imagePath!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        ),
                      ),

                      // Gradiente sutil en la parte inferior
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.backgroundWhite,
                                AppColors.backgroundWhite.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  // Placeholder cuando no hay imagen
  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.lightGray.withOpacity(0.3),
      child: const Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 80,
          color: AppColors.lightGray,
        ),
      ),
    );
  }

  // Información principal: nombre, precio, descuento
  Widget _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categoría del producto
          if (widget.category != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.category!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryRed,
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Nombre del producto
          Text(
            widget.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 16),

          // Precio y descuento
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Precio actual
              Text(
                'Bs. ${widget.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(width: 12),

              // Precio original tachado
              if (widget.originalPrice != null &&
                  widget.originalPrice! > widget.price)
                Text(
                  'Bs. ${widget.originalPrice!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textBlack.withOpacity(0.5),
                    decoration: TextDecoration.lineThrough,
                    decorationColor: AppColors.textBlack.withOpacity(0.5),
                  ),
                ),

              const Spacer(),

              // Badge de descuento
              if (widget.discount != null && widget.discount! > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentYellow.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    '${widget.discount}% OFF',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Descripción del producto
  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descripción',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.description!,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textBlack.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Sección de notas para instrucciones especiales del cliente
  // Incluye botón "Listo" en el teclado para mejor UX
  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Notas para este producto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
              // Badge opcional indicando que el campo es opcional
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightGray.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Opcional',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'El restaurante intentará seguirlas cuando lo prepare',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textBlack.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 146, 146, 146).withOpacity(0.03),  // Fondo gris bajito visible
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.lightGray.withOpacity(0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: TextField(
              controller: _notesController,
              focusNode: _notesFocusNode,
              maxLines: 3,
              maxLength: 200,
              textInputAction: TextInputAction.done,  // Muestra botón "Listo"
              onEditingComplete: () {
                // Cierra el teclado al presionar "Listo"
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                hintText: 'Ej: Sin cebolla, bien cocido, etc.',
                hintStyle: TextStyle(
                  color: AppColors.textBlack.withOpacity(0.4),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
                // Ícono de lápiz para indicar que es editable
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8, top: 12),
                  child: Icon(
                    Icons.edit_note_rounded,
                    color: AppColors.textBlack.withOpacity(0.4),
                    size: 24,
                  ),
                ),
                filled: false,
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryRed,
                    width: 2,
                  ),
                ),
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                // Botón de limpiar cuando hay texto
                suffixIcon: _notesController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: AppColors.textBlack.withOpacity(0.4),
                        ),
                        onPressed: () {
                          setState(() {
                            _notesController.clear();
                          });
                        },
                      )
                    : null,
              ),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textBlack,
                height: 1.4,
              ),
              onChanged: (value) {
                // Actualiza para mostrar/ocultar el botón de clear
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  // Información adicional: disponibilidad, stock
  Widget _buildAdditionalInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.available
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.available
                ? Colors.green.withOpacity(0.3)
                : Colors.red.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              widget.available
                  ? Icons.check_circle_rounded
                  : Icons.cancel_rounded,
              color: widget.available ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.available ? 'Disponible' : 'Agotado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.available ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.available
                        ? 'Este producto está en stock'
                        : 'Este producto no está disponible actualmente',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textBlack.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Footer fijo con contador y botón de agregar al carrito
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
      child: Row(
        children: [
          // Contador de cantidad
          _buildQuantityCounter(),

          const SizedBox(width: 16),

          // Botón de agregar al carrito
          Expanded(
            child: _buildAddButton(),
          ),
        ],
      ),
    );
  }

  // Contador interactivo de cantidad con botones +/-
  Widget _buildQuantityCounter() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Botón decrementar
          _QuantityButton(
            icon: Icons.remove_rounded,
            onPressed: _decrementQuantity,
            enabled: _quantity > 1,
          ),

          // Cantidad actual
          Container(
            width: 50,
            alignment: Alignment.center,
            child: Text(
              '$_quantity',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ),

          // Botón incrementar
          _QuantityButton(
            icon: Icons.add_rounded,
            onPressed: _incrementQuantity,
            enabled: true,
          ),
        ],
      ),
    );
  }

  // Botón principal para agregar al carrito
  // Muestra el total dinámico y tiene animación de carga
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: widget.available && !_isAddingToCart ? _addToCart : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: widget.available
              ? (_isAddingToCart ? Colors.green : AppColors.primaryRed)
              : AppColors.lightGray,
          borderRadius: BorderRadius.circular(12),
          boxShadow: widget.available && !_isAddingToCart
              ? [
                  BoxShadow(
                    color: AppColors.primaryRed.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isAddingToCart
                  ? Icons.check_circle_rounded
                  : Icons.shopping_cart_rounded,
              color: AppColors.backgroundWhite,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              _isAddingToCart
                  ? 'Agregado'
                  : 'AGREGAR Bs. ${_totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.backgroundWhite,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Botón de volver con fondo translúcido
  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.textBlack,
          size: 24,
        ),
      ),
    );
  }

  // Divisor visual sutil entre secciones
  // Mejora la organización visual sin ser intrusivo
  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.lightGray.withOpacity(0.0),
            AppColors.lightGray.withOpacity(0.3),
            AppColors.lightGray.withOpacity(0.0),
          ],
        ),
      ),
    );
  }
}

// Botón para incrementar/decrementar cantidad
// Con animación de press y estado deshabilitado
class _QuantityButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  const _QuantityButton({
    required this.icon,
    required this.onPressed,
    required this.enabled,
  });

  @override
  State<_QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<_QuantityButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.enabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed();
            }
          : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: widget.enabled
                ? AppColors.primaryRed
                : AppColors.lightGray.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            widget.icon,
            color: AppColors.backgroundWhite,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// Widget para animar la entrada de cada sección con efecto escalonado
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

