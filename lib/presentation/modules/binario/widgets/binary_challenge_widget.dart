import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../binario_perguntas.dart';

class BinaryChallengeWidget extends StatefulWidget {
  final bool questionType; // true = binário para decimal, false = decimal para binário
  final Function(bool isCorrect) onAnswer;
  final int currentQuestion; // Adicionado para forçar reconstrução quando mudar a pergunta

  const BinaryChallengeWidget({
    super.key,
    required this.questionType,
    required this.onAnswer,
    required this.currentQuestion,
  });

  @override
  State<BinaryChallengeWidget> createState() => _BinaryChallengeWidgetState();
}

class _BinaryChallengeWidgetState extends State<BinaryChallengeWidget> {
  late int correctAnswer;
  late List<int> options;
  late String questionValue;
  bool _hasAnswered = false;
  int? _selectedOption;
  late String _correctBinary; // Para o modo decimal para binário
  final _binarioPerguntas = BinarioPerguntas();

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  @override
  void didUpdateWidget(BinaryChallengeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Regenerar a pergunta quando o número da pergunta atual mudar
    // Isso garante que uma nova pergunta seja gerada quando avançamos para a próxima questão
    if (widget.currentQuestion != oldWidget.currentQuestion) {
      _generateQuestion();
    }
  }

  void _generateQuestion() {
    // Resetar estado
    _hasAnswered = false;
    _selectedOption = null;
    
    // Usar a classe BinarioPerguntas para gerar a pergunta
    final pergunta = _binarioPerguntas.gerarPergunta(widget.questionType);
    
    questionValue = pergunta['questionValue'];
    correctAnswer = pergunta['correctAnswer'];
    options = List<int>.from(pergunta['options']);
    
    if (!widget.questionType) {
      // Para o modo decimal para binário, armazenar o binário correto
      _correctBinary = pergunta['correctBinary'];
    }
    
    // Embaralhar opções
    options.shuffle();
  }

  // Métodos de conversão e geração de opções foram movidos para a classe BinarioPerguntas

  void _checkAnswer(int selectedIndex) {
    if (_hasAnswered) return;
    
    setState(() {
      _hasAnswered = true;
      _selectedOption = selectedIndex;
    });
    
    // Usar a classe BinarioPerguntas para verificar a resposta
    final isCorrect = _binarioPerguntas.verificarResposta(
      widget.questionType,
      options[selectedIndex],
      correctAnswer
    );
    
    // Notificar o resultado
    widget.onAnswer(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Valor da pergunta
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.questionType ? "Binário: " : "Decimal: ",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Text(
                questionValue,
                style: GoogleFonts.orbitron(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        
        // Opções
        ...List.generate(options.length, (index) {
          final option = options[index];
          final displayValue = widget.questionType 
              ? option.toString() 
              : _binarioPerguntas.decimalToBinary(option);
          
          final isSelected = _selectedOption == index;
          final isCorrect = widget.questionType
              ? option == correctAnswer
              : _binarioPerguntas.decimalToBinary(option) == _binarioPerguntas.decimalToBinary(correctAnswer);
          
          // Determinar cor do botão
          Color buttonColor;
          if (_hasAnswered) {
            if (isSelected) {
              buttonColor = isCorrect ? Colors.green.shade700 : Colors.red.shade700;
            } else {
              buttonColor = isCorrect ? Colors.green.shade700.withOpacity(0.5) : Colors.white.withOpacity(0.1);
            }
          } else {
            buttonColor = Colors.white.withOpacity(0.1);
          }
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: _hasAnswered ? null : () => _checkAnswer(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_hasAnswered && isCorrect)
                    const Icon(Icons.check_circle, color: Colors.white),
                  if (_hasAnswered && isSelected && !isCorrect)
                    const Icon(Icons.cancel, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    displayValue,
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}