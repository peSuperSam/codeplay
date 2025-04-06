import 'dart:ui';
import 'package:flutter/material.dart';

/// Utilidades para criação de interfaces com efeito glassmorphism
class GlassUtils {
  /// Cria um card com efeito de vidro (glassmorphism)
  static Widget buildGlassCard({
    required Widget child,
    Color? backgroundColor,
    Color? borderColor,
    double borderRadius = 24,
    double padding = 24,
    double borderWidth = 2,
    double blurSigma = 10,
    List<BoxShadow>? shadows,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.blue.shade900.withAlpha(77),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.blue.shade200.withAlpha(51),
              width: borderWidth,
            ),
            boxShadow:
                shadows ??
                [
                  BoxShadow(
                    color: Colors.black.withAlpha(77),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
          ),
          child: child,
        ),
      ),
    );
  }

  /// Cria uma AppBar com efeito de vidro (glassmorphism)
  static PreferredSizeWidget buildGlassAppBar({
    required String title,
    required BuildContext context,
    List<Widget>? actions,
    Widget? leading,
    double blurSigma = 10,
    TextStyle? titleStyle,
  }) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Text(title, style: titleStyle),
      leading: leading,
      actions: actions,
    );
  }
}
