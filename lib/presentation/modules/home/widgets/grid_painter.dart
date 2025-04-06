import 'package:flutter/material.dart';

/// Classe para desenhar uma grade de linhas estilo Tron
class GridPainter extends CustomPainter {
  final Color lineColor;
  final double gridSpacing;

  GridPainter({required this.lineColor, required this.gridSpacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = lineColor
          ..strokeWidth = 0.5;

    // Desenhar linhas horizontais
    for (double y = 0; y <= size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Desenhar linhas verticais
    for (double x = 0; x <= size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.gridSpacing != gridSpacing;
  }
}
