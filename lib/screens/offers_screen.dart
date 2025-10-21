import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/page_transitions.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_navigation.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

// Pantalla de ofertas especiales
// Muestra productos en promoción y descuentos activos
class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  int _currentIndex = 1; // Ofertas es el índice 1

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
            // Ícono grande de ofertas
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.accentYellow.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_offer_rounded,
                size: 80,
                color: AppColors.primaryRed,
              ),
            ),
            const SizedBox(height: 24),
            
            // Título
            const Text(
              '¡Ofertas Especiales!',
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
                'Aquí encontrarás las mejores promociones y descuentos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textGray,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Badge de descuento
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                'Hasta 50% OFF',
                style: TextStyle(
                  color: AppColors.backgroundWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) return; // Ya estamos en Ofertas
          
          setState(() => _currentIndex = index);
          
          // Navegación con transición de fade rápida para mejor UX
          switch (index) {
            case 0:
              Navigator.of(context).pop(); // Volver a Home
              break;
            case 2:
              Navigator.of(context).pushReplacement(
                PageTransitions.fadeTransition(const OrdersScreen()),
              );
              break;
            case 3:
              Navigator.of(context).pushReplacement(
                PageTransitions.fadeTransition(const ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}

