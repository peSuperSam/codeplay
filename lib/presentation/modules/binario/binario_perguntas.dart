import 'dart:math';

class BinarioPerguntas {
  // Singleton para garantir uma única instância
  static final BinarioPerguntas _instance = BinarioPerguntas._internal();
  
  factory BinarioPerguntas() {
    return _instance;
  }
  
  BinarioPerguntas._internal();
  
  final _random = Random();
  
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
  /// Retorna um mapa com os dados da pergunta
  Map<String, dynamic> gerarPergunta(bool questionType) {
    if (questionType) {
      return _gerarPerguntaBinarioParaDecimal();
    } else {
      return _gerarPerguntaDecimalParaBinario();
    }
  }
  
  /// Gera uma pergunta de binário para decimal
  Map<String, dynamic> _gerarPerguntaBinarioParaDecimal() {
    // Gerar um número binário de até 5 dígitos (máximo 31 em decimal)
    final binaryLength = _random.nextInt(3) + 3; // 3 a 5 dígitos
    final binaryDigits = List.generate(binaryLength, (_) => _random.nextInt(2));
    
    // Garantir que não comece com 0
    if (binaryDigits[0] == 0 && binaryLength > 1) {
      binaryDigits[0] = 1;
    }
    
    // Converter para string
    final questionValue = binaryDigits.join();
    
    // Calcular o valor decimal correto
    final correctAnswer = _binaryToDecimal(questionValue);
    
    // Gerar opções erradas
    final options = _generateWrongOptions(correctAnswer, 31);
    
    return {
      'questionValue': questionValue,
      'correctAnswer': correctAnswer,
      'options': options,
    };
  }
  
  /// Gera uma pergunta de decimal para binário
  Map<String, dynamic> _gerarPerguntaDecimalParaBinario() {
    // Gerar um número decimal de 1 a 31
    final correctAnswer = _random.nextInt(30) + 1;
    final questionValue = correctAnswer.toString();
    
    // Converter para binário
    final correctBinary = _decimalToBinary(correctAnswer);
    
    // Gerar opções erradas (em binário)
    final wrongOptions = _generateWrongBinaryOptions(correctBinary);
    
    // Converter todas as opções para decimal para armazenar
    final options = [
      _binaryToDecimal(correctBinary),
      _binaryToDecimal(wrongOptions[0]),
      _binaryToDecimal(wrongOptions[1]),
    ];
    
    return {
      'questionValue': questionValue,
      'correctAnswer': correctAnswer,
      'correctBinary': correctBinary,
      'options': options,
    };
  }
  
  /// Verifica se a resposta está correta
  /// [questionType] true = binário para decimal, false = decimal para binário
  /// [selectedOption] opção selecionada pelo usuário
  /// [correctAnswer] resposta correta
  bool verificarResposta(bool questionType, int selectedOption, int correctAnswer) {
    if (questionType) {
      return selectedOption == correctAnswer;
    } else {
      return _decimalToBinary(selectedOption) == _decimalToBinary(correctAnswer);
    }
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
        wrongOption = _random.nextBool() 
            ? correctAnswer + offset 
            : (correctAnswer - offset).clamp(1, maxValue);
      } else {
        // Opção aleatória
        wrongOption = _random.nextInt(maxValue) + 1;
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
    final wrongOptions = <String>[];
    
    while (wrongOptions.length < 2) {
      String wrongOption;
      
      if (_random.nextBool() && wrongOptions.isEmpty) {
        // Modificar um bit do binário correto
        final binaryList = correctBinary.split('');
        final indexToChange = _random.nextInt(binaryList.length);
        binaryList[indexToChange] = binaryList[indexToChange] == '0' ? '1' : '0';
        wrongOption = binaryList.join();
      } else {
        // Gerar um binário aleatório de tamanho similar
        final length = correctBinary.length + (_random.nextInt(3) - 1);
        final digits = List.generate((length > 0 ? length : 1), (_) => _random.nextInt(2).toString());
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