import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_navigation.dart';
import 'offers_screen.dart';
import 'profile_screen.dart';

// Pantalla de pedidos
// Muestra el historial de compras del usuario
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _currentIndex = 2; // Pedidos es el índice 2

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
            // Ícono grande de pedidos
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 80,
                color: AppColors.primaryRed,
              ),
            ),
            const SizedBox(height: 24),
            
            // Título
            const Text(
              'Mis Pedidos',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 12),
            
            // Descripción
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Revisa el estado de tus compras y pedidos anteriores',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textGray,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Estado
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatusBadge('En camino', Icons.local_shipping_rounded, AppColors.accentYellow),
                const SizedBox(width: 12),
                _buildStatusBadge('Entregados', Icons.check_circle_rounded, Colors.green),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) return; // Ya estamos en Pedidos
          
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
            case 3:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildStatusBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

