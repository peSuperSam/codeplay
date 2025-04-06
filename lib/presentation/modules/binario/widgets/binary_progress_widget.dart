import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BinaryProgressWidget extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int score;
  final int difficulty;
  final bool isTimerMode;
  final int remainingTime;

  const BinaryProgressWidget({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.score,
    required this.difficulty,
    this.isTimerMode = false,
    this.remainingTime = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withAlpha(51),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.shade200.withAlpha(51),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Progresso do quiz
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Contador de perguntas
              Row(
                children: [
                  Icon(Icons.quiz, color: Colors.amber, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "$currentQuestion/$totalQuestions",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              // Pontuação
              Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "$score",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              // Nível
              Row(
                children: [
                  Icon(
                    difficulty == 1
                        ? Icons.filter_1
                        : difficulty == 2
                        ? Icons.filter_2
                        : Icons.filter_3,
                    color: Colors.amber,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    difficulty == 1
                        ? "Fácil"
                        : difficulty == 2
                        ? "Médio"
                        : "Difícil",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Barra de progresso
          LinearProgressIndicator(
            value: currentQuestion / totalQuestions,
            backgroundColor: Colors.grey.shade800,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getProgressColor(currentQuestion / totalQuestions),
            ),
            borderRadius: BorderRadius.circular(4),
            minHeight: 8,
          ),

          // Timer (se estiver ativado)
          if (isTimerMode)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _getTimerColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                        "$remainingTime s",
                        style: GoogleFonts.orbitron(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                      .animate(key: ValueKey(remainingTime))
                      .fadeIn(duration: 200.ms)
                      .scale(
                        begin:
                            remainingTime <= 5
                                ? const Offset(1.2, 1.2)
                                : const Offset(1.0, 1.0),
                        end: const Offset(1.0, 1.0),
                        duration: 300.ms,
                      ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) {
      return Colors.red.shade400;
    } else if (progress < 0.7) {
      return Colors.orange.shade400;
    } else {
      return Colors.green.shade400;
    }
  }

  Color _getTimerColor() {
    if (remainingTime <= 5) {
      return Colors.red.shade700;
    } else if (remainingTime <= 10) {
      return Colors.orange.shade700;
    } else {
      return Colors.blue.shade700;
    }
  }
}
