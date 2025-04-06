import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/glass_utils.dart';
import '../../shared/widgets/mascote_widget.dart';
import '../../shared/widgets/background_widget.dart';
import 'widgets/ascii_example_card.dart';
import 'widgets/ascii_input_section.dart';

class AsciiScreen extends StatefulWidget {
  const AsciiScreen({super.key});

  @override
  State<AsciiScreen> createState() => _AsciiScreenState();
}

class _AsciiScreenState extends State<AsciiScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;
  final List<Map<String, dynamic>> _exampleChars = [
    {'char': 'A', 'code': 65, 'description': 'Letra A maiúscula'},
    {'char': 'a', 'code': 97, 'description': 'Letra a minúscula'},
    {'char': '0', 'code': 48, 'description': 'Número zero'},
    {'char': '@', 'code': 64, 'description': 'Símbolo arroba'},
    {'char': ' ', 'code': 32, 'description': 'Espaço'},
  ];

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
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Fundo animado
          AnimatedBackgroundWidget(
            controller: _backgroundController,
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),

          // Conteúdo principal
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Título do Módulo
                  Animate(
                    effects: [
                      FadeEffect(duration: 400.ms),
                      SlideEffect(
                        begin: const Offset(0, -0.2),
                        end: Offset.zero,
                        duration: 400.ms,
                      ),
                    ],
                    child: Text(
                      "Código ASCII",
                      style: GoogleFonts.orbitron(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtítulo com descrição
                  Animate(
                    effects: [FadeEffect(duration: 400.ms, delay: 200.ms)],
                    child: Text(
                      "Entenda como computadores representam caracteres",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white.withAlpha(230),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Mascote explicativo
                  Animate(
                    effects: [FadeEffect(duration: 500.ms, delay: 400.ms)],
                    child: MascoteWidget(
                      message:
                          "O código ASCII é um sistema de numeração que representa caracteres como números. "
                          "Por exemplo, a letra 'A' é representada pelo número 65, enquanto o caractere '0' é o número 48.",
                      mascotType: MascotType.tip,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Cartão de conteúdo principal
                  Animate(
                    effects: [FadeEffect(duration: 600.ms, delay: 600.ms)],
                    child: GlassUtils.buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "O QUE É ASCII?",
                            style: GoogleFonts.orbitron(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "ASCII (American Standard Code for Information Interchange) é uma tabela de códigos que relaciona números a caracteres de texto. "
                            "Ele define 128 caracteres (0-127), incluindo letras maiúsculas e minúsculas, números, símbolos e caracteres de controle.",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withAlpha(230),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Exemplos de caracteres ASCII
                          Text(
                            "EXEMPLOS",
                            style: GoogleFonts.orbitron(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Lista de exemplos
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children:
                                _exampleChars
                                    .map(
                                      (example) => AsciiExampleCard(
                                        char: example['char'],
                                        code: example['code'],
                                        description: example['description'],
                                      ),
                                    )
                                    .toList(),
                          ),
                          const SizedBox(height: 24),

                          // Seção interativa
                          const AsciiInputSection(),
                          const SizedBox(height: 32),

                          // Aviso para chamar atenção para a tabela
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.cyan.shade800.withAlpha(100),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.cyan.shade300.withAlpha(150),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.new_releases,
                                  color: Colors.cyan.shade300,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "NOVO! Tabela ASCII completa disponível em tela separada!",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 800.ms, delay: 200.ms),

                          const SizedBox(height: 16),

                          // Botão para acessar a tabela ASCII separada
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Animate(
                              effects: [
                                FadeEffect(duration: 600.ms, delay: 300.ms),
                                SlideEffect(
                                  begin: const Offset(0, 0.2),
                                  end: Offset.zero,
                                  duration: 500.ms,
                                ),
                                ShakeEffect(
                                  duration: 1000.ms,
                                  delay: 1500.ms,
                                  hz: 3,
                                ),
                              ],
                              child: ElevatedButton.icon(
                                key: const Key('btn_tabela_ascii'),
                                onPressed: () {
                                  context.go('/tabela-ascii');
                                },
                                icon: const Icon(Icons.table_chart, size: 28),
                                label: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "VER TABELA ASCII COMPLETA",
                                    style: GoogleFonts.orbitron(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 28,
                                  ),
                                  elevation: 12,
                                  shadowColor: Colors.red.shade900.withAlpha(
                                    180,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color: Colors.yellow,
                                      width: 3,
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

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // AppBar personalizada com efeito de vidro
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return GlassUtils.buildGlassAppBar(
      title: "ASCII",
      context: context,
      titleStyle: GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Sempre navegar para a rota principal - solução mais estável para web/Edge
          context.go('/');
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            _showInfoModal(context);
          },
        ),
      ],
    );
  }

  void _showInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900.withAlpha(128),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  border: Border.all(
                    color: Colors.blue.shade200.withAlpha(51),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "SOBRE O CÓDIGO ASCII",
                      style: GoogleFonts.orbitron(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "O código ASCII foi desenvolvido na década de 1960 para padronizar a comunicação entre computadores. "
                      "Originalmente usava 7 bits, o que permitia representar 128 caracteres (0-127). "
                      "Mais tarde, a extensão ASCII ou ASCII estendido passou a utilizar 8 bits, permitindo representar 256 caracteres (0-255).",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "ENTENDI",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
