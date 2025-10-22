import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

// Pantalla para cambiar la ubicación de entrega
// Permite buscar direcciones, ver ubicación en mapa y seleccionar direcciones guardadas
// Diseño enfocado en claridad y facilidad de uso
class ChangeLocationScreen extends StatefulWidget {
  final String currentAddress;

  const ChangeLocationScreen({
    super.key,
    this.currentAddress = 'Santa Cruz, calle 13',
  });

  @override
  State<ChangeLocationScreen> createState() => _ChangeLocationScreenState();
}

class _ChangeLocationScreenState extends State<ChangeLocationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();
  
  // Ubicación seleccionada
  String? _selectedLocation;
  String? _selectedAddress;

  // Ubicaciones guardadas
  final List<Map<String, dynamic>> _savedLocations = [
    {
      'name': 'Casa',
      'address': 'Av mariano calle 13',
      'icon': Icons.home_rounded,
    },
    {
      'name': 'UAGRM',
      'address': 'Modulo 2-6',
      'icon': Icons.location_city_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Controlador de animaciones para entrada escalonada
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animationController.forward();

    // Establecer la ubicación actual como seleccionada
    _selectedAddress = widget.currentAddress;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Guarda la ubicación y regresa a la pantalla anterior
  void _saveLocation() {
    if (_selectedAddress != null) {
      // En producción, aquí se guardaría en el state manager o backend
      Navigator.pop(context, _selectedAddress);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ubicación actualizada: $_selectedAddress',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Selecciona una ubicación guardada
  void _selectSavedLocation(String name, String address) {
    setState(() {
      _selectedLocation = name;
      _selectedAddress = address;
    });
  }

  // Abre el campo de búsqueda
  void _openSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de búsqueda de dirección'),
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
            'Cambiar Ubicacion',
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
          Column(
            children: [
              // Mapa
              _AnimatedItem(
                controller: _animationController,
                delay: 0,
                child: _buildMapSection(),
              ),

              // Barra de búsqueda
              _AnimatedItem(
                controller: _animationController,
                delay: 100,
                child: _buildSearchBar(),
              ),

              // Lista de ubicaciones guardadas
              Expanded(
                child: _AnimatedItem(
                  controller: _animationController,
                  delay: 200,
                  child: _buildSavedLocations(),
                ),
              ),
            ],
          ),

          // Botón flotante de guardar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _AnimatedItem(
              controller: _animationController,
              delay: 300,
              child: _buildSaveButton(),
            ),
          ),
        ],
      ),
    );
  }

  // Sección del mapa
  Widget _buildMapSection() {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.lightGray,
      ),
      child: Stack(
        children: [
          // Imagen del mapa
          Image.asset(
            'assets/images/map_route.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // Marcador central (ubicación seleccionada)
          Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRed.withOpacity(0.4),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: AppColors.backgroundWhite,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Barra de búsqueda de dirección
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: GestureDetector(
        onTap: _openSearch,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.lightGray.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: AppColors.textBlack.withOpacity(0.5),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Buscar dirección',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textBlack.withOpacity(0.5),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textBlack.withOpacity(0.3),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Lista de ubicaciones guardadas
  Widget _buildSavedLocations() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ubicaciones Guardadas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 12),

          // Lista de ubicaciones
          Expanded(
            child: ListView.builder(
              itemCount: _savedLocations.length,
              itemBuilder: (context, index) {
                final location = _savedLocations[index];
                final isSelected = _selectedLocation == location['name'];

                return _AnimatedItem(
                  controller: _animationController,
                  delay: 300 + (index * 80),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _LocationCard(
                      icon: location['icon'],
                      name: location['name'],
                      address: location['address'],
                      isSelected: isSelected,
                      onTap: () => _selectSavedLocation(
                        location['name'],
                        location['address'],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Botón de guardar ubicación
  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.only(
        left: AppConstants.defaultPadding,
        right: AppConstants.defaultPadding,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
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
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _selectedAddress != null ? _saveLocation : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            disabledBackgroundColor: AppColors.lightGray.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: const Text(
            'Guardar Ubicacion',
            style: TextStyle(
              color: AppColors.backgroundWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget para cada tarjeta de ubicación
class _LocationCard extends StatefulWidget {
  final IconData icon;
  final String name;
  final String address;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocationCard({
    required this.icon,
    required this.name,
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<_LocationCard> {
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
          padding: const EdgeInsets.all(14),
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
              // Ícono de la ubicación
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  color: AppColors.primaryRed,
                  size: 26,
                ),
              ),

              const SizedBox(width: 12),

              // Información de la ubicación
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: widget.isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.address,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textBlack.withOpacity(0.6),
                      ),
                    ),
                  ],
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

