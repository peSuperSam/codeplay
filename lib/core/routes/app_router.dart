import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/modules/home/home_screen.dart';
import '../../presentation/modules/config/sobre_screen.dart';
import '../../presentation/modules/ascii/ascii_screen.dart';
import '../../presentation/modules/ascii/screens/ascii_table_screen.dart';
import '../../presentation/modules/binario/binario_screen.dart';
import '../../presentation/modules/binario/screens/binary_table_screen.dart';
import '../constants/app_constants.dart';

/// Define o roteamento da aplicação usando GoRouter.
class AppRouter {
  /// Obtém a configuração do router.
  static final router = GoRouter(
    initialLocation: AppConstants.homeRoute,
    errorBuilder: (context, state) => _errorScreen(context, state),
    routes: [
      GoRoute(
        path: AppConstants.homeRoute,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppConstants.configRoute,
        name: 'config',
        builder: (context, state) => const SobreScreen(),
      ),
      GoRoute(
        path: AppConstants.asciiRoute,
        name: 'ascii',
        builder: (context, state) => const AsciiScreen(),
      ),
      GoRoute(
        path: '/tabela-ascii',
        name: 'ascii-tabela',
        builder: (context, state) => const AsciiTableScreen(),
      ),
      GoRoute(
        path: AppConstants.binaryRoute,
        name: 'binario',
        builder: (context, state) => const BinarioScreen(),
      ),
      GoRoute(
        path: '/tabela-binaria',
        name: 'binario-tabela',
        builder: (context, state) => const BinaryTableScreen(),
      ),
      GoRoute(
        path: AppConstants.rgbRoute,
        name: 'rgb',
        builder: (context, state) => _buildRgbScreen(context, state),
      ),
      GoRoute(
        path: AppConstants.resultsRoute,
        name: 'resultados',
        builder: (context, state) => _buildResultsScreen(context, state),
      ),
    ],
  );

  /// Constrói a tela RGB (a ser implementada).
  static Widget _buildRgbScreen(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Módulo RGB'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppConstants.homeRoute),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.color_lens, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Módulo RGB em construção',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Estamos desenvolvendo um novo módulo para ensinar sobre cores RGB de maneira interativa.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.homeRoute),
              child: const Text('Voltar para a página inicial'),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói a tela de resultados (a ser implementada).
  static Widget _buildResultsScreen(BuildContext context, GoRouterState state) {
    // Implementação temporária
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppConstants.homeRoute),
        ),
      ),
      body: const Center(
        child: Text(
          'Tela de resultados em desenvolvimento',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  /// Constrói a tela de erro.
  static Widget _errorScreen(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página não encontrada'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppConstants.homeRoute),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'A página ${state.matchedLocation} não foi encontrada.',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.homeRoute),
              child: const Text('Voltar para a página inicial'),
            ),
          ],
        ),
      ),
    );
  }
}
