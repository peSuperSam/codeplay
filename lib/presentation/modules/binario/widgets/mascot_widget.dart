import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum MascotMood { neutral, happy, sad, thinking }

class MascotWidget extends StatelessWidget {
  final MascotMood mood;
  final String? message;
  final bool showSpeechBubble;

  const MascotWidget({
    super.key,
    this.mood = MascotMood.neutral,
    this.message,
    this.showSpeechBubble = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mascote animado
        Lottie.asset(
          'assets/lottie/mascote_animado.json',
          width: 100,
          height: 100,
          // Adicionar controle de animação baseado no humor
          delegates: LottieDelegates(
            values: [
              // Exemplo de controle de valores da animação
              // Isso depende da estrutura do arquivo Lottie
              ValueDelegate.color(
                const ['**'],
                value: _getMoodColor(),
              ),
            ],
          ),
        ),
        
        // Balão de fala (opcional)
        if (showSpeechBubble && message != null) ...[  
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                message!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.2, end: 0),
          ),
        ],
      ],
    );
  }

  // Retorna cor baseada no humor do mascote
  Color _getMoodColor() {
    switch (mood) {
      case MascotMood.happy:
        return Colors.green.shade300;
      case MascotMood.sad:
        return Colors.blue.shade300;
      case MascotMood.thinking:
        return Colors.amber.shade300;
      case MascotMood.neutral:
      default:
        return Colors.white;
    }
  }

  // Retorna mensagem baseada no humor (caso não tenha sido fornecida)
  String _getDefaultMessage() {
    switch (mood) {
      case MascotMood.happy:
        return "Muito bem! Você acertou!";
      case MascotMood.sad:
        return "Ops! Tente novamente. Você consegue!";
      case MascotMood.thinking:
        return "Hmm... Vamos pensar juntos?";
      case MascotMood.neutral:
      default:
        return "Vamos aprender sobre números binários?";
    }
  }
}