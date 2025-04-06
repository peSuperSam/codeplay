import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AsciiInputSection extends StatefulWidget {
  const AsciiInputSection({super.key});

  @override
  State<AsciiInputSection> createState() => _AsciiInputSectionState();
}

class _AsciiInputSectionState extends State<AsciiInputSection> {
  final TextEditingController _charController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? _errorMessage;
  bool _showSuccess = false;

  @override
  void dispose() {
    _charController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _convertCharToAscii() {
    setState(() {
      _errorMessage = null;
      _showSuccess = false;
    });

    final input = _charController.text;
    if (input.isEmpty) {
      setState(() {
        _errorMessage = "Digite um caractere";
      });
      return;
    }

    if (input.length > 1) {
      setState(() {
        _errorMessage = "Digite apenas um caractere";
      });
      return;
    }

    final asciiCode = input.codeUnitAt(0);
    _codeController.text = asciiCode.toString();
    setState(() {
      _showSuccess = true;
    });
  }

  void _convertAsciiToChar() {
    setState(() {
      _errorMessage = null;
      _showSuccess = false;
    });

    final input = _codeController.text;
    if (input.isEmpty) {
      setState(() {
        _errorMessage = "Digite um código ASCII";
      });
      return;
    }

    final code = int.tryParse(input);
    if (code == null) {
      setState(() {
        _errorMessage = "Digite apenas números";
      });
      return;
    }

    if (code < 0 || code > 127) {
      setState(() {
        _errorMessage = "O código deve estar entre 0 e 127";
      });
      return;
    }

    _charController.text = String.fromCharCode(code);
    setState(() {
      _showSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da seção
        Row(
          children: [
            Icon(Icons.psychology, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            Text(
              "TESTE VOCÊ MESMO",
              style: GoogleFonts.orbitron(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Descrição
        Text(
          "Digite uma letra ou número abaixo para ver a conversão.",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withAlpha(230),
          ),
        ),

        const SizedBox(height: 20),

        // Container com efeito glass para os campos
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(26),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withAlpha(51)),
          ),
          child: Column(
            children: [
              // Seção interativa com TextFields
              Row(
                children: [
                  // Campo para caractere
                  Expanded(
                    child: TextField(
                      controller: _charController,
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: "Caractere",
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.white.withAlpha(192),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.blue.shade900.withAlpha(51),
                      ),
                      maxLength: 1,
                      buildCounter:
                          (
                            context, {
                            required currentLength,
                            required isFocused,
                            maxLength,
                          }) => null,
                    ),
                  ),

                  // Botões de conversão
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _convertCharToAscii,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Icon(Icons.arrow_forward),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _convertAsciiToChar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Icon(Icons.arrow_back),
                        ),
                      ],
                    ),
                  ),

                  // Campo para código ASCII
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: "Código ASCII",
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.white.withAlpha(192),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.blue.shade900.withAlpha(51),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Mensagem de erro ou sucesso
        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red.shade900.withAlpha(77),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade300.withAlpha(77)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.poppins(
                      color: Colors.red.shade300,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0),
        ],

        if (_showSuccess) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.shade900.withAlpha(77),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade300.withAlpha(77)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Conversão realizada com sucesso!",
                    style: GoogleFonts.poppins(
                      color: Colors.green.shade300,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0),
        ],
      ],
    );
  }
}
