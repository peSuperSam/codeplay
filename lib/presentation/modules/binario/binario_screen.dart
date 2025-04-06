import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'widgets/binary_challenge_widget.dart';
import 'widgets/binary_result_widget.dart';
import 'widgets/binary_settings_widget.dart';
import 'widgets/binary_progress_widget.dart';
import '../../shared/widgets/mascote_widget.dart';

// Estado do jogo
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((
  ref,
) {
  return GameStateNotifier();
});

class GameState {
  final int score;
  final int currentQuestion;
  final int totalQuestions;
  final bool isGameOver;
  final bool isTimerMode;
  final int remainingTime;
  final MascotMood mascotMood;
  final bool isBinaryToDecimal;
  final int difficulty;
  final int highestDifficulty;

  GameState({
    this.score = 0,
    this.currentQuestion = 0,
    this.totalQuestions = 10,
    this.isGameOver = false,
    this.isTimerMode = false,
    this.remainingTime = 30,
    this.mascotMood = MascotMood.neutral,
    this.isBinaryToDecimal = true,
    this.difficulty = 1,
    this.highestDifficulty = 5,
  });

  GameState copyWith({
    int? score,
    int? currentQuestion,
    int? totalQuestions,
    bool? isGameOver,
    bool? isTimerMode,
    int? remainingTime,
    MascotMood? mascotMood,
    bool? isBinaryToDecimal,
    int? difficulty,
    int? highestDifficulty,
  }) {
    return GameState(
      score: score ?? this.score,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isGameOver: isGameOver ?? this.isGameOver,
      isTimerMode: isTimerMode ?? this.isTimerMode,
      remainingTime: remainingTime ?? this.remainingTime,
      mascotMood: mascotMood ?? this.mascotMood,
      isBinaryToDecimal: isBinaryToDecimal ?? this.isBinaryToDecimal,
      difficulty: difficulty ?? this.difficulty,
      highestDifficulty: highestDifficulty ?? this.highestDifficulty,
    );
  }
}

enum MascotMood { neutral, happy, sad, thinking }

class GameStateNotifier extends StateNotifier<GameState> {
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  GameStateNotifier() : super(GameState());

  void startGame({bool timerMode = false}) {
    state = GameState(
      isTimerMode: timerMode,
      currentQuestion:
          1, // Define currentQuestion como 1 para mostrar o desafio imediatamente
    );

    if (timerMode) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime <= 1) {
        timer.cancel();
        state = state.copyWith(isGameOver: true, remainingTime: 0);
      } else {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
      }
    });
  }

  void answerQuestion(bool isCorrect) async {
    if (isCorrect) {
      // Tocar som de acerto
      await _audioPlayer.play(AssetSource('sounds/click.mp3'));

      // Atualizar estado com pontuação e humor do mascote
      state = state.copyWith(
        score: state.score + 1,
        mascotMood: MascotMood.happy,
      );
    } else {
      // Atualizar estado com humor do mascote
      state = state.copyWith(mascotMood: MascotMood.sad);
    }

    // Aguardar um pouco antes de mudar para a próxima pergunta
    await Future.delayed(const Duration(milliseconds: 1500));

    // Verificar se o jogo acabou
    if (state.currentQuestion >= state.totalQuestions - 1) {
      state = state.copyWith(isGameOver: true);
      _timer?.cancel();
    } else {
      // Avançar para a próxima pergunta
      state = state.copyWith(
        currentQuestion: state.currentQuestion + 1,
        mascotMood: MascotMood.neutral,
      );
    }
  }

  void resetGame() {
    _timer?.cancel();
    state = GameState();
  }

  void restartGame() {
    resetGame();
    startGame();
  }

  void increaseDifficulty() {
    state = state.copyWith(difficulty: state.difficulty + 1);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}

class BinarioScreen extends ConsumerStatefulWidget {
  const BinarioScreen({super.key});

  @override
  ConsumerState<BinarioScreen> createState() => _BinarioScreenState();
}

