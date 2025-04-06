import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';

class ModuleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final bool isWeb;
  final VoidCallback onTap;

  const ModuleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.isWeb,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = !isWeb && screenWidth <= 600;
    final isSmallDevice = !isWeb && screenWidth < 360;

    // Ajustar cardWidth para dispositivos pequenos
    final cardWidth =
        isWeb
            ? 300.0
            : isSmallDevice
            ? screenWidth -
                40 // Reduzir para dispositivos pequenos
            : 320.0;

    return Semantics(
      label: 'Módulo $title',
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: isSmallDevice ? 4.0 : 8.0,
        ),
        child: RepaintBoundary(
          child: Animate(
            effects: [
              FadeEffect(duration: 500.ms, curve: Curves.easeOut),
              SlideEffect(
                begin: const Offset(0, 0.1),
                end: const Offset(0, 0),
                curve: Curves.easeOut,
              ),
            ],
            child: StatefulBuilder(
              builder: (context, setState) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() {}),
                  onExit: (_) => setState(() {}),
                  child: GestureDetector(
                    onTap: onTap,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 1.0, end: 1.03),
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: cardWidth,
                            // Altura ajustada para cada tipo de dispositivo
                            height:
                                isWeb
                                    ? null
                                    : isSmallDevice
                                    ? 180.0 // Ainda menor para dispositivos muito pequenos
                                    : isMobile
                                    ? 200.0 // Menor para mobile
                                    : 240.0, // Maior para tablets
                            constraints:
                                isWeb
                                    ? BoxConstraints(
                                      maxWidth: cardWidth,
                                      minHeight: 100.0,
                                    )
                                    : null,
                            decoration: BoxDecoration(
                              // Gradiente mais moderno com 3 cores
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  color.withAlpha(242),
                                  color.withAlpha(166),
                                  color.darken(0.2).withAlpha(179),
                                ],
                                stops: const [0.1, 0.6, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(
                                isSmallDevice ? 22 : 28,
                              ),
                              boxShadow: [
                                // Glow effect
                                BoxShadow(
                                  color: color.withAlpha(102),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 6),
                                ),
                                BoxShadow(
                                  color: Colors.black.withAlpha(51),
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withAlpha(77),
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                isSmallDevice ? 22 : 28,
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Stack(
                                  children: [
                                    // Fundo com textura de linhas diagonais
                                    Positioned.fill(
                                      child: CustomPaint(
                                        painter: DiagonalLinesPainter(
                                          color: Colors.white.withAlpha(13),
                                          lineWidth: 1,
                                          spacing: 20,
                                        ),
                                      ),
                                    ),

                                    // Fundo animado
                                    Positioned.fill(
                                      child: Opacity(
                                        opacity: 0.05,
                                        child: Image.asset(
                                              AppConstants.matrixBgImage,
                                              fit: BoxFit.cover,
                                              cacheWidth: 320,
                                              cacheHeight: 220,
                                              filterQuality:
                                                  FilterQuality.medium,
                                            )
                                            .animate(
                                              onPlay:
                                                  (controller) => controller
                                                      .repeat(reverse: true),
                                            )
                                            .shimmer(
                                              duration: 5000.ms,
                                              color: Colors.white.withAlpha(38),
                                            ),
                                      ),
                                    ),

                                    // Conteúdo do card
                                    Padding(
                                      padding: EdgeInsets.all(
                                        isSmallDevice
                                            ? 16.0
                                            : isMobile
                                            ? 20.0
                                            : 26.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Ícone e título
                                          Row(
                                            children: [
                                              // Container com brilho para o ícone
                                              Container(
                                                padding: EdgeInsets.all(
                                                  isSmallDevice
                                                      ? 10
                                                      : isMobile
                                                      ? 12
                                                      : 14,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: RadialGradient(
                                                    colors: [
                                                      Colors.white.withAlpha(
                                                        77,
                                                      ),
                                                      Colors.white.withAlpha(
                                                        26,
                                                      ),
                                                    ],
                                                    stops: const [0.0, 1.0],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        isSmallDevice ? 14 : 18,
                                                      ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: color.withAlpha(
                                                        51,
                                                      ),
                                                      blurRadius: 8,
                                                      spreadRadius: 0.5,
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  icon,
                                                  size:
                                                      isSmallDevice
                                                          ? 24
                                                          : isMobile
                                                          ? 28
                                                          : 32,
                                                  color: Colors.white,
                                                ),
                                              ).animate().shimmer(
                                                delay: 200.ms,
                                                duration: 2500.ms,
                                              ),
                                              SizedBox(
                                                width: isSmallDevice ? 12 : 16,
                                              ),
                                              // Título com efeito de texto
                                              Expanded(
                                                child: Text(
                                                  title,
                                                  style: GoogleFonts.rajdhani(
                                                    fontSize:
                                                        isSmallDevice
                                                            ? 20
                                                            : isMobile
                                                            ? 22
                                                            : 26,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    letterSpacing: 0.5,
                                                    shadows: [
                                                      Shadow(
                                                        blurRadius: 5.0,
                                                        color: color.withAlpha(
                                                          102,
                                                        ),
                                                        offset: const Offset(
                                                          0,
                                                          1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                isSmallDevice
                                                    ? 8
                                                    : isMobile
                                                    ? 12
                                                    : 16,
                                          ),
                                          // Descrição
                                          Text(
                                            description,
                                            style: GoogleFonts.rubik(
                                              fontSize:
                                                  isSmallDevice
                                                      ? 13
                                                      : isMobile
                                                      ? 14
                                                      : 15,
                                              height: 1.3,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 3.0,
                                                  color: Colors.black.withAlpha(
                                                    51,
                                                  ),
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height:
                                                isSmallDevice
                                                    ? 10
                                                    : isMobile
                                                    ? 12
                                                    : 16,
                                          ),
                                          // Botão explorar com gradiente
                                          Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      isSmallDevice
                                                          ? 12
                                                          : isMobile
                                                          ? 14
                                                          : 18,
                                                  vertical:
                                                      isSmallDevice
                                                          ? 6
                                                          : isMobile
                                                          ? 8
                                                          : 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Colors.white.withAlpha(
                                                        77,
                                                      ),
                                                      Colors.white.withAlpha(
                                                        26,
                                                      ),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: color.withAlpha(
                                                        38,
                                                      ),
                                                      blurRadius: 4,
                                                      spreadRadius: 0,
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Explorar',
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                            fontSize:
                                                                isSmallDevice
                                                                    ? 14
                                                                    : isMobile
                                                                    ? 15
                                                                    : 17,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            letterSpacing: 0.5,
                                                          ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          isSmallDevice ? 6 : 8,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_rounded,
                                                      color: Colors.white,
                                                      size:
                                                          isSmallDevice
                                                              ? 16
                                                              : isMobile
                                                              ? 18
                                                              : 20,
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .animate()
                                              .fadeIn(
                                                delay: 300.ms,
                                                duration: 400.ms,
                                                curve: Curves.easeOut,
                                              )
                                              .slideX(
                                                begin: -0.1,
                                                end: 0,
                                                curve: Curves.easeOut,
                                              ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Extensão para manipular cores
extension ColorExtension on Color {
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }
}

/// Painter para criar linhas diagonais
class DiagonalLinesPainter extends CustomPainter {
  final Color color;
  final double lineWidth;
  final double spacing;

  DiagonalLinesPainter({
    required this.color,
    this.lineWidth = 1.0,
    this.spacing = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = lineWidth
          ..style = PaintingStyle.stroke;

    // Desenhar linhas diagonais
    for (double i = 0; i < size.width + size.height; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(0, i), paint);
    }
  }

  @override
  bool shouldRepaint(DiagonalLinesPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.spacing != spacing;
  }
}
