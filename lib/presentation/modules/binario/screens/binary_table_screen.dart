import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/widgets/mascote_widget.dart';
import '../../../shared/widgets/background_widget.dart';

class BinaryTableScreen extends StatefulWidget {
  const BinaryTableScreen({super.key});

  @override
  State<BinaryTableScreen> createState() => _BinaryTableScreenState();
}

class _BinaryTableScreenState extends State<BinaryTableScreen>
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
                      "Tabela de Conversão Binária",
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
                      "Referência completa para conversão entre binário e decimal",
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
                          "Esta tabela mostra os valores decimais e suas representações binárias. "
                          "Lembre-se que cada posição no número binário representa uma potência de 2, "
                          "começando da direita para a esquerda: 2⁰, 2¹, 2², 2³, e assim por diante.",
                      mascotType: MascotType.tip,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tabela de Conversão Binária
                  Animate(
                    effects: [FadeEffect(duration: 600.ms, delay: 600.ms)],
                    child: _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TABELA DE CONVERSÃO",
                            style: GoogleFonts.orbitron(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Valores de 0 a 31 e suas representações equivalentes",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withAlpha(230),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Tabela de conversão
                          _buildBinaryTable(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Como Converter
                  Animate(
                    effects: [FadeEffect(duration: 700.ms, delay: 800.ms)],
                    child: _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "COMO CONVERTER",
                            style: GoogleFonts.orbitron(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Binário para Decimal
                          Text(
                            "De Binário para Decimal:",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Multiplique cada dígito pela potência de 2 correspondente à sua posição (da direita para a esquerda), começando com 2⁰ = 1.",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withAlpha(230),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildExampleCard(
                            "Exemplo: 1011",
                            "1 × 2³ + 0 × 2² + 1 × 2¹ + 1 × 2⁰",
                            "1 × 8 + 0 × 4 + 1 × 2 + 1 × 1 = 11",
                          ),

                          const SizedBox(height: 24),

                          // Decimal para Binário
                          Text(
                            "De Decimal para Binário:",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Divida o número por 2 repetidamente e anote os restos da divisão. Leia os restos de baixo para cima para obter o número binário.",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withAlpha(230),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildExampleCard(
                            "Exemplo: 13",
                            "13 ÷ 2 = 6 resto 1\n6 ÷ 2 = 3 resto 0\n3 ÷ 2 = 1 resto 1\n1 ÷ 2 = 0 resto 1",
                            "Resultado: 1101",
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

  Widget _buildBinaryTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: DataTable(
          horizontalMargin: 8,
          dataRowMinHeight: 48,
          headingRowHeight: 56,
          columnSpacing: 16,
          headingRowColor: WidgetStateProperty.all(
            Colors.blue.shade800.withAlpha(153),
          ),
          dataRowColor: WidgetStateProperty.all(Colors.transparent),
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.white.withAlpha(51)),
          ),
          columns: [
            DataColumn(label: _headerText('Decimal')),
            DataColumn(label: _headerText('Binário')),
            DataColumn(label: _headerText('Decimal')),
            DataColumn(label: _headerText('Binário')),
          ],
          rows: _generateBinaryRows(),
          checkboxHorizontalMargin: 0,
          clipBehavior: Clip.none,
        ),
      ),
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: GoogleFonts.orbitron(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1,
      ),
    );
  }

  List<DataRow> _generateBinaryRows() {
    List<DataRow> rows = [];

    // Gerar 16 linhas com 2 valores por linha (0-31)
    for (int i = 0; i < 16; i++) {
      final dec1 = i;
      final dec2 = i + 16;

      rows.add(
        DataRow(
          cells: [
            DataCell(Text(dec1.toString(), style: _cellTextStyle())),
            DataCell(_binaryCell(_decimalToBinary(dec1))),
            DataCell(Text(dec2.toString(), style: _cellTextStyle())),
            DataCell(_binaryCell(_decimalToBinary(dec2))),
          ],
        ),
      );
    }

    return rows;
  }

  Widget _binaryCell(String binary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(77),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.withAlpha(128)),
      ),
      child: Text(
        binary,
        style: GoogleFonts.orbitron(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  TextStyle _cellTextStyle() {
    return GoogleFonts.poppins(fontSize: 14, color: Colors.white);
  }

  String _decimalToBinary(int decimal) {
    if (decimal == 0) return '0';

    String binary = '';
    int value = decimal;

    while (value > 0) {
      binary = '${value % 2}$binary';
      value ~/= 2;
    }

    return binary;
  }

  Widget _buildExampleCard(String title, String steps, String result) {
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
            steps,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withAlpha(204),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade300,
            ),
          ),
        ],
      ),
    );
  }

  // Glass Card com efeito de vidro para conteúdo
  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.blue.shade900.withAlpha(77),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.blue.shade200.withAlpha(51),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(77),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // AppBar personalizada com efeito de vidro
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Text(
        "TABELA BINÁRIA",
        style: GoogleFonts.orbitron(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      leading: IconButton(
        key: const Key('btn_voltar_tabela'),
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Voltar para a tela do módulo binário
          context.go('/binario');
        },
      ),
    );
  }
}