class _BinarioScreenState extends ConsumerState<BinarioScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final gameNotifier = ref.read(gameStateProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, gameState),
      body: Stack(
        children: [
          // Fundo animado
          _buildAnimatedBackground(),

          // Conteúdo principal
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),

                      // Escolher qual conteúdo mostrar com base no estado do jogo
                      if (gameState.currentQuestion == 0)
                        _buildIntroContent(gameNotifier)
                      else if (gameState.isGameOver)
                        _buildResultContent(gameState, gameNotifier)
                      else
                        _buildGameContent(gameState, gameNotifier),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, GameState gameState) {
    return AppBar(
      title: Text(
        "Binário",
        style: GoogleFonts.orbitron(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          letterSpacing: 1.5,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading:
          gameState.currentQuestion > 0 && !gameState.isGameOver
              ? null // Remove o botão de voltar durante o quiz
              : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/'),
                tooltip: "Voltar",
              ),
      actions: [
        if (gameState.currentQuestion > 0 && !gameState.isGameOver)
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () => _showQuitConfirmationDialog(context),
            tooltip: "Finalizar quiz",
          ),
      ],
    );
  }

  Widget _buildIntroContent(GameStateNotifier gameNotifier) {
    return Column(
      children: [
        // Logo ou ícone do módulo
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.blue.shade900.withAlpha(51),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade900.withAlpha(77),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(Icons.memory, color: Colors.blue.shade300, size: 80),
        ).animate().scale(
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 600),
        ),

        const SizedBox(height: 24),

        // Título do módulo
        Text(
              "BINÁRIO",
              style: GoogleFonts.orbitron(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            )
            .animate()
            .fadeIn(duration: const Duration(milliseconds: 800))
            .slideY(begin: -0.2, end: 0),

        const SizedBox(height: 8),

        // Subtítulo ou descrição
        Text(
          "Aprenda a linguagem fundamental dos computadores",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white.withAlpha(204),
          ),
        ).animate().fadeIn(
          delay: const Duration(milliseconds: 400),
          duration: const Duration(milliseconds: 800),
        ),

        const SizedBox(height: 32),

        // Mascote com explicação
        MascoteWidget(
          message:
              "O sistema binário é a base da computação. Tudo em um computador é representado por 0s e 1s. Neste quiz, você vai praticar a conversão entre números binários e decimais. Está pronto para começar?",
          mascotType: MascotType.tip,
          animate: true,
        ),

        const SizedBox(height: 24),

        // Aviso para chamar atenção para a tabela
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.cyan.shade800.withAlpha(100),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.cyan.shade300.withAlpha(150)),
          ),
          child: Row(
            children: [
              Icon(Icons.new_releases, color: Colors.cyan.shade300, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "NOVO! Tabela de conversão binária disponível para consulta rápida!",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms),

        const SizedBox(height: 16),

        // Botão para acessar a tabela de conversão - DESTAQUE ESPECIAL
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Animate(
            effects: [
              FadeEffect(duration: 600.ms, delay: 300.ms),
              SlideEffect(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
                duration: 500.ms,
              ),
              ShakeEffect(duration: 1000.ms, delay: 1500.ms, hz: 3),
            ],
            child: ElevatedButton.icon(
              key: const Key('btn_tabela_binaria'),
              onPressed: () {
                context.go('/tabela-binaria');
              },
              icon: const Icon(Icons.table_chart, size: 28),
              label: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "VER TABELA DE CONVERSÃO BINÁRIA",
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 28,
                ),
                elevation: 12,
                shadowColor: Colors.red.shade900.withAlpha(180),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.yellow, width: 3),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Separador visual
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.blue.shade300.withAlpha(150),
                Colors.transparent,
              ],
            ),
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 600.ms),

        // Título "Iniciar Quiz"
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            "INICIAR QUIZ",
            style: GoogleFonts.orbitron(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 800.ms),

        // Widget de configurações do jogo
        BinarySettingsWidget(
          highestDifficulty: ref.read(gameStateProvider).highestDifficulty,
          onStart: (settings) {
            // Pegando apenas o parâmetro que é usado pelo método startGame
            final timerMode = settings['timerMode'] as bool;

            gameNotifier.startGame(timerMode: timerMode);
          },
        ),
      ],
    );
  }

  Widget _buildGameContent(
    GameState gameState,
    GameStateNotifier gameNotifier,
  ) {
    return Column(
      children: [
        // Barra de progresso
        BinaryProgressWidget(
          currentQuestion: gameState.currentQuestion,
          totalQuestions: gameState.totalQuestions,
          score: gameState.score,
          difficulty: gameState.difficulty,
          isTimerMode: gameState.isTimerMode,
          remainingTime: gameState.remainingTime,
        ),

        const SizedBox(height: 32),

        // Desafio binário
        BinaryChallengeWidget(
          isBinaryToDecimal: gameState.isBinaryToDecimal,
          currentQuestion: gameState.currentQuestion,
          difficulty: gameState.difficulty,
          onAnswer: (isCorrect) {
            gameNotifier.answerQuestion(isCorrect);
          },
        ),

        const SizedBox(height: 32),

        // Mascote com dica ou reação
        if (gameState.mascotMood != MascotMood.neutral)
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 400),
            child: MascoteWidget(
              message: _getMascotMessage(
                gameState.mascotMood,
                gameState.isBinaryToDecimal,
              ),
              mascotType: _getMascotType(gameState.mascotMood),
              animate: false,
            ),
          ),
      ],
    );
  }

  Widget _buildResultContent(
    GameState gameState,
    GameStateNotifier gameNotifier,
  ) {
    final percentage = (gameState.score / gameState.totalQuestions) * 100;
    final successLevel =
        percentage >= 70 ? "high" : (percentage >= 50 ? "medium" : "low");

    return Column(
      children: [
        // Título do resultado
        Text(
              "QUIZ COMPLETADO!",
              style: GoogleFonts.orbitron(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            )
            .animate()
            .fadeIn(duration: const Duration(milliseconds: 600))
            .slideY(begin: -0.2, end: 0),

        const SizedBox(height: 32),

        // Widget de resultado
        BinaryResultWidget(
          score: gameState.score,
          totalQuestions: gameState.totalQuestions,
          highestDifficulty: gameState.highestDifficulty,
          onPlayAgain: () {
            gameNotifier.restartGame();
          },
          onNextLevel: () {
            if (gameState.difficulty < gameState.highestDifficulty) {
              gameNotifier.increaseDifficulty();
            } else {
              gameNotifier.resetGame();
            }
          },
        ),

        const SizedBox(height: 32),

        // Mascote com mensagem final
        MascoteWidget(
          message: _getFinalMessage(gameState.score, gameState.totalQuestions),
          mascotType:
              successLevel == "high"
                  ? MascotType.success
                  : (successLevel == "low"
                      ? MascotType.error
                      : MascotType.normal),
          animate: true,
        ),

        const SizedBox(height: 20),

        // Botão para voltar ao menu principal
        ElevatedButton.icon(
          onPressed: () {
            gameNotifier.resetGame();
          },
          icon: const Icon(Icons.home),
          label: const Text("MENU PRINCIPAL"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ).animate().fadeIn(
          delay: const Duration(milliseconds: 2200),
          duration: const Duration(milliseconds: 400),
        ),
      ],
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF000C66),
            const Color(0xFF0000FF).withAlpha(102), // 0.4 * 255 = 102
            const Color(0xFF000C66),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(102),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Partículas de números binários flutuando
          Positioned.fill(
            child: CustomPaint(
              painter: _BinaryParticlesPainter(
                animationValue: _backgroundController.value,
              ),
            ),
          ),

          // Linhas horizontais e verticais (estilo Tron/Matrix)
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              final animValue = _backgroundController.value;
              return CustomPaint(
                painter: _BinaryBackgroundPainter(
                  lineColor: Colors.blue.withAlpha(38), // 0.15 * 255 = 38
                  animationValue: animValue,
                ),
                size: Size.infinite,
              );
            },
          ),

          // Overlay de "chuva de números binários"
          _buildBinaryRain(),

          // Efeito de desfoque para suavizar o fundo
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildBinaryRain() {
    // Cria várias strings de binários caindo (versão simplificada)
    return Stack(
      children: List.generate(20, (index) {
        final leftPosition = index * 5.0 % 100;
        final fontSize = 12.0 + (index % 5) * 2;

        return Positioned(
          left:
              leftPosition.toDouble().clamp(5, 95) /
              100 *
              MediaQuery.of(context).size.width,
          top: (index * 30) % MediaQuery.of(context).size.height,
          child: AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              final string = _generateBinaryString(8 + (index % 4) * 2);
              return Text(
                string,
                style: GoogleFonts.sourceCodePro(
                  color: Colors.green.shade400.withAlpha(77),
                  fontSize: fontSize,
                ),
              );
            },
          ),
        );
      }),
    );
  }

  String _generateBinaryString(int length) {
    return List.generate(
      length,
      (index) => (index % 3 == 0) ? '1' : '0',
    ).join();
  }

  String _getMascotMessage(MascotMood mood, bool isBinaryToDecimal) {
    if (mood == MascotMood.happy) {
      return "Excelente! Você acertou! ${isBinaryToDecimal ? "Converteu corretamente de binário para decimal!" : "Converteu corretamente de decimal para binário!"}";
    } else if (mood == MascotMood.sad) {
      return "Ops! Não foi dessa vez. ${isBinaryToDecimal ? "Lembre-se: para converter de binário para decimal, cada posição representa uma potência de 2." : "Lembre-se: para converter de decimal para binário, divida sucessivamente por 2 e anote os restos."}";
    } else {
      return "Pense com calma! ${isBinaryToDecimal ? "Cada dígito tem um peso que é uma potência de 2. Da direita para a esquerda: 2⁰=1, 2¹=2, 2²=4, 2³=8 ..." : "Divida o número por 2 e anote o resto. Continue dividindo o resultado até chegar a zero."}";
    }
  }

  MascotType _getMascotType(MascotMood mood) {
    switch (mood) {
      case MascotMood.happy:
        return MascotType.success;
      case MascotMood.sad:
        return MascotType.error;
      case MascotMood.thinking:
        return MascotType.tip;
      default:
        return MascotType.normal;
    }
  }

  String _getFinalMessage(int score, int totalQuestions) {
    final percentage = (score / totalQuestions) * 100;

    if (percentage >= 90) {
      return "Parabéns! Você dominou o sistema binário! Suas habilidades estão incríveis! Continue praticando e logo estará programando como um profissional!";
    } else if (percentage >= 70) {
      return "Muito bom! Você está dominando o sistema binário. Continue praticando para aperfeiçoar suas habilidades de conversão!";
    } else if (percentage >= 50) {
      return "Bom trabalho! Você está no caminho certo. Com mais prática, logo vai dominar completamente as conversões binárias.";
    } else {
      return "Não desanime! O sistema binário pode ser desafiador no início. Continue praticando e verá como ficará mais fácil com o tempo.";
    }
  }

  void _showQuitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.grey.shade900,
            title: Text(
              "Finalizar Quiz?",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: Text(
              "Seu progresso será perdido. Tem certeza que deseja sair do quiz?",
              style: GoogleFonts.poppins(color: Colors.white.withAlpha(204)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.grey.shade300),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(gameStateProvider.notifier).resetGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Finalizar"),
              ),
            ],
          ),
    );
  }
}

