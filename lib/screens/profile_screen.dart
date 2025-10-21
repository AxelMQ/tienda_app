import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/page_transitions.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/pressable_card.dart';
import '../widgets/pressable_icon_button.dart';
import 'offers_screen.dart';
import 'orders_screen.dart';

// Pantalla de perfil y configuración del usuario
// No requiere login, enfocada en preferencias de compra y configuración
// Diseño minimalista con cards agrupadas por categoría
// Incluye animaciones de entrada y feedback táctil profesional
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 3; // Perfil es el índice 3
  int _cartItemCount = 3; // Contador de items en el carrito

  // Configuraciones guardadas localmente (en producción serían SharedPreferences)
  bool _notificationsEnabled = true;
  bool _cartRemindersEnabled = false;
  bool _onlyInStock = true;
  String _selectedPaymentMethod = 'Efectivo';

  // Controlador para las animaciones de entrada
  late AnimationController _animationController;

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
    // Limpia el controlador para liberar recursos
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomAppBar(
        cartItemCount: _cartItemCount,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // Scroll más natural en iOS/Android
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.defaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera con avatar y datos del usuario - aparece primero
            _AnimatedItem(
              controller: _animationController,
              delay: 0,
              child: _buildUserHeader(),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Sección: Mis Datos de Entrega
            _AnimatedItem(
              controller: _animationController,
              delay: 100,
              child: _buildSectionTitle('📍 Mis Datos de Entrega'),
            ),
            const SizedBox(height: 12),
            _AnimatedItem(
              controller: _animationController,
              delay: 150,
              child: _buildDeliveryAddresses(),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Sección: Configuración de Compras
            _AnimatedItem(
              controller: _animationController,
              delay: 200,
              child: _buildSectionTitle('🛒 Configuración de Compras'),
            ),
            const SizedBox(height: 12),
            _AnimatedItem(
              controller: _animationController,
              delay: 250,
              child: _buildShoppingSettings(),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Sección: Preferencias de App
            _AnimatedItem(
              controller: _animationController,
              delay: 300,
              child: _buildSectionTitle('⚙️ Preferencias de App'),
            ),
            const SizedBox(height: 12),
            _AnimatedItem(
              controller: _animationController,
              delay: 350,
              child: _buildAppPreferences(),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Sección: Información y Ayuda
            _AnimatedItem(
              controller: _animationController,
              delay: 400,
              child: _buildSectionTitle('ℹ️ Información y Ayuda'),
            ),
            const SizedBox(height: 12),
            _AnimatedItem(
              controller: _animationController,
              delay: 450,
              child: _buildInfoSection(),
            ),

            // Espacio para el bottom navigation
            const SizedBox(height: AppConstants.bottomNavHeight + 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 3) return; // Ya estamos en Perfil
          
          setState(() => _currentIndex = index);
          
          // Navegación con transición de fade para mejor UX
          switch (index) {
            case 0:
              Navigator.of(context).pop(); // Volver a Home
              break;
            case 1:
              Navigator.of(context).pushReplacement(
                PageTransitions.fadeTransition(const OffersScreen()),
              );
              break;
            case 2:
              Navigator.of(context).pushReplacement(
                PageTransitions.fadeTransition(const OrdersScreen()),
              );
              break;
          }
        },
      ),
    );
  }

  // Construye la cabecera con avatar, nombre y badge animado
  // Usa gradiente de marca para destacar la identidad del usuario
  Widget _buildUserHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryRed,
            AppColors.primaryRed.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar circular con iniciales del usuario
          // En producción mostraría foto de perfil
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.backgroundWhite.withOpacity(0.5),
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                'UI',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Información del usuario con badge animado
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Usuario Invitado',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundWhite,
                  ),
                ),
                const SizedBox(height: 6),
                
                // Badge con animación de pulso para destacar el estatus
                const _PulsingBadge(),
              ],
            ),
          ),

          // Botón de editar con feedback visual
          PressableIconButton(
            icon: Icons.edit_rounded,
            onPressed: () => _showSnackBar('Editar perfil'),
            backgroundColor: AppColors.backgroundWhite.withOpacity(0.2),
            iconColor: AppColors.backgroundWhite,
          ),
        ],
      ),
    );
  }

  // Título de sección con estilo consistente
  // Usa emojis para mejor reconocimiento visual rápido
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textBlack,
        letterSpacing: 0.3,
      ),
    );
  }

  // Sección de direcciones de entrega guardadas
  // Permite al usuario gestionar múltiples direcciones
  Widget _buildDeliveryAddresses() {
    return Column(
      children: [
        // Dirección principal marcada con check verde
        _buildOptionCard(
          icon: Icons.home_rounded,
          iconColor: AppColors.primaryRed,
          title: 'Casa',
          subtitle: 'Av. Principal #123, Zona Centro',
          trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
          onTap: () => _showSnackBar('Dirección principal'),
        ),

        const SizedBox(height: 8),

        // Botón para agregar nueva dirección
        // Facilita la gestión de múltiples puntos de entrega
        _buildOptionCard(
          icon: Icons.add_location_rounded,
          iconColor: AppColors.textBlack.withOpacity(0.6),
          title: 'Agregar nueva dirección',
          subtitle: 'Para entregas más rápidas',
          onTap: () => _showSnackBar('Agregar dirección'),
        ),
      ],
    );
  }

  // Sección de configuración de compras con switches interactivos
  // Permite personalizar la experiencia de compra del usuario
  Widget _buildShoppingSettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightGray.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Notificaciones de ofertas
          // Mantiene al usuario informado de descuentos
          _buildSwitchTile(
            icon: Icons.notifications_active_rounded,
            iconColor: AppColors.accentYellow,
            title: 'Notificaciones de ofertas',
            subtitle: 'Recibe alertas de descuentos',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              _showSnackBar(value ? 'Notificaciones activadas' : 'Notificaciones desactivadas');
            },
          ),

          Divider(height: 1, color: AppColors.lightGray.withOpacity(0.3)),

          // Recordatorios de carrito abandonado
          // Ayuda a recuperar ventas perdidas
          _buildSwitchTile(
            icon: Icons.shopping_cart_rounded,
            iconColor: AppColors.primaryRed,
            title: 'Recordatorios de carrito',
            subtitle: 'Si dejaste productos en el carrito',
            value: _cartRemindersEnabled,
            onChanged: (value) {
              setState(() => _cartRemindersEnabled = value);
              _showSnackBar(value ? 'Recordatorios activados' : 'Recordatorios desactivados');
            },
          ),

          Divider(height: 1, color: AppColors.lightGray.withOpacity(0.3)),

          // Método de pago preferido
          // Agiliza el proceso de checkout
          _buildPaymentMethod(),
        ],
      ),
    );
  }

  // Sección de preferencias de la aplicación
  // Personaliza la visualización de productos
  Widget _buildAppPreferences() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightGray.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Filtro de productos en stock
          // Evita frustración al usuario mostrando solo disponibles
          _buildSwitchTile(
            icon: Icons.inventory_rounded,
            iconColor: Colors.green,
            title: 'Solo productos en stock',
            subtitle: 'Ocultar productos agotados',
            value: _onlyInStock,
            onChanged: (value) {
              setState(() => _onlyInStock = value);
              _showSnackBar(value ? 'Mostrando solo en stock' : 'Mostrando todos');
            },
          ),

          Divider(height: 1, color: AppColors.lightGray.withOpacity(0.3)),

          // Criterio de ordenamiento de productos
          // Permite al usuario encontrar lo que busca más rápido
          _buildSimpleTile(
            icon: Icons.sort_rounded,
            iconColor: Colors.blue,
            title: 'Ordenar productos por',
            subtitle: 'Precio (menor a mayor)',
            onTap: () => _showSnackBar('Cambiar orden'),
          ),
        ],
      ),
    );
  }

  // Sección de información y ayuda
  // Proporciona acceso a soporte y documentación legal
  Widget _buildInfoSection() {
    return Column(
      children: [
        _buildOptionCard(
          icon: Icons.help_center_rounded,
          iconColor: Colors.blue,
          title: 'Centro de ayuda',
          subtitle: 'Preguntas frecuentes y soporte',
          onTap: () => _showSnackBar('Centro de ayuda'),
        ),

        const SizedBox(height: 8),

        _buildOptionCard(
          icon: Icons.description_rounded,
          iconColor: AppColors.textBlack.withOpacity(0.6),
          title: 'Términos y condiciones',
          subtitle: 'Políticas de uso',
          onTap: () => _showSnackBar('Términos y condiciones'),
        ),

        const SizedBox(height: 8),

        _buildOptionCard(
          icon: Icons.info_rounded,
          iconColor: AppColors.primaryRed,
          title: 'Acerca de La Canasta',
          subtitle: 'Versión 1.0.0',
          onTap: () => _showSnackBar('Acerca de'),
        ),

        const SizedBox(height: 8),

        _buildOptionCard(
          icon: Icons.share_rounded,
          iconColor: Colors.green,
          title: 'Compartir app',
          subtitle: 'Invita a tus amigos',
          onTap: () => _showSnackBar('Compartir'),
        ),
      ],
    );
  }

  // Card de opción clickeable con feedback táctil
  // Usa AnimatedScale para indicar al usuario que la interacción fue detectada
  Widget _buildOptionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return PressableCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.lightGray.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withOpacity(0.08),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono con fondo de color para mejor jerarquía visual
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),

            const SizedBox(width: 14),

            // Textos con contraste adecuado
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textBlack.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Trailing (flecha o check) indica que es clickeable
            trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.textBlack.withOpacity(0.3),
                ),
          ],
        ),
      ),
    );
  }

  // Tile con switch animado
  // Switch nativo de Flutter con colores de marca
  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Icono con fondo de color
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),

          const SizedBox(width: 12),

          // Textos descriptivos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textBlack.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Switch con animación nativa
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryRed,
            activeTrackColor: AppColors.primaryRed.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  // Tile simple sin switch
  // Para opciones que abren un modal o pantalla nueva
  Widget _buildSimpleTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icono con fondo de color
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),

            const SizedBox(width: 12),

            // Textos descriptivos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textBlack.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Flecha indica más contenido
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textBlack.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  // Selector de método de pago
  // En producción abriría un modal con todas las opciones
  Widget _buildPaymentMethod() {
    return InkWell(
      onTap: () => _showSnackBar('Cambiar método de pago'),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icono con fondo de color
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.payment_rounded, size: 20, color: Colors.green),
            ),

            const SizedBox(width: 12),

            // Textos descriptivos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Método de pago preferido',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _selectedPaymentMethod,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textBlack.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Flecha indica más opciones disponibles
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textBlack.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  // Muestra mensajes de confirmación al usuario
  // Feedback inmediato para mejorar la percepción de respuesta
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
        margin: const EdgeInsets.only(
          bottom: AppConstants.bottomNavHeight + 10,
          left: 16,
          right: 16,
        ),
      ),
    );
  }
}

// Widget para animar la entrada de cada sección con efecto escalonado
// Los items aparecen uno por uno de arriba hacia abajo con fade y slide
class _AnimatedItem extends StatelessWidget {
  final AnimationController controller;
  final int delay; // Delay en milisegundos
  final Widget child;

  const _AnimatedItem({
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula el inicio de la animación según el delay
    final double start = delay / 800; // 800ms es la duración total
    
    // Animación de opacidad
    final Animation<double> fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, 1.0, curve: Curves.easeOut),
      ),
    );

    // Animación de desplazamiento vertical
    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
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

// Badge con animación de pulso continua
// Llama la atención sobre el estatus del usuario
class _PulsingBadge extends StatefulWidget {
  const _PulsingBadge();

  @override
  State<_PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<_PulsingBadge>
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
      end: 1.05, // Crece 5% sutilmente
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
          color: AppColors.accentYellow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.star_rounded,
              size: 14,
              color: AppColors.textBlack,
            ),
            SizedBox(width: 4),
            Text(
              'Cliente Frecuente',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

