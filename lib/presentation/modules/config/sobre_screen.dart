import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SobreScreen extends StatefulWidget {
  const SobreScreen({super.key});

  @override
  State<SobreScreen> createState() => _SobreScreenState();
}

class _SobreScreenState extends State<SobreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Voltar',
        ),
        title: Text(
          'Sobre o Projeto',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                            title: 'O que é o CodePlay?',
                            icon: Icons.school_outlined,
                          ),
                          const SizedBox(height: 12),
                          _buildSectionContent(
                            'O CodePlay é um aplicativo educativo voltado para alunos do 4º ano do Ensino Fundamental. '
                            'Ele ensina conceitos de codificação digital como binário, ASCII e RGB de forma lúdica e interativa.',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                            title: 'Alinhamento com a BNCC',
                            icon: Icons.menu_book_outlined,
                          ),
                          const SizedBox(height: 12),
                          _buildSectionContent(
                            '• EF04CO04 – Representação e codificação de dados para máquinas\n'
                            '• EF04CO05 – Codificação de letras, números e cores (binário, ASCII, RGB)',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                            title: 'Autores / Equipe',
                            icon: Icons.people_outline,
                          ),
                          const SizedBox(height: 12),
                          _buildSectionContent(
                            'Mateus Antônio Ramos da Silva (Desenvolvedor)\n'
                            'Allan de Menezes Maia Filho (Colaborador pedagógico)\n'
                            'Disciplina: Ensino de Computação II\n'
                            'Ano Letivo: 2025.1',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                            title: 'Portfólio do desenvolvedor',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 12),
                          _buildSectionContent('Clique abaixo para visitar:'),
                          const SizedBox(height: 16),
                          Center(child: _buildPortfolioButton()),
                        ],
                      ),
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

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            const Color(0xFF050A30),
            const Color(0xFF0000FF).withAlpha(128),
            const Color(0xFF050A30),
            Colors.black,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
        ),
      ),
      child: Opacity(
        opacity: 0.05,
        child: Image.asset(
          'assets/images/matrix_bg.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withAlpha(51),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: child,
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.05, end: 0);
  }

  Widget _buildSectionTitle({required String title, required IconData icon}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(26),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.blue.shade300, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionContent(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 15,
        height: 1.6,
        color: Colors.white.withAlpha(230),
      ),
    );
  }

  Widget _buildPortfolioButton() {
    return ElevatedButton.icon(
      onPressed: () => _launchUrl('https://samportfoliope.vercel.app'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      icon: const Icon(Icons.open_in_new, size: 18),
      label: Text(
        'Acessar Portfólio',
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir o link'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
