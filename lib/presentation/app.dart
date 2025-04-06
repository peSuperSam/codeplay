import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/routes/app_router.dart';
import '../core/constants/app_constants.dart';

/// Provider para controlar o tema da aplicação
final themeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

/// Classe principal da aplicação.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,

      // Configuração de localização
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'), // Fallback para inglês
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Configurações adicionais para a acessibilidade
      scrollBehavior: const MaterialScrollBehavior().copyWith(scrollbars: true),
    );
  }
}