class _BinaryBackgroundPainter extends CustomPainter {
  final Color lineColor;
  final double animationValue;

  _BinaryBackgroundPainter({
    required this.lineColor,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = lineColor
          ..strokeWidth = 1.0;

    // Desenhar linhas horizontais
    final gridSpacing = 40.0;
    final horizontalLines = (size.height / gridSpacing).ceil();
    final verticalLines = (size.width / gridSpacing).ceil();

    // Offset animado para movimento
    final offsetY = animationValue * gridSpacing;
    final offsetX = animationValue * gridSpacing * 0.5;

    // Linhas horizontais
    for (int i = 0; i < horizontalLines + 1; i++) {
      final y =
          (i * gridSpacing + offsetY) % (size.height + gridSpacing) -
          gridSpacing / 2;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Linhas verticais
    for (int i = 0; i < verticalLines + 1; i++) {
      final x =
          (i * gridSpacing + offsetX) % (size.width + gridSpacing) -
          gridSpacing / 2;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Adicionar alguns "0" e "1" no fundo
    final textStyle = TextStyle(color: lineColor, fontSize: 14);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < 40; i++) {
      final x = ((i * 73) % size.width.toInt()).toDouble();
      final y = ((i * 57) % size.height.toInt()).toDouble();
      final digit = (i % 2 == 0) ? "0" : "1";

      textPainter.text = TextSpan(text: digit, style: textStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BinaryParticlesPainter extends CustomPainter {
  final double animationValue;
  final List<_BinaryParticle> particles = List.generate(
    30,
    (index) => _BinaryParticle(
      x: index * 30.0,
      y: index * 20.0,
      character: index % 2 == 0 ? '0' : '1',
      size: 8 + (index % 5),
      opacity: 0.1 + (index % 10) / 30,
      speed: 0.5 + (index % 5) / 10,
    ),
  );

  _BinaryParticlesPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Atualiza a posição baseada na animação
      final x =
          (particle.x + (particle.speed * animationValue * 100)) % size.width;
      final y =
          (particle.y + (particle.speed * animationValue * 50)) % size.height;

      // Define a opacidade (pisca com base na animação)
      final opacity = (particle.opacity + 0.1 * (0.5 + animationValue / 2))
          .clamp(0.05, 0.4);

      // Desenha a partícula
      final textStyle = TextStyle(
        color: Colors.cyanAccent.withAlpha((opacity * 255).toInt()),
        fontSize: particle.size.toDouble(),
        fontFamily: 'monospace',
      );

      final textSpan = TextSpan(text: particle.character, style: textStyle);

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BinaryParticle {
  double x;
  double y;
  final String character;
  final double size;
  final double opacity;
  final double speed;

  _BinaryParticle({
    required this.x,
    required this.y,
    required this.character,
    required this.size,
    required this.opacity,
    required this.speed,
  });
}
