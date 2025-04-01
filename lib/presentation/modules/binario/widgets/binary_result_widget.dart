import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BinaryResultWidget extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const BinaryResultWidget({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions) * 100;
    final resultMessage = _getResultMessage(percentage);
    final stars = _calculateStars(percentage);
    
    return Column(
      children: [
        // Pontuação
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            children: [
              Text(
                "$score/$totalQuestions",
                style: GoogleFonts.orbitron(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${percentage.toInt()}%",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Estrelas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isActive = index < stars;
            return Icon(
              Icons.star,
              size: 40,
              color: isActive ? Colors.amber : Colors.grey.shade700,
            ).animate(delay: Duration(milliseconds: 300 * index))
              .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.2, 1.2), duration: 300.ms)
              .then()
              .scale(begin: const Offset(1.2, 1.2), end: const Offset(1.0, 1.0), duration: 150.ms);
          }),
        ),
        const SizedBox(height: 16),
        
        // Mensagem
        Text(
          resultMessage,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 1000.ms),
      ],
    );
  }

  String _getResultMessage(double percentage) {
    if (percentage >= 90) {
      return "Excelente! Você domina o sistema binário!";
    } else if (percentage >= 70) {
      return "Muito bom! Você está quase lá!";
    } else if (percentage >= 50) {
      return "Bom trabalho! Continue praticando.";
    } else {
      return "Continue tentando! A prática leva à perfeição.";
    }
  }

  int _calculateStars(double percentage) {
    if (percentage >= 80) {
      return 3;
    } else if (percentage >= 50) {
      return 2;
    } else if (percentage >= 20) {
      return 1;
    } else {
      return 0;
    }
  }
}