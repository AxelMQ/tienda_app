import 'package:flutter/material.dart';

/// Paleta de colores de la aplicación Tienda App
class AppColors {
  // Colores principales
  static const Color primaryRed = Color(0xFFE53E3E);
  static const Color secondaryRed = Color(0xFFC53030);
  static const Color darkRed = Color(0xFF9B2C2C);
  
  // Colores de fondo
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF7FAFC);
  static const Color mediumGray = Color(0xFFE2E8F0);
  
  // Colores de texto
  static const Color textBlack = Color(0xFF2D3748);
  static const Color textDarkGray = Color(0xFF4A5568);
  static const Color textLightGray = Color(0xFF718096);
  
  // Colores de acento
  static const Color accentYellow = Color(0xFFFFD700);
  static const Color discountYellow = Color(0xFFFFF700);
  
  // Colores de estado
  static const Color successGreen = Color(0xFF38A169);
  static const Color warningOrange = Color(0xFFED8936);
  static const Color errorRed = Color(0xFFE53E3E);
  
  // Colores de navegación
  static const Color navBackground = Color(0xFFE53E3E);
  static const Color navIcon = Color(0xFFFFFFFF);
  static const Color navIconActive = Color(0xFFFFFFFF);
  
  // Colores de cards
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);
  
  // Colores de botones
  static const Color buttonPrimary = Color(0xFFE53E3E);
  static const Color buttonSecondary = Color(0xFFF7FAFC);
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color buttonTextSecondary = Color(0xFF2D3748);
}

/// Gradientes utilizados en la aplicación
class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryRed,
      AppColors.secondaryRed,
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.backgroundWhite,
      AppColors.lightGray,
    ],
  );
}
