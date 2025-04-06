import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Estilo para títulos
  static TextStyle get headingStyle => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Estilo para subtítulos
  static TextStyle get subheadingStyle => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Estilo para corpo do texto
  static TextStyle get bodyStyle => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  // Estilo para texto pequeno
  static TextStyle get smallStyle => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  // Estilo para botões
  static TextStyle get buttonStyle => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Estilo para código
  static TextStyle get codeStyle => GoogleFonts.firaCode(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  // Estilo para mensagens informativas
  static TextStyle get infoStyle => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    color: Colors.white70,
  );

  // Tema de texto completo
  static TextTheme get textTheme => TextTheme(
    displayLarge: headingStyle,
    displayMedium: subheadingStyle,
    bodyLarge: bodyStyle,
    bodyMedium: smallStyle,
    labelLarge: buttonStyle,
  );
}
