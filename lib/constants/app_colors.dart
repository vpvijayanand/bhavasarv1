import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF8B4513); // Saddle Brown - representing heritage
  static const Color primaryDark = Color(0xFF5D2F0A);
  static const Color secondary = Color(0xFFFF6B35); // Orange Red - vibrant accent
  static const Color accent = Color(0xFFFFD700); // Gold - representing prosperity

  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF4CAF50);

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Colors.white;

  static const Color divider = Color(0xFFBDBDBD);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [secondary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}