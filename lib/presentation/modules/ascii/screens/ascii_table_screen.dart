import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/glass_utils.dart';
import '../widgets/ascii_table_widget.dart';
import '../../../shared/widgets/mascote_widget.dart';
import '../../../shared/widgets/background_widget.dart';

class AsciiTableScreen extends StatefulWidget {
  const AsciiTableScreen({super.key});

  @override
  State<AsciiTableScreen> createState() => _AsciiTableScreenState();
}

class _AsciiTableScreenState extends State<AsciiTableScreen>
    with SingleTickerProviderStateMixin {
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

                  // Título da Tabela
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
                      "Tabela ASCII Completa",
                      style: GoogleFonts.orbitron(
                        fontSize: 28,
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
                      "Referência de códigos ASCII e seus respectivos caracteres",
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
                          "Esta tabela mostra os códigos ASCII de 0 a 127 e seus caracteres correspondentes. "
                          "Os caracteres de 0 a 31 são caracteres de controle não imprimíveis, "
                          "enquanto os caracteres de 32 a 126 são caracteres imprimíveis.",
                      mascotType: MascotType.tip,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tabela ASCII completa
                  Animate(
                    effects: [FadeEffect(duration: 600.ms, delay: 600.ms)],
                    child: GlassUtils.buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TABELA ASCII",
                            style: GoogleFonts.orbitron(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "ASCII Standard (7-bit): códigos de 0 a 127",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withAlpha(230),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Tabela ASCII expansível
                          const AsciiTableWidget(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Informações adicionais sobre ASCII
                  Animate(
                    effects: [FadeEffect(duration: 700.ms, delay: 800.ms)],
                    child: GlassUtils.buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SOBRE O ASCII",
                            style: GoogleFonts.orbitron(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            "O que é ASCII?",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "ASCII (American Standard Code for Information Interchange) é um padrão de codificação de caracteres baseado no alfabeto inglês. Foi desenvolvido a partir de 1963 e publicado como padrão em 1967.",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withAlpha(230),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Text(
                            "Categorias de Caracteres",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildCategoryCard(
                            "Caracteres de Controle (0-31)",
                            "Caracteres não imprimíveis usados para controlar dispositivos. Exemplos: retorno de carro (CR), avanço de linha (LF), tabulação (TAB).",
                          ),
                          const SizedBox(height: 8),
                          _buildCategoryCard(
                            "Caracteres Imprimíveis (32-126)",
                            "Caracteres visíveis incluindo letras, números e símbolos. O código 32 é o espaço em branco.",
                          ),
                          const SizedBox(height: 8),
                          _buildCategoryCard(
                            "Caractere Delete (127)",
                            "Historicamente usado para marcar dados para exclusão em fitas de papel perfurado.",
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

  Widget _buildCategoryCard(String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withAlpha(77),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(51)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.orbitron(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withAlpha(204),
            ),
          ),
        ],
      ),
    );
  }

  // AppBar personalizada com efeito de vidro
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return GlassUtils.buildGlassAppBar(
      title: "TABELA ASCII",
      context: context,
      titleStyle: GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
      leading: IconButton(
        key: const Key('btn_voltar_tabela_ascii'),
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Voltar para a tela do módulo ASCII
          context.go('/ascii');
        },
      ),
    );
  }
}
