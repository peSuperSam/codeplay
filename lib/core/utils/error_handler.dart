import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Classe utilitária para lidar com erros na aplicação.
class ErrorHandler {
  /// Exibe uma mensagem de erro em um SnackBar.
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Exibe um diálogo de erro com opção de tentar novamente.
  static Future<bool> showErrorDialog(
    BuildContext context,
    String title,
    String message, {
    String? retryText,
    String? cancelText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              if (cancelText != null)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(cancelText),
                ),
              if (retryText != null)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(retryText),
                ),
            ],
          ),
    );
    return result ?? false;
  }

  /// Processa o erro e retorna uma mensagem amigável.
  static String getErrorMessage(dynamic error) {
    if (error is Exception) {
      // Tratamento específico por tipo de exception
      return _getExceptionMessage(error);
    } else {
      return AppConstants.generalErrorMessage;
    }
  }

  /// Retorna mensagem específica para cada tipo de exception.
  static String _getExceptionMessage(Exception exception) {
    // Aqui podem ser adicionados casos específicos para cada tipo de Exception
    if (exception.toString().contains('SocketException') ||
        exception.toString().contains('HttpException')) {
      return AppConstants.connectionErrorMessage;
    } else if (exception.toString().contains('FormatException')) {
      return AppConstants.invalidInputMessage;
    } else {
      return AppConstants.generalErrorMessage;
    }
  }

  /// Reporta o erro para um serviço de logging (a ser implementado).
  static void logError(dynamic error, StackTrace? stackTrace) {
    // Implementação futura para logging de erros
    debugPrint('ERROR: ${error.toString()}');
    if (stackTrace != null) {
      debugPrint('STACKTRACE: ${stackTrace.toString()}');
    }
  }
}
