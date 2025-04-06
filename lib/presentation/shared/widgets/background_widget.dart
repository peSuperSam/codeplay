import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

/// Widget de fundo animado reutilizável para as telas do aplicativo.
class AnimatedBackgroundWidget extends StatefulWidget {
  /// Modo escuro ativado
  final bool isDark;

  /// Controlador de animação opcional
  final AnimationController? controller;

  /// Se deve usar texto flutuante
  final bool showFloatingText;

  const AnimatedBackgroundWidget({
    super.key,
    this.isDark = true,
    this.controller,
    this.showFloatingText = true,
  });

  @override
  State<AnimatedBackgroundWidget> createState() =>
      _AnimatedBackgroundWidgetState();
}

class _AnimatedBackgroundWidgetState extends State<AnimatedBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
              AnimationController(
                vsync: this,
                duration: const Duration(seconds: 20),
              )
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    // Só dispor o controller se ele foi criado localmente
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradiente de fundo animado
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      widget.isDark
                          ? [
                            Colors.black,
                            Colors.indigo.shade900,
                            Colors.blue.shade900,
                            Colors.indigo.shade900,
                            Colors.black,
                          ]
                          : [
                            AppColors.lightBackgroundColor,
                            Colors.indigo.shade800,
                            Colors.blue.shade700,
                            Colors.indigo.shade800,
                            AppColors.lightBackgroundColor,
                          ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
            );
          },
        ),

        // Imagem de fundo com efeito de movimento
        Opacity(
          opacity: 0.05,
          child: Image.asset(
            AppConstants.matrixBgImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
          ),
        ),

        // Efeito de bits flutuantes (opcional)
        if (widget.showFloatingText) _buildFloatingBitsOverlay(),
      ],
    );
  }

  Widget _buildFloatingBitsOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
                  '0 1 0 1 1 0 1 0',
                  style: GoogleFonts.orbitron(
                    fontSize: 100,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 2500.ms)
                .then()
                .fadeOut(duration: 2500.ms),
          ),
        ),
      ),
    );
  }
}
