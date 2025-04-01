import 'dart:ui';
import 'dart:math' show sin, cos;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SobreScreen extends StatefulWidget {
  const SobreScreen({super.key});

  @override
  State<SobreScreen> createState() => _SobreScreenState();
}

class _SobreScreenState extends State<SobreScreen> with SingleTickerProviderStateMixin {
  final List<bool> _sectionVisible = [true, true, true, true];
  late AnimationController _backgroundController;
  
  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedBackground(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AppBar com título animado
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Sobre o Projeto',
                            textStyle: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                        totalRepeatCount: 1,
                        displayFullTextOnTap: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Expanded(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 700),
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.08),
                                  Colors.white.withOpacity(0.04),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(color: Colors.white24),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (scroll) {
                                for (int i = 0; i < _sectionVisible.length; i++) {
                                  if (!_sectionVisible[i] &&
                                      scroll.metrics.pixels > i * 80 - 100) {
                                    setState(() {
                                      _sectionVisible[i] = true;
                                    });
                                  }
                                }
                                return false;
                              },
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildAnimatedSection(
                                      index: 0,
                                      title: 'O que é o CodePlay?',
                                      content:
                                          'O CodePlay é um aplicativo/jogo educativo voltado para alunos do 4º ano do Ensino Fundamental. '
                                          'Ele ensina conceitos de codificação digital como binário, ASCII e RGB de forma lúdica e interativa.',
                                    ),
                                    _buildAnimatedSection(
                                      index: 1,
                                      title: 'Alinhamento com a BNCC',
                                      content:
                                          '• EF04CO04 – Representação e codificação de dados para máquinas\n'
                                          '• EF04CO05 – Codificação de letras, números e cores (binário, ASCII, RGB)',
                                    ),
                                    _buildAnimatedSection(
                                      index: 2,
                                      title: 'Autores / Equipe',
                                      content:
                                          'Mateus Antônio Ramos da Silva (Desenvolvedor)\n'
                                          'Allan de Menezes Maia Filho (Colaborador pedagógico)\n'
                                          'Disciplina: Ensino de Computação II\n'
                                          'Ano Letivo: 2025.1',
                                    ),
                                    _buildAnimatedSection(
                                      index: 3,
                                      title: 'Portfólio do desenvolvedor',
                                      content: 'Clique aqui para visitar:',
                                    ),
                                    Center(
                                      child: ElevatedButton.icon(
                                        onPressed: () => launchUrl(
                                          Uri.parse('https://samportfoliope.vercel.app'),
                                          mode: LaunchMode.externalApplication,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 4,
                                          shadowColor: Colors.black54,
                                        ),
                                        icon: const Icon(Icons.open_in_new),
                                        label: Text(
                                          'Acessar Portfólio',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.95, 0.95)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

  Widget _buildAnimatedSection({
    required int index,
    required String title,
    required String content,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _sectionVisible[index] ? 1 : 0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900.withOpacity(0.1),
                Colors.indigo.shade900.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white10),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getSectionIcon(index),
                    color: Colors.blue.shade300,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
              const SizedBox(height: 12),
              Text(
                content,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.white.withOpacity(0.9),
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
            ],
          ),
        ).animate().scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 300.ms),
      ),
    );
  }
  
  IconData _getSectionIcon(int index) {
    switch (index) {
      case 0:
        return Icons.school_outlined;
      case 1:
        return Icons.menu_book_outlined;
      case 2:
        return Icons.people_outline;
      case 3:
        return Icons.person_outline;
      default:
        return Icons.info_outline;
    }
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Gradiente de fundo animado
        AnimatedBuilder(
          animation: _backgroundController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.indigo.shade900,
                    Colors.blue.shade900,
                    Colors.indigo.shade900,
                    Colors.black,
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
          child: AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  8 * sin(_backgroundController.value * 2 * 3.14),
                  8 * cos(_backgroundController.value * 2 * 3.14),
                ),
                child: child,
              );
            },
            child: Image.asset(
              'assets/images/matrix_bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
            ),
          ),
        ),
        
        // Efeito de bits flutuantes
        _buildFloatingBitsOverlay(),
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
            ).animate(onPlay: (controller) => controller.repeat())
              .fadeIn(duration: 2500.ms)
              .then()
              .fadeOut(duration: 2500.ms),
          ),
        ),
      ),
    );
  }
}
