class AppConstants {
  // Texto da aplicação
  static const String appName = 'CodePlay';
  static const String appDescription =
      'Aplicativo educacional interativo para ensino de conceitos de codificação digital.';

  // Rotas nomeadas
  static const String homeRoute = '/';
  static const String asciiRoute = '/ascii';
  static const String binaryRoute = '/binario';
  static const String rgbRoute = '/rgb';
  static const String configRoute = '/config';
  static const String resultsRoute = '/resultados';

  // Mensagens de erro
  static const String generalErrorMessage =
      'Ocorreu um erro inesperado. Tente novamente.';
  static const String connectionErrorMessage =
      'Erro de conexão. Verifique sua internet.';
  static const String invalidInputMessage =
      'Entrada inválida. Verifique os dados informados.';

  // Assets
  static const String matrixBgImage = 'assets/images/matrix_bg.png';
  static const String mascoteImage = 'assets/images/mascote.png';
  static const String clickSoundPath = 'assets/sounds/click.mp3';

  // Configurações de jogo
  static const int defaultTimeLimit = 60; // segundos
  static const int maxQuestions = 10;

  // Frases educativas
  static const List<String> educationalPhrases = [
    "Sabia que o número 65 representa a letra A?",
    "Você já viu um pixel azul hoje?",
    "Vamos decifrar códigos juntos!",
    "Tudo começa com 0 e 1!",
    "As cores são feitas de números!",
    "O computador só entende 0 e 1 — é assim que ele pensa!",
    "Textos viram números para o computador entender.",
    "A letra 'A' é 65 em ASCII. Que loucura, né?",
    "Cores no computador são só combinações de vermelho, verde e azul!",
    "Uma imagem digital é feita de pixels codificados.",
    "Aprender código é como aprender a língua do computador.",
    "Tudo que digitamos é transformado em números binários.",
    "Você sabia que o branco é 255, 255, 255 em RGB?",
    "Com binário, dá pra representar qualquer número!",
    "A cor azul puro é RGB(0, 0, 255).",
    "Representar dados é essencial para armazenar e transmitir informações.",
    "Vamos codificar letras, cores e números — tudo com lógica!",
  ];
}
