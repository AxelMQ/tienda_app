import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_navigation.dart';
import 'offers_screen.dart';
import 'orders_screen.dart';

// Pantalla de perfil del usuario
// Muestra información personal y opciones de cuenta
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3; // Perfil es el índice 3

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: const CustomAppBar(
        cartItemCount: 3,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar del usuario
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryRed.withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.person_rounded,
                size: 60,
                color: AppColors.primaryRed,
              ),
            ),
            const SizedBox(height: 24),
            
            // Nombre de usuario
            const Text(
              'Usuario Demo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 8),
            
            // Email
            Text(
              'usuario@lacanasta.com',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textGray,
              ),
            ),
            const SizedBox(height: 32),
            
            // Opciones de perfil
            _buildProfileOption(
              icon: Icons.settings_rounded,
              label: 'Configuración',
              color: AppColors.primaryRed,
            ),
            const SizedBox(height: 12),
            _buildProfileOption(
              icon: Icons.favorite_rounded,
              label: 'Mis Favoritos',
              color: Colors.pink,
            ),
            const SizedBox(height: 12),
            _buildProfileOption(
              icon: Icons.help_rounded,
              label: 'Ayuda',
              color: Colors.blue,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 3) return; // Ya estamos en Perfil
          
          setState(() => _currentIndex = index);
          
          // Navegar según el índice
          switch (index) {
            case 0:
              Navigator.of(context).pop(); // Volver a Home
              break;
            case 1:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const OffersScreen()),
              );
              break;
            case 2:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const OrdersScreen()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textBlack,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: color.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

