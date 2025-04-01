import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final frases = [
    "Sabia que o número 65 representa a letra A?",
    "Você já viu um pixel azul hoje?",
    "Vamos decifrar códigos juntos!",
    "Tudo começa com 0 e 1!",
    "As cores são feitas de números!",
    "O computador só entende 0 e 1 — é assim que ele pensa!",
    "Textos viram números para o computador entender.",
    "A letra 'A' é 65 em ASCII. Que loucura, né?",
    "Cores no computador são só combinações de vermelho, verde e azul!",
    "Uma imagem digital é feita de pixels codificados.",
    "Aprender código é como aprender a língua do computador.",
    "Tudo que digitamos é transformado em números binários.",
    "Você sabia que o branco é 255, 255, 255 em RGB?",
    "Com binário, dá pra representar qualquer número!",
    "A cor azul puro é RGB(0, 0, 255).",
    "Representar dados é essencial para armazenar e transmitir informações.",
    "Vamos codificar letras, cores e números — tudo com lógica!",
  ];

  final player = AudioPlayer();
  int fraseIndex = 0;

  Future<void> _playClickSound() async {
    await player.play(AssetSource('sounds/click.mp3'));
  }

  void _trocarFrase() {
    setState(() {
      fraseIndex = (fraseIndex + 1) % frases.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'CodePlay',
          style: GoogleFonts.orbitron(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/config'),
            icon: const Icon(Icons.info_outline),
            tooltip: 'Sobre',
          ),
        ],
        backgroundColor: Colors.black.withOpacity(0.7),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          _buildFloatingBitsOverlay(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Semantics(
                      label: 'Texto de instrução',
                      child: Text(
                        'Escolha um módulo para começar:',
                        style: GoogleFonts.rajdhani(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),
                    ),
                    const SizedBox(height: 40),
                    isWide
                        ? CarouselSlider(
                            options: CarouselOptions(
                              height: 220,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              autoPlayAnimationDuration: const Duration(milliseconds: 800),
                              pauseAutoPlayOnTouch: true,
                              viewportFraction: 0.4,
                              aspectRatio: 16/9,
                            ),
                            items: _buildButtons(context),
                          ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.95, 0.95))
                        : Column(
                            children: _buildButtons(context),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        Container(
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
        ),
        Opacity(
          opacity: 0.05,
          child: Transform.translate(
            offset: Offset(
              8 * (MediaQuery.of(context).size.width / 2 - 0) / MediaQuery.of(context).size.width,
              8 * (MediaQuery.of(context).size.height / 2 - 0) / MediaQuery.of(context).size.height,
            ),
            child: Image.asset(
              'assets/images/matrix_bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .moveX(duration: 8000.ms, begin: -5, end: 5)
           .moveY(duration: 10000.ms, begin: -5, end: 5),
        ),
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



  List<Widget> _buildButtons(BuildContext context) {
    final modules = [
      {
        'title': 'Binário',
        'icon': Icons.memory,
        'route': '/binario',
        'color': Colors.blue.shade700,
        'description': 'Aprenda como os computadores representam dados com 0s e 1s',
      },
      {
        'title': 'ASCII',
        'icon': Icons.keyboard,
        'route': '/ascii',
        'color': Colors.purple.shade700,
        'description': 'Descubra como letras são convertidas em números',
      },
      {
        'title': 'RGB',
        'icon': Icons.palette,
        'route': '/rgb',
        'color': Colors.green.shade700,
        'description': 'Explore como as cores são formadas por números',
      },
    ];
    
    return modules.map((module) => _buildModuleCard(
      context,
      module['title'] as String,
      module['icon'] as IconData,
      module['route'] as String,
      module['color'] as Color,
      module['description'] as String,
    )).toList();
  }

  Widget _buildModuleCard(BuildContext context, String title, IconData icon, String route, Color color, String description) {
    return Semantics(
      label: 'Módulo $title',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Animate(
          effects: [FadeEffect(duration: 600.ms), SlideEffect(begin: const Offset(0, 0.2), end: const Offset(0, 0))],
          child: StatefulBuilder(
            builder: (context, setState) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    await _playClickSound();
                    // Efeito visual de clique
                    setState(() {});
                    // Pequeno atraso para o efeito visual ser percebido
                    await Future.delayed(const Duration(milliseconds: 150));
                    if (context.mounted) {
                      context.go(route);
                    }
                  },
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 1.0, end: 1.0),
                    duration: const Duration(milliseconds: 200),
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 280,
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                color.withOpacity(0.7),
                                color.withOpacity(0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(icon, size: 28, color: Colors.white),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          title,
                                          style: GoogleFonts.rajdhani(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      description,
                                      style: GoogleFonts.rubik(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Explorar',
                                          style: GoogleFonts.rajdhani(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
    );
  }
}