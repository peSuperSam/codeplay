import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

/// Provedor do estado do jogo
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((
  ref,
) {
  return GameStateNotifier();
});

/// Estados de humor do mascote do jogo
enum MascotMood { neutral, happy, sad, thinking }

/// Modelo de estado do jogo
class GameState {
  /// Pontuação atual do jogador
  final int score;

  /// Número da pergunta atual (0 significa que o jogo ainda não começou)
  final int currentQuestion;

  /// Total de perguntas do quiz
  final int totalQuestions;

  /// Indica se o jogo terminou
  final bool isGameOver;

  /// Indica se o modo de tempo está ativado
  final bool isTimerMode;

  /// Tempo restante (em segundos) quando no modo de tempo
  final int remainingTime;

  /// Humor atual do mascote
  final MascotMood mascotMood;

  /// Nível atual de dificuldade (1-3)
  final int difficulty;

  /// Maior nível de dificuldade desbloqueado pelo jogador (1-3)
  final int highestDifficulty;

  /// Tipo de pergunta atual (true = binário para decimal, false = decimal para binário)
  final bool isBinaryToDecimal;

  GameState({
    this.score = 0,
    this.currentQuestion = 0,
    this.totalQuestions = 10,
    this.isGameOver = false,
    this.isTimerMode = false,
    this.remainingTime = 30,
    this.mascotMood = MascotMood.neutral,
    this.difficulty = 1,
    this.highestDifficulty = 1,
    this.isBinaryToDecimal = true,
  });

  GameState copyWith({
    int? score,
    int? currentQuestion,
    int? totalQuestions,
    bool? isGameOver,
    bool? isTimerMode,
    int? remainingTime,
    MascotMood? mascotMood,
    int? difficulty,
    int? highestDifficulty,
    bool? isBinaryToDecimal,
  }) {
    return GameState(
      score: score ?? this.score,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isGameOver: isGameOver ?? this.isGameOver,
      isTimerMode: isTimerMode ?? this.isTimerMode,
      remainingTime: remainingTime ?? this.remainingTime,
      mascotMood: mascotMood ?? this.mascotMood,
      difficulty: difficulty ?? this.difficulty,
      highestDifficulty: highestDifficulty ?? this.highestDifficulty,
      isBinaryToDecimal: isBinaryToDecimal ?? this.isBinaryToDecimal,
    );
  }
}

/// Notificador de estado para gerenciar o jogo
class GameStateNotifier extends StateNotifier<GameState> {
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Manter controle de alternância entre tipos de perguntas
  bool _shouldAlternateBinaryType = true;

  GameStateNotifier() : super(GameState());

  /// Inicia um novo jogo
  /// [timerMode] - Se o modo de tempo está ativado
  /// [difficulty] - Nível de dificuldade (1-3)
  /// [totalQuestions] - Número total de perguntas
  void startGame({
    bool timerMode = false,
    int difficulty = 1,
    int totalQuestions = 10,
    bool alternateQuestionTypes = true,
  }) {
    // Certifique-se de que a dificuldade está dentro dos limites
    difficulty = difficulty.clamp(1, state.highestDifficulty);
    _shouldAlternateBinaryType = alternateQuestionTypes;

    state = GameState(
      isTimerMode: timerMode,
      currentQuestion: 1, // Começa na primeira pergunta
      totalQuestions: totalQuestions,
      difficulty: difficulty,
      highestDifficulty: state.highestDifficulty,
      isBinaryToDecimal: true, // Começa com binário para decimal
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

  /// Registra uma resposta do usuário
  void answerQuestion(bool isCorrect) async {
    if (isCorrect) {
      // Tocar som de acerto
      try {
        await _audioPlayer.play(AssetSource('sounds/click.mp3'));
      } catch (e) {
        debugPrint('Erro ao tocar som: $e');
      }

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

    // Verificar se existe próxima pergunta
    if (state.currentQuestion >= state.totalQuestions) {
      // Verificar se o jogador completou bem o suficiente para desbloquear o próximo nível
      final percentageCorrect = (state.score / state.totalQuestions) * 100;
      int newHighestDifficulty = state.highestDifficulty;

      if (percentageCorrect >= 70 &&
          state.difficulty == state.highestDifficulty &&
          state.highestDifficulty < 3) {
        newHighestDifficulty = state.highestDifficulty + 1;
      }

      // Finalizar o jogo
      state = state.copyWith(
        isGameOver: true,
        highestDifficulty: newHighestDifficulty,
      );
      _timer?.cancel();
    } else {
      // Alternar entre perguntas binário->decimal e decimal->binário se necessário
      bool nextQuestionType = state.isBinaryToDecimal;
      if (_shouldAlternateBinaryType) {
        nextQuestionType = !state.isBinaryToDecimal;
      }

      // Avançar para a próxima pergunta
      state = state.copyWith(
        currentQuestion: state.currentQuestion + 1,
        mascotMood: MascotMood.neutral,
        isBinaryToDecimal: nextQuestionType,
      );
    }
  }

  /// Aumenta o nível de dificuldade (se possível)
  void increaseDifficulty() {
    if (state.difficulty < state.highestDifficulty) {
      startGame(
        difficulty: state.difficulty + 1,
        timerMode: state.isTimerMode,
        totalQuestions: state.totalQuestions,
        alternateQuestionTypes: _shouldAlternateBinaryType,
      );
    }
  }

  /// Reinicia o jogo com as mesmas configurações
  void restartGame() {
    startGame(
      difficulty: state.difficulty,
      timerMode: state.isTimerMode,
      totalQuestions: state.totalQuestions,
      alternateQuestionTypes: _shouldAlternateBinaryType,
    );
  }

  /// Reseta o jogo para o estado inicial
  void resetGame() {
    _timer?.cancel();
    state = GameState(highestDifficulty: state.highestDifficulty);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
