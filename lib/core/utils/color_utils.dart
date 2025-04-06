import 'package:flutter/material.dart';
import 'dart:math';

/// Classe utilitária para manipulação de cores RGB.
class ColorUtils {
  /// Converte componentes R, G, B em um objeto Color.
  static Color fromRGB(int r, int g, int b) {
    // Garantindo que os valores estão no intervalo de 0-255
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return Color.fromRGBO(r, g, b, 1.0);
  }

  /// Extrai os componentes R, G, B de um objeto Color.
  static Map<String, int> toRGB(Color color) {
    return {'r': color.r.toInt(), 'g': color.g.toInt(), 'b': color.b.toInt()};
  }

  /// Gera uma cor aleatória.
  static Color randomColor({Random? random}) {
    random ??= Random();

    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  /// Calcula a diferença entre duas cores (distância euclidiana no espaço RGB).
  static double colorDistance(Color a, Color b) {
    final dr = a.r - b.r;
    final dg = a.g - b.g;
    final db = a.b - b.b;

    return sqrt(dr * dr + dg * dg + db * db);
  }

  /// Converte uma cor para sua representação hexadecimal.
  static String toHex(Color color) {
    return '#${color.r.toInt().toRadixString(16).padLeft(2, '0')}'
        '${color.g.toInt().toRadixString(16).padLeft(2, '0')}'
        '${color.b.toInt().toRadixString(16).padLeft(2, '0')}';
  }

  /// Converte um valor hexadecimal para um objeto Color.
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Retorna uma cor mais clara.
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Retorna uma cor mais escura.
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Verifica se uma cor é considerada clara.
  static bool isLight(Color color) {
    // Fórmula de luminância relativa
    return color.computeLuminance() > 0.5;
  }

  /// Retorna texto em preto ou branco, dependendo da cor de fundo.
  static Color contrastingTextColor(Color backgroundColor) {
    return isLight(backgroundColor) ? Colors.black : Colors.white;
  }

  /// Gera uma cor de um nível de dificuldade (fácil: verde, médio: amarelo, difícil: vermelho).
  static Color difficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
      case 5:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
