import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../binario_perguntas.dart';

class BinaryChallengeWidget extends StatefulWidget {
  final bool isBinaryToDecimal;
  final Function(bool isCorrect) onAnswer;
  final int currentQuestion;
  final int difficulty;

  const BinaryChallengeWidget({
    super.key,
    required this.isBinaryToDecimal,
    required this.onAnswer,
    required this.currentQuestion,
    this.difficulty = 1,
  });

  @override
  State<BinaryChallengeWidget> createState() => _BinaryChallengeWidgetState();
}

class _BinaryChallengeWidgetState extends State<BinaryChallengeWidget> {
  late BinaryQuestion question;
  bool _hasAnswered = false;
  int? _selectedOption;
  final _binarioPerguntas = BinarioPerguntas();

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  @override
  void didUpdateWidget(BinaryChallengeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentQuestion != oldWidget.currentQuestion ||
        widget.difficulty != oldWidget.difficulty ||
        widget.isBinaryToDecimal != oldWidget.isBinaryToDecimal) {
      _generateQuestion();
    }
  }

  void _generateQuestion() {
    // Resetar estado
    setState(() {
      _hasAnswered = false;
      _selectedOption = null;

      // Usar a classe BinarioPerguntas para gerar a pergunta
      question = _binarioPerguntas.gerarPergunta(
        questionType: widget.isBinaryToDecimal,
        difficulty: widget.difficulty,
      );
    });
  }

  void _checkAnswer(int selectedIndex) {
    if (_hasAnswered) return;

    final selectedOption = question.options[selectedIndex];
    final isCorrect = question.isCorrect(selectedOption);

    setState(() {
      _hasAnswered = true;
      _selectedOption = selectedIndex;
    });

    // Delay para permitir que o usuário veja o resultado antes de avançar
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        // Notificar o resultado
        widget.onAnswer(isCorrect);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildQuestionHeader(),
        const SizedBox(height: 32),
        _buildOptions(),
      ],
    );
  }

  Widget _buildQuestionHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withAlpha(77), // 0.3 * 255 = ~77
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            widget.isBinaryToDecimal
                ? "Converta para Decimal"
                : "Converta para Binário",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withAlpha(230), // 0.9 * 255 = ~230
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.isBinaryToDecimal ? Icons.code : Icons.numbers,
                color: Colors.white.withAlpha(230),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                    question.questionValue,
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  )
                  .animate(key: ValueKey(question.questionValue))
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.2, end: 0, duration: 400.ms),
            ],
          ),
          const SizedBox(height: 8),
          _buildDifficultyIndicator(),
        ],
      ),
    );
  }

  Widget _buildDifficultyIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isActive = index < widget.difficulty;
        return Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.amber : Colors.grey.shade700,
          ),
        );
      }),
    );
  }

  Widget _buildOptions() {
    return Column(
      children: List.generate(question.options.length, (index) {
        final option = question.options[index];
        final displayValue = question.getDisplayValue(option);

        final isSelected = _selectedOption == index;
        final isCorrect = question.isCorrect(option);

        // Determinar cor e estilo do botão
        Color buttonColor;
        Color borderColor;
        double elevation = 4.0;
        double borderWidth = 1.5;

        if (_hasAnswered) {
          if (isSelected) {
            buttonColor =
                isCorrect ? Colors.green.shade700 : Colors.red.shade700;
            borderColor = Colors.white;
            elevation = 2.0;
            borderWidth = 2.0;
          } else {
            buttonColor =
                isCorrect
                    ? Colors.green.shade700.withAlpha(77)
                    : Colors.blue.shade900.withAlpha(51);
            borderColor =
                isCorrect
                    ? Colors.green.shade200.withAlpha(128)
                    : Colors.white.withAlpha(51);
            elevation = 2.0;
          }
        } else {
          buttonColor = Colors.blue.shade900.withAlpha(51);
          borderColor = Colors.white.withAlpha(77);
          elevation = 4.0;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ElevatedButton(
                onPressed: _hasAnswered ? null : () => _checkAnswer(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: borderColor, width: borderWidth),
                  elevation: elevation,
                  shadowColor: Colors.black.withAlpha(128),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_hasAnswered && isCorrect)
                      Icon(Icons.check_circle, color: Colors.white)
                          .animate()
                          .scale(duration: 400.ms, curve: Curves.elasticOut),
                    if (_hasAnswered && isSelected && !isCorrect)
                      Icon(Icons.cancel, color: Colors.white).animate().shake(
                        duration: 400.ms,
                        curve: Curves.easeInOut,
                      ),
                    const SizedBox(width: 8),
                    Text(
                      displayValue,
                      style: GoogleFonts.orbitron(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(
                duration: 400.ms,
                delay: Duration(milliseconds: 100 * index),
              )
              .slideX(
                begin: 0.1,
                end: 0,
                duration: 400.ms,
                delay: Duration(milliseconds: 100 * index),
                curve: Curves.easeOutCubic,
              ),
        );
      }),
    );
  }
}
