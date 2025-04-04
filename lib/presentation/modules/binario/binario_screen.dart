import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'widgets/binary_challenge_widget.dart';
import 'widgets/binary_result_widget.dart';

// Estado do jogo
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
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

  GameState({
    this.score = 0,
    this.currentQuestion = 0,
    this.totalQuestions = 10,
    this.isGameOver = false,
    this.isTimerMode = false,
    this.remainingTime = 30,
    this.mascotMood = MascotMood.neutral,
  });

  GameState copyWith({
    int? score,
    int? currentQuestion,
    int? totalQuestions,
    bool? isGameOver,
    bool? isTimerMode,
    int? remainingTime,
    MascotMood? mascotMood,
  }) {
    return GameState(
      score: score ?? this.score,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isGameOver: isGameOver ?? this.isGameOver,
      isTimerMode: isTimerMode ?? this.isTimerMode,
      remainingTime: remainingTime ?? this.remainingTime,
      mascotMood: mascotMood ?? this.mascotMood,
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
      currentQuestion: 1, // Define currentQuestion como 1 para mostrar o desafio imediatamente
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

class _BinarioScreenState extends ConsumerState<BinarioScreen> with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;
  bool _showTimerModeDialog = false;
  
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Binário", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: gameState.currentQuestion > 0 && !gameState.isGameOver
          ? null // Remove o botão de voltar durante o quiz
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
              tooltip: "Voltar",
            ),
        actions: [
          if (!gameState.isGameOver && gameState.currentQuestion > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Pontos: ${gameState.score}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          if (gameState.isTimerMode && !gameState.isGameOver)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: gameState.remainingTime < 10 
                        ? Colors.red.withOpacity(0.3) 
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        "${gameState.remainingTime}s",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // Fundo com gradiente
          _buildAnimatedBackground(isDark),
          
          // Conteúdo principal
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    // Título e introdução (apenas na tela inicial)
                    if (gameState.currentQuestion == 0 && !gameState.isGameOver)
                      _buildIntroduction(),
                      
                    // Conteúdo do jogo
                    Expanded(
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: gameState.isGameOver
                              ? _buildResultScreen()
                              : gameState.currentQuestion == 0
                                  ? _buildStartScreen()
                                  : _buildChallengeScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Diálogo de seleção de modo (timer ou normal)
          if (_showTimerModeDialog)
            _buildModeSelectionDialog(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(bool isDark) {
    return Stack(
      children: [
        // Gradiente de fundo animado
        AnimatedBuilder(
          animation: _backgroundController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                    ? [Colors.black, Colors.indigo.shade900, Colors.black]
                    : [Colors.blue.shade900, Colors.indigo.shade800, Colors.blue.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            );
          },
        ),
        
        // Overlay com efeito de matriz (opcional)
        Opacity(
          opacity: 0.1,
          child: Image.asset(
            'assets/images/matrix_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        
        // Efeito de bits flutuantes
        _buildFloatingBitsOverlay(),
      ],
    );
  }
  
  Widget _buildFloatingBitsOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              '0 1 0 1 1 0 1 0',
              style: GoogleFonts.orbitron(
                fontSize: 100,
                fontWeight: FontWeight.w100,
                color: Colors.white,
              ),
            ).animate(onPlay: (controller) => controller.repeat())
              .fadeIn(duration: 2500.ms)
              .then()
              .fadeOut(duration: 2500.ms),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroduction() {
    return Column(
      children: [
        Text(
          "Desafio Binário",
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),
        const SizedBox(height: 8),
        Text(
          "Teste seus conhecimentos em conversão binária!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildGlassmorphicCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildStartScreen() {
    return _buildGlassmorphicCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/mascote.png',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Olá! Vamos aprender sobre números binários?',
                      textStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      speed: const Duration(milliseconds: 50),
                    ),
                  ],
                  totalRepeatCount: 1,
                  displayFullTextOnTap: true,
                ),
                const SizedBox(height: 16),
                Text(
                  'O sistema binário usa apenas 0 e 1 para representar números. Por exemplo, o número 5 em binário é 101.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showTimerModeDialog = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              'Iniciar Desafio',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ).animate().scale(begin: const Offset(0.95, 0.95)),
        ],
      ),
    );
  }

  Widget _buildModeSelectionDialog() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Escolha o Modo',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showTimerModeDialog = false;
                    });
                    ref.read(gameStateProvider.notifier).startGame(timerMode: false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow),
                      const SizedBox(width: 8),
                      Text('Modo Normal', style: GoogleFonts.poppins()),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showTimerModeDialog = false;
                    });
                    ref.read(gameStateProvider.notifier).startGame(timerMode: true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer),
                      const SizedBox(width: 8),
                      Text('Modo Relâmpago', style: GoogleFonts.poppins()),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showTimerModeDialog = false;
                    });
                  },
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeScreen() {
    final gameState = ref.watch(gameStateProvider);
    // Usar o índice da questão para determinar o tipo, garantindo consistência
    final questionType = gameState.currentQuestion % 2 == 0; // true = binário para decimal, false = decimal para binário
    
    return _buildGlassmorphicCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progresso
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Questão ${gameState.currentQuestion}/${gameState.totalQuestions}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Mascote e balão de fala
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mascote
              Image.asset(
                'assets/images/mascote.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(width: 12),
              
              // Balão de fala
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    questionType
                        ? "Qual é o valor decimal deste número binário?"
                        : "Qual é o valor binário deste número decimal?",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Desafio
          BinaryChallengeWidget(
            questionType: questionType,
            currentQuestion: gameState.currentQuestion,
            onAnswer: (bool isCorrect) {
              ref.read(gameStateProvider.notifier).answerQuestion(isCorrect);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final gameState = ref.watch(gameStateProvider);
    final percentage = (gameState.score / gameState.totalQuestions) * 100;
    
    return _buildGlassmorphicCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Resultado Final",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          
          // Mascote com reação
          Image.asset(
            'assets/images/mascote.png',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 16),
          
          // Pontuação
          BinaryResultWidget(
            score: gameState.score,
            totalQuestions: gameState.totalQuestions,
          ),
          const SizedBox(height: 32),
          
          // Botões
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16, // Espaçamento horizontal entre os botões
            runSpacing: 16, // Espaçamento vertical entre as linhas
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(gameStateProvider.notifier).resetGame();
                },
                icon: const Icon(Icons.refresh),
                label: Text('Jogar Novamente', style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home),
                label: Text('Menu Principal', style: GoogleFonts.poppins()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white30),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}