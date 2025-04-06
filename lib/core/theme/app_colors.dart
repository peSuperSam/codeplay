import 'package:flutter/material.dart';

class AppColors {
  // Cores primárias
  static const Color primaryColor = Color(0xFF3F51B5);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color tertiaryColor = Color(0xFFFF5722);

  // Cores de fundo
  static const Color lightBackgroundColor = Color(0xFF050A30);
  static const Color darkBackgroundColor = Color(0xFF000000);

  // Cores para modules
  static const Color binaryModuleColor = Color(0xFF2196F3);
  static const Color asciiModuleColor = Color(0xFF9C27B0);
  static const Color rgbModuleColor = Color(0xFF4CAF50);

  // Esquemas de cores
  static final ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: secondaryColor,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    surface: lightBackgroundColor,
    onSurface: Colors.white,
    surfaceTint: Colors.white.withAlpha(30),
  );

  static final ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: secondaryColor,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    surface: darkBackgroundColor,
    onSurface: Colors.white,
    surfaceTint: const Color(0xFF121212),
  );

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF050A30), Color(0xFF000C66), Color(0xFF0000FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Cores RGB
  static const Color rgbRed = Color(0xFFFF0000);
  static const Color rgbGreen = Color(0xFF00FF00);
  static const Color rgbBlue = Color(0xFF0000FF);
}
