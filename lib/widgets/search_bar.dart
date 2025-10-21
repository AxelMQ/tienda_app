import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Barra de búsqueda con animaciones y feedback visual
// Cambia de color al tener focus y muestra el botón clear solo cuando hay texto
class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool enabled;

  const CustomSearchBar({
    super.key,
    this.hintText = AppConstants.searchHint,
    this.controller,
    this.onChanged,
    this.onTap,
    this.enabled = true,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    // Si el padre nos da un controller, usamos ese; si no, creamos uno
    _controller = widget.controller ?? TextEditingController();
    
    // Nos suscribimos a los cambios del texto para mostrar el botón X solo cuando hay algo escrito
    _controller.addListener(_onTextChanged);
    
    // También nos suscribimos al focus para las animaciones de borde y sombra
    _focusNode.addListener(_onFocusChanged);
    
    // Revisamos si ya viene con texto desde el inicio
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void didUpdateWidget(CustomSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el controller cambió desde el padre, actualizar nuestro controller
    if (widget.controller != oldWidget.controller) {
      // Remover listener del controller anterior
      _controller.removeListener(_onTextChanged);
      
      // Actualizar al nuevo controller
      if (oldWidget.controller == null && _controller != widget.controller) {
        _controller.dispose();
      }
      
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_onTextChanged);
      _hasText = _controller.text.isNotEmpty;
    }
  }

  @override
  void dispose() {
    // Limpiar listeners para evitar fugas de memoria
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    // Solo hacer dispose del controller si lo creamos nosotros
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // Cuando el usuario escribe o borra texto, actualizamos si debe aparecer el botón X
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  void _onFocusChanged() {
    // Cuando el usuario toca o sale del campo, cambiamos los colores del borde
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
    // Dejamos el cursor activo para que pueda seguir escribiendo
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // El contenedor se anima suavemente cuando cambia el focus
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      height: AppConstants.searchBarHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        // El borde cambia de color cuando tiene focus (sutil pero visible)
        border: Border.all(
          color: _hasFocus 
              ? AppColors.secondaryRed 
              : AppColors.mediumGray,
          width: _hasFocus ? 2 : 1,
        ),
        // La sombra es más pronunciada con focus para dar profundidad
        boxShadow: [
          BoxShadow(
            color: _hasFocus 
                ? AppColors.secondaryRed.withOpacity(0.15)
                : AppColors.cardShadow,
            offset: Offset(0, _hasFocus ? 2 : 1),
            blurRadius: _hasFocus ? 6 : 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        enabled: widget.enabled,
        // El teclado muestra el botón de búsqueda en lugar de Enter
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AppColors.textLightGray,
            fontSize: 16,
          ),
          // Ícono de búsqueda que cambia de color cuando está activo
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _hasFocus 
                ? AppColors.secondaryRed 
                : AppColors.textLightGray,
            size: 22,
          ),
          // Botón X que aparece solo cuando hay algo escrito
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.textLightGray,
                    size: 20,
                  ),
                  onPressed: _clearText,
                  // Ayuda a usuarios con lectores de pantalla
                  tooltip: 'Limpiar búsqueda',
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
        ),
        style: const TextStyle(
          color: AppColors.textBlack,
          fontSize: 16,
        ),
      ),
    );
  }
}
