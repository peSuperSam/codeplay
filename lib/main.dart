import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/utils/error_handler.dart';
import 'presentation/app.dart';

void main() {
  // Capturador de erros não tratados
  runZonedGuarded(
    () async {
      // Configurações de inicialização
      WidgetsFlutterBinding.ensureInitialized();

      // Força orientação retrato para melhor experiência
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Define a cor da UI da barra de status
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      );

      // Provedor global com observador de erros
      final providerContainer = ProviderContainer(
        observers: [ProviderLogger()],
      );

      runApp(
        UncontrolledProviderScope(
          container: providerContainer,
          child: const App(),
        ),
      );
    },
    (error, stack) {
      // Log de erros globais não tratados
      ErrorHandler.logError(error, stack);
    },
  );
}

/// Logger para monitorar mudanças nos providers
class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint('[${provider.name ?? provider.runtimeType}] value: $newValue');
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    debugPrint(
      '[${provider.name ?? provider.runtimeType}] initialized: $value',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    debugPrint('[${provider.name ?? provider.runtimeType}] disposed');
  }
}
