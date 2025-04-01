import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BinaryChallengeWidget extends StatefulWidget {
  final bool questionType; // true = binário para decimal, false = decimal para binário
  final Function(bool isCorrect) onAnswer;

  const BinaryChallengeWidget({
    super.key,
    required this.questionType,
    required this.onAnswer,
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

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  @override
  void didUpdateWidget(BinaryChallengeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionType != widget.questionType) {
      _generateQuestion();
    }
  }

  void _generateQuestion() {
    final random = Random();
    
    // Resetar estado
    _hasAnswered = false;
    _selectedOption = null;
    
    if (widget.questionType) {
      // Binário para decimal
      // Gerar um número binário de até 5 dígitos (máximo 31 em decimal)
      final binaryLength = random.nextInt(3) + 3; // 3 a 5 dígitos
      final binaryDigits = List.generate(binaryLength, (_) => random.nextInt(2));
      
      // Garantir que não comece com 0
      if (binaryDigits[0] == 0 && binaryLength > 1) {
        binaryDigits[0] = 1;
      }
      
      // Converter para string
      questionValue = binaryDigits.join();
      
      // Calcular o valor decimal correto
      correctAnswer = _binaryToDecimal(questionValue);
      
      // Gerar opções erradas
      options = _generateWrongOptions(correctAnswer, 31);
    } else {
      // Decimal para binário
      // Gerar um número decimal de 1 a 31
      correctAnswer = random.nextInt(30) + 1;
      questionValue = correctAnswer.toString();
      
      // Converter para binário
      final correctBinary = _decimalToBinary(correctAnswer);
      
      // Gerar opções erradas (em binário)
      final wrongOptions = _generateWrongBinaryOptions(correctBinary);
      
      // Converter todas as opções para decimal para armazenar
      options = [
        _binaryToDecimal(correctBinary),
        _binaryToDecimal(wrongOptions[0]),
        _binaryToDecimal(wrongOptions[1]),
      ];
    }
    
    // Embaralhar opções
    options.shuffle();
  }

  // Converter binário para decimal
  int _binaryToDecimal(String binary) {
    int decimal = 0;
    for (int i = 0; i < binary.length; i++) {
      if (binary[i] == '1') {
        decimal += 1 << (binary.length - i - 1);
      }
    }
    return decimal;
  }

  // Converter decimal para binário
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

  // Gerar opções erradas para decimal
  List<int> _generateWrongOptions(int correctAnswer, int maxValue) {
    final random = Random();
    final Set<int> wrongOptions = {};
    
    while (wrongOptions.length < 2) {
      int wrongOption;
      
      // Gerar opção próxima ao valor correto
      if (random.nextBool() && wrongOptions.isEmpty) {
        // Opção próxima (±3)
        final offset = random.nextInt(3) + 1;
        wrongOption = random.nextBool() 
            ? correctAnswer + offset 
            : max(1, correctAnswer - offset);
      } else {
        // Opção aleatória
        wrongOption = random.nextInt(maxValue) + 1;
      }
      
      // Garantir que não seja igual à resposta correta
      if (wrongOption != correctAnswer && wrongOption > 0 && wrongOption <= maxValue) {
        wrongOptions.add(wrongOption);
      }
    }
    
    return [correctAnswer, ...wrongOptions.toList()];
  }

  // Gerar opções erradas para binário
  List<String> _generateWrongBinaryOptions(String correctBinary) {
    final random = Random();
    final wrongOptions = <String>[];
    
    while (wrongOptions.length < 2) {
      String wrongOption;
      
      if (random.nextBool() && wrongOptions.isEmpty) {
        // Modificar um bit do binário correto
        final binaryList = correctBinary.split('');
        final indexToChange = random.nextInt(binaryList.length);
        binaryList[indexToChange] = binaryList[indexToChange] == '0' ? '1' : '0';
        wrongOption = binaryList.join();
      } else {
        // Gerar um binário aleatório de tamanho similar
        final length = correctBinary.length + (random.nextInt(3) - 1);
        final digits = List.generate(max(1, length), (_) => random.nextInt(2).toString());
        wrongOption = digits.join();
        
        // Garantir que não comece com 0 se tiver mais de 1 dígito
        if (wrongOption.startsWith('0') && wrongOption.length > 1) {
          final chars = wrongOption.split('');
          chars[0] = '1';
          wrongOption = chars.join();
        }
      }
      
      // Garantir que não seja igual à resposta correta
      if (wrongOption != correctBinary && wrongOption.isNotEmpty) {
        wrongOptions.add(wrongOption);
      }
    }
    
    return wrongOptions;
  }

  void _checkAnswer(int selectedIndex) {
    if (_hasAnswered) return;
    
    setState(() {
      _hasAnswered = true;
      _selectedOption = selectedIndex;
    });
    
    final isCorrect = widget.questionType
        ? options[selectedIndex] == correctAnswer
        : _decimalToBinary(options[selectedIndex]) == _decimalToBinary(correctAnswer);
    
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
              : _decimalToBinary(option);
          
          final isSelected = _selectedOption == index;
          final isCorrect = widget.questionType
              ? option == correctAnswer
              : _decimalToBinary(option) == _decimalToBinary(correctAnswer);
          
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