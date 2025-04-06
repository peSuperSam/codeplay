import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BinarySettingsWidget extends StatefulWidget {
  final int highestDifficulty;
  final Function(Map<String, dynamic> settings) onStart;

  const BinarySettingsWidget({
    super.key,
    required this.highestDifficulty,
    required this.onStart,
  });

  @override
  State<BinarySettingsWidget> createState() => _BinarySettingsWidgetState();
}

class _BinarySettingsWidgetState extends State<BinarySettingsWidget> {
  int _selectedDifficulty = 1;
  int _totalQuestions = 10;
  bool _timerMode = false;
  bool _alternateQuestionTypes = true;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = 1; // Iniciar no nível mais básico
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withAlpha(77),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue.shade200.withAlpha(51), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CONFIGURAÇÕES DO QUIZ",
            style: GoogleFonts.orbitron(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),

          const SizedBox(height: 32),

          // Seleção de dificuldade
          _buildSection(
            "Dificuldade",
            Icons.trending_up,
            _buildDifficultySelector(),
          ),

          const SizedBox(height: 24),

          // Número de perguntas
          _buildSection(
            "Número de Perguntas",
            Icons.question_answer,
            _buildQuestionsCounter(),
          ),

          const SizedBox(height: 24),

          // Opções avançadas
          _buildSection(
            "Opções Avançadas",
            Icons.settings,
            Column(
              children: [
                _buildSwitchOption(
                  "Modo Cronometrado",
                  "30 segundos por pergunta",
                  _timerMode,
                  (value) {
                    setState(() => _timerMode = value);
                  },
                ),
                const SizedBox(height: 12),
                _buildSwitchOption(
                  "Alternar Tipos de Perguntas",
                  "Binário ↔ Decimal",
                  _alternateQuestionTypes,
                  (value) {
                    setState(() => _alternateQuestionTypes = value);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Botão de início
          Center(
            child: ElevatedButton.icon(
              onPressed: _startQuiz,
              icon: const Icon(Icons.play_arrow, size: 28),
              label: const Text("INICIAR QUIZ"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildDifficultySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (index) {
              final level = index + 1;
              final isUnlocked = level <= widget.highestDifficulty;
              final isSelected = level == _selectedDifficulty;

              return GestureDetector(
                onTap:
                    isUnlocked
                        ? () => setState(() => _selectedDifficulty = level)
                        : null,
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? Colors.blue.shade700 : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isUnlocked
                              ? Colors.white.withAlpha(128)
                              : Colors.grey.shade700,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        level == 1
                            ? Icons.filter_1
                            : level == 2
                            ? Icons.filter_2
                            : Icons.filter_3,
                        color:
                            isUnlocked
                                ? (isSelected
                                    ? Colors.white
                                    : Colors.grey.shade300)
                                : Colors.grey.shade600,
                        size: 24,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        level == 1
                            ? "Fácil"
                            : level == 2
                            ? "Médio"
                            : "Difícil",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isUnlocked
                                  ? (isSelected
                                      ? Colors.white
                                      : Colors.grey.shade300)
                                  : Colors.grey.shade600,
                        ),
                      ),
                      if (!isUnlocked)
                        Icon(Icons.lock, color: Colors.grey.shade600, size: 16),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            _getDifficultyDescription(_selectedDifficulty),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withAlpha(179),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsCounter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed:
                _totalQuestions > 5
                    ? () => setState(() => _totalQuestions -= 5)
                    : null,
            icon: const Icon(Icons.remove_circle_outline),
            color: _totalQuestions > 5 ? Colors.white : Colors.grey.shade600,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade900.withAlpha(102),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$_totalQuestions",
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed:
                _totalQuestions < 20
                    ? () => setState(() => _totalQuestions += 5)
                    : null,
            icon: const Icon(Icons.add_circle_outline),
            color: _totalQuestions < 20 ? Colors.white : Colors.grey.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withAlpha(179),
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green.shade400,
            activeTrackColor: Colors.green.shade700,
          ),
        ],
      ),
    );
  }

  String _getDifficultyDescription(int difficulty) {
    switch (difficulty) {
      case 1:
        return "Números binários de 3-4 dígitos, valores até 31";
      case 2:
        return "Números binários de 4-5 dígitos, valores até 63";
      case 3:
        return "Números binários de 5-6 dígitos, valores até 127";
      default:
        return "";
    }
  }

  void _startQuiz() {
    widget.onStart({
      'difficulty': _selectedDifficulty,
      'totalQuestions': _totalQuestions,
      'timerMode': _timerMode,
      'alternateQuestionTypes': _alternateQuestionTypes,
    });
  }
}
