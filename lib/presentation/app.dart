import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import 'modules/home/home_screen.dart';
import 'modules/config/sobre_screen.dart';
import 'modules/ascii/ascii_screen.dart';
import 'modules/binario/binario_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/config',
      builder: (context, state) => const SobreScreen(),
    ),
    GoRoute(
      path: '/ascii',
      builder: (context, state) => const AsciiScreen(),
    ),
    GoRoute(
      path: '/binario',
      builder: (context, state) => const BinarioScreen(),
    ),
  ],
);
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CodePlay',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
