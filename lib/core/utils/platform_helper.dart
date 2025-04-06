import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Classe utilitária para verificar e lidar com diferentes plataformas.
class PlatformHelper {
  /// Verifica se a aplicação está rodando na Web.
  static bool get isWeb => kIsWeb;

  /// Verifica se a aplicação está rodando em dispositivo móvel (Android ou iOS).
  static bool get isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Verifica se a aplicação está rodando em Android.
  static bool get isAndroid {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  /// Verifica se a aplicação está rodando em iOS.
  static bool get isIOS {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  /// Verifica se a aplicação está rodando em desktop (Windows, macOS, Linux).
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Verifica se a aplicação está rodando em Windows.
  static bool get isWindows {
    if (kIsWeb) return false;
    return Platform.isWindows;
  }

  /// Verifica se a aplicação está rodando em macOS.
  static bool get isMacOS {
    if (kIsWeb) return false;
    return Platform.isMacOS;
  }

  /// Verifica se a aplicação está rodando em Linux.
  static bool get isLinux {
    if (kIsWeb) return false;
    return Platform.isLinux;
  }

  /// Verifica se o dispositivo tem uma câmera disponível.
  static Future<bool> hasCamera() async {
    if (kIsWeb) {
      // Na web, a disponibilidade da câmera varia e depende das permissões
      return true; // Assumir disponível, verificação será feita em runtime
    }

    if (Platform.isAndroid || Platform.isIOS) {
      // Em dispositivos móveis, a maioria tem câmera
      return true;
    }

    // Em desktop, assume que não há câmera
    return false;
  }

  /// Obtém um identificador de plataforma legível.
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isFuchsia) return 'Fuchsia';
    return 'Unknown';
  }
}
