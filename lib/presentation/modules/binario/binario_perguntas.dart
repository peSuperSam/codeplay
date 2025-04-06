import 'dart:math';

/// Modelo para uma pergunta binária
class BinaryQuestion {
  /// Valor apresentado na pergunta (binário ou decimal)
  final String questionValue;

  /// Resposta correta em decimal
  final int correctAnswer;

  /// Resposta correta em binário
  final String correctBinary;

  /// Lista de opções embaralhadas (em decimal)
  final List<int> options;

  /// Se a pergunta é de binário para decimal (true) ou decimal para binário (false)
  final bool isBinaryToDecimal;

  /// Dificuldade da pergunta (1 a 3)
  final int difficulty;

  BinaryQuestion({
    required this.questionValue,
    required this.correctAnswer,
    required this.correctBinary,
    required this.options,
    required this.isBinaryToDecimal,
    this.difficulty = 1,
  });

  /// Verifica se a opção selecionada está correta
  bool isCorrect(int selectedOption) {
    if (isBinaryToDecimal) {
      return selectedOption == correctAnswer;
    } else {
      return BinarioPerguntas().decimalToBinary(selectedOption) ==
          correctBinary;
    }
  }

  /// Retorna o valor a ser exibido para uma opção
  String getDisplayValue(int option) {
    return isBinaryToDecimal
        ? option.toString()
        : BinarioPerguntas().decimalToBinary(option);
  }
}

/// Serviço para gerenciamento de perguntas binárias
class BinarioPerguntas {
  // Singleton para garantir uma única instância
  static final BinarioPerguntas _instance = BinarioPerguntas._internal();

  factory BinarioPerguntas() {
    return _instance;
  }

  BinarioPerguntas._internal();

  final _random = Random();

  /// Nível máximo suportado (1-3)
  int maxLevel = 3;

  /// Método público para converter decimal para binário
  String decimalToBinary(int decimal) {
    return _decimalToBinary(decimal);
  }

  /// Método público para converter binário para decimal
  int binaryToDecimal(String binary) {
    return _binaryToDecimal(binary);
  }

  /// Gera uma pergunta binária
  /// [questionType] true = binário para decimal, false = decimal para binário
  /// [difficulty] Nível de dificuldade da pergunta (1-3)
  BinaryQuestion gerarPergunta({
    required bool questionType,
    int difficulty = 1,
  }) {
    difficulty = difficulty.clamp(1, maxLevel);

    if (questionType) {
      return _gerarPerguntaBinarioParaDecimal(difficulty);
    } else {
      return _gerarPerguntaDecimalParaBinario(difficulty);
    }
  }

  /// Gera uma pergunta de binário para decimal com dificuldade ajustável
  BinaryQuestion _gerarPerguntaBinarioParaDecimal(int difficulty) {
    // Ajustar tamanho do binário conforme dificuldade
    final int minLength = difficulty + 2; // 3, 4, 5
    final int maxLength = difficulty + 3; // 4, 5, 6

    final binaryLength = _random.nextInt(maxLength - minLength + 1) + minLength;
    final binaryDigits = List.generate(binaryLength, (_) => _random.nextInt(2));

    // Garantir que não comece com 0 se tiver mais de 1 dígito
    if (binaryDigits[0] == 0 && binaryLength > 1) {
      binaryDigits[0] = 1;
    }

    // Converter para string
    final questionValue = binaryDigits.join();

    // Calcular o valor decimal correto
    final correctAnswer = _binaryToDecimal(questionValue);

    // Calcular valor máximo conforme dificuldade
    final maxValue = difficulty == 1 ? 31 : (difficulty == 2 ? 63 : 127);

    // Gerar opções erradas
    final options = _generateWrongOptions(correctAnswer, maxValue);

    return BinaryQuestion(
      questionValue: questionValue,
      correctAnswer: correctAnswer,
      correctBinary: questionValue,
      options: options,
      isBinaryToDecimal: true,
      difficulty: difficulty,
    );
  }

  /// Gera uma pergunta de decimal para binário com dificuldade ajustável
  BinaryQuestion _gerarPerguntaDecimalParaBinario(int difficulty) {
    // Ajustar intervalo conforme dificuldade
    final int maxValue = difficulty == 1 ? 31 : (difficulty == 2 ? 63 : 127);
    final int minValue = difficulty == 1 ? 1 : (difficulty == 2 ? 16 : 32);

    // Gerar um número decimal no intervalo definido
    final correctAnswer = _random.nextInt(maxValue - minValue + 1) + minValue;
    final questionValue = correctAnswer.toString();

    // Converter para binário
    final correctBinary = _decimalToBinary(correctAnswer);

    // Gerar opções erradas (em binário)
    final wrongOptions = _generateWrongBinaryOptions(correctBinary, difficulty);

    // Converter todas as opções para decimal para armazenar
    final options = [
      correctAnswer,
      _binaryToDecimal(wrongOptions[0]),
      _binaryToDecimal(wrongOptions[1]),
    ];

    // Embaralhar as opções
    options.shuffle();

    return BinaryQuestion(
      questionValue: questionValue,
      correctAnswer: correctAnswer,
      correctBinary: correctBinary,
      options: options,
      isBinaryToDecimal: false,
      difficulty: difficulty,
    );
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
    final Set<int> wrongOptions = {};

    while (wrongOptions.length < 2) {
      int wrongOption;

      // Gerar opção próxima ao valor correto
      if (_random.nextBool() && wrongOptions.isEmpty) {
        // Opção próxima (±3)
        final offset = _random.nextInt(3) + 1;
        wrongOption =
            _random.nextBool()
                ? correctAnswer + offset
                : (correctAnswer - offset).clamp(1, maxValue);
      } else {
        // Opção aleatória
        wrongOption = _random.nextInt(maxValue) + 1;
      }

      // Garantir que não seja igual à resposta correta
      if (wrongOption != correctAnswer &&
          wrongOption > 0 &&
          wrongOption <= maxValue) {
        wrongOptions.add(wrongOption);
      }
    }

    return [correctAnswer, ...wrongOptions];
  }

  // Gerar opções erradas para binário, considerando a dificuldade
  List<String> _generateWrongBinaryOptions(
    String correctBinary,
    int difficulty,
  ) {
    final wrongOptions = <String>[];

    while (wrongOptions.length < 2) {
      String wrongOption;

      // Aumenta a probabilidade de modificação de bits conforme a dificuldade
      if (_random.nextDouble() < (0.3 + difficulty * 0.2) &&
          wrongOptions.isEmpty) {
        // Modificar um bit do binário correto (ou dois bits em dificuldades maiores)
        final binaryList = correctBinary.split('');
        final bitsToChange = difficulty == 1 ? 1 : _random.nextInt(2) + 1;

        for (int i = 0; i < bitsToChange; i++) {
          final indexToChange = _random.nextInt(binaryList.length);
          binaryList[indexToChange] =
              binaryList[indexToChange] == '0' ? '1' : '0';
        }
        wrongOption = binaryList.join();
      } else {
        // Gerar um binário aleatório de tamanho similar
        final lengthDelta = _random.nextInt(3) - 1;
        final length = (correctBinary.length + lengthDelta).clamp(
          difficulty + 1,
          correctBinary.length + difficulty,
        );

        final digits = List.generate(
          length,
          (_) => _random.nextInt(2).toString(),
        );
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
}
