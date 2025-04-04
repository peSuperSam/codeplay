import 'dart:ui';
import 'dart:async';
import 'dart:math';
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
  void initState() {
    super.initState();
    
    // Iniciar a rotação automática das frases
    Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        _trocarFrase();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Container(), // Removido o texto 'CodePlay'
        actions: [
          IconButton(
            onPressed: () => context.push('/config'),
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'Sobre',
          ),
        ],
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                // Adicionando SingleChildScrollView para evitar overflow
                child: SingleChildScrollView(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mensagens rotativas posicionadas aqui
                    _buildRotatingMessage(),
                    const SizedBox(height: 30),
                    isWide
                        ? CarouselSlider(
                            options: CarouselOptions(
                              height: 260,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 7),
                              autoPlayAnimationDuration: const Duration(milliseconds: 1200),
                              pauseAutoPlayOnTouch: true,
                              viewportFraction: 0.42,
                              enlargeFactor: 0.35,
                              aspectRatio: 16/9,
                              padEnds: false,
                              pageSnapping: true,
                            ),
                            items: _buildButtons(context),
                          ).animate()
                            .fadeIn(duration: 1000.ms)
                            .scale(begin: const Offset(0.92, 0.92), curve: Curves.easeOutQuint)
                        : Column(
                            children: _buildButtons(context),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Removido o widget de mensagens flutuantes daqui
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF050A30),
            const Color(0xFF000C66),
            const Color(0xFF0000FF).withOpacity(0.4),
            const Color(0xFF000C66),
            const Color(0xFF050A30),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Imagem de fundo com baixa opacidade para textura
          Opacity(
            opacity: 0.08,
            child: Image.asset(
              'assets/images/matrix_bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Texto binário com baixa opacidade
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.05,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '0 1 0 1 1 0 1 0',
                    style: GoogleFonts.orbitron(
                      fontSize: 100,
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBitsOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Efeito de bits flutuantes
            Opacity(
              opacity: 0.07,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '0 1 0 1 1 0 1 0',
                  style: GoogleFonts.orbitron(
                    fontSize: 100,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Removida a frase rotativa daqui, agora está no método _buildRotatingMessage()
          ],
        ),
      ),
    );
  }

  // Novo método para exibir as mensagens rotativas
  Widget _buildRotatingMessage() {
    return Semantics(
      label: 'Mensagem rotativa',
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: 0.95,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 25,
                spreadRadius: 1,
              ),
            ],
          ),
          // Limitando a largura para evitar overflow horizontal
          constraints: const BoxConstraints(maxWidth: 600),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                frases[fraseIndex],
                key: ValueKey<int>(fraseIndex),
                style: GoogleFonts.rajdhani(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.blue.withOpacity(0.3),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
        ),
      ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3),
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
          effects: [FadeEffect(duration: 800.ms), SlideEffect(begin: const Offset(0, 0.2), end: const Offset(0, 0))],
          child: StatefulBuilder(
            builder: (context, setState) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() {}),
                onExit: (_) => setState(() {}),
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
                    tween: Tween<double>(begin: 1.0, end: 1.05),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 320,
                          height: 220,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                color.withOpacity(0.9),
                                color.withOpacity(0.5),
                              ],
                              stops: const [0.2, 0.9],
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 25,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Stack(
                                children: [
                                  // Efeito de partículas no fundo do card
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: 0.05,
                                      child: Image.asset(
                                        'assets/images/matrix_bg.png',
                                        fit: BoxFit.cover,
                                      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                                       .shimmer(duration: 4000.ms, color: Colors.white.withOpacity(0.2)),
                                    ),
                                  ),
                                  // Conteúdo do card
                                  Padding(
                                    padding: const EdgeInsets.all(26.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(18),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: color.withOpacity(0.3),
                                                    blurRadius: 15,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                              child: Icon(icon, size: 32, color: Colors.white),
                                            ).animate()
                                             .shimmer(delay: 200.ms, duration: 1800.ms),
                                            const SizedBox(width: 16),
                                            Text(
                                              title,
                                              style: GoogleFonts.rajdhani(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 10.0,
                                                    color: color.withOpacity(0.5),
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 22),
                                        Text(
                                          description,
                                          style: GoogleFonts.rubik(
                                            fontSize: 16,
                                            height: 1.4,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 5.0,
                                                color: Colors.black.withOpacity(0.3),
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                color: color.withOpacity(0.2),
                                                blurRadius: 8,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Explorar',
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ).animate()
                                         .fadeIn(delay: 400.ms, duration: 600.ms)
                                         .slideX(begin: -0.2, end: 0),
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
    );
  }
}