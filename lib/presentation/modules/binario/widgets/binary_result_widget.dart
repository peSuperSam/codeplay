import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class BinaryResultWidget extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int highestDifficulty;
  final VoidCallback onPlayAgain;
  final VoidCallback onNextLevel;

  const BinaryResultWidget({
    super.key,
    required this.score,
    required this.totalQuestions,
    this.highestDifficulty = 1,
    required this.onPlayAgain,
    required this.onNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions) * 100;
    final resultMessage = _getResultMessage(percentage);
    final stars = _calculateStars(percentage);
    final bool canAdvance = stars >= 2 && highestDifficulty < 3;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withAlpha(77),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.blue.shade200.withAlpha(51), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "RESULTADO",
            style: GoogleFonts.orbitron(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),

          const SizedBox(height: 24),

          // Animação de Lottie para o resultado
          SizedBox(
            height: 120,
            child:
                stars >= 2
                    ? Lottie.network(
                      'https://assets8.lottiefiles.com/packages/lf20_touohxv0.json',
                      repeat: true,
                    )
                    : Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_qvbjudqz.json',
                      repeat: true,
                    ),
          ),

          const SizedBox(height: 24),

          // Pontuação
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(77), blurRadius: 4),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emoji_events, color: Colors.amber, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      "$score/$totalQuestions",
                      style: GoogleFonts.orbitron(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn(duration: 800.ms, delay: 500.ms),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getScoreColor(percentage),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${percentage.toInt()}%",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ).animate().fadeIn(duration: 800.ms, delay: 700.ms),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Estrelas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isActive = index < stars;
              return Icon(
                    Icons.star,
                    size: 48,
                    color: isActive ? Colors.amber : Colors.grey.shade700,
                  )
                  .animate(delay: Duration(milliseconds: 300 * index + 1000))
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.3, 1.3),
                    duration: 400.ms,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.3, 1.3),
                    end: const Offset(1.0, 1.0),
                    duration: 200.ms,
                  );
            }),
          ),

          const SizedBox(height: 24),

          // Mensagem
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade800.withAlpha(77),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              resultMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 1500.ms),

          const SizedBox(height: 32),

          // Botões de ação
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: onPlayAgain,
                icon: Icon(Icons.replay),
                label: Text("Jogar Novamente"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ).animate().fadeIn(delay: 1800.ms, duration: 400.ms),

              if (canAdvance) ...[
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: onNextLevel,
                  icon: Icon(Icons.arrow_upward),
                  label: Text("Próximo Nível"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate().fadeIn(delay: 2000.ms, duration: 400.ms),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _getResultMessage(double percentage) {
    if (percentage >= 90) {
      return "Excelente! Você domina o sistema binário! Suas habilidades estão impressionantes!";
    } else if (percentage >= 70) {
      return "Muito bom! Você está quase lá! Continue praticando para se tornar um mestre em binário.";
    } else if (percentage >= 50) {
      return "Bom trabalho! Você está no caminho certo. Com mais prática, você dominará o sistema binário.";
    } else if (percentage >= 30) {
      return "Você está progredindo! Continue tentando, a prática leva à perfeição.";
    } else {
      return "Não desista! O sistema binário pode ser desafiador no início, mas você vai conseguir dominar com persistência.";
    }
  }

  int _calculateStars(double percentage) {
    if (percentage >= 80) {
      return 3;
    } else if (percentage >= 50) {
      return 2;
    } else if (percentage >= 30) {
      return 1;
    } else {
      return 0;
    }
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) {
      return Colors.green.shade700;
    } else if (percentage >= 50) {
      return Colors.orange.shade700;
    } else {
      return Colors.red.shade700;
    }
  }
}
