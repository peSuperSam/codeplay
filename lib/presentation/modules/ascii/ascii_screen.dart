import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'widgets/ascii_table_widget.dart';
import 'widgets/mascote_dica_widget.dart';

class AsciiScreen extends StatelessWidget {
  const AsciiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("ASCII", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
          tooltip: "Voltar",
        ),
      ),
      body: Stack(
        children: [
          // Fundo com gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                  ? [Colors.black, Colors.grey.shade900]
                  : [Colors.blue.shade900, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          // Overlay com efeito de matriz (opcional)
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/images/matrix_bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          
          // Conteúdo principal
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [

                  // Card com efeito glass
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "O que é ASCII?",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "ASCII é uma tabela que transforma letras e símbolos em números para que o computador entenda. Por exemplo: a letra A é representada pelo número 65.",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Exemplos visuais com ícones
                        Text(
                          "Exemplos de caracteres ASCII:",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: const [
                            _AsciiExampleCard(char: 'A', code: 65, description: 'Letra A maiúscula'),
                            _AsciiExampleCard(char: 'a', code: 97, description: 'Letra a minúscula'),
                            _AsciiExampleCard(char: '0', code: 48, description: 'Dígito zero'),
                            _AsciiExampleCard(char: ' ', code: 32, description: 'Espaço em branco'),
                            _AsciiExampleCard(char: '!', code: 33, description: 'Ponto de exclamação'),
                            _AsciiExampleCard(char: '?', code: 63, description: 'Ponto de interrogação'),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Interativo (seção de conversão)
                        _AsciiInputSection(),
                        
                        const SizedBox(height: 30),
                        
                        // Tabela ASCII completa expansível
                        const AsciiTableWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AsciiExampleCard extends StatefulWidget {
  final String char;
  final int code;
  final String description;

  const _AsciiExampleCard({
    required this.char, 
    required this.code, 
    required this.description
  });

  @override
  State<_AsciiExampleCard> createState() => _AsciiExampleCardState();
}

class _AsciiExampleCardState extends State<_AsciiExampleCard> {
  bool _isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(_isExpanded ? 12 : 8),
        decoration: BoxDecoration(
          color: _isExpanded 
            ? Colors.blue.shade700.withOpacity(0.5) 
            : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isExpanded 
              ? Colors.blue.shade300.withOpacity(0.5) 
              : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '"${widget.char}"',
                  style: GoogleFonts.poppins(
                    fontSize: 16, 
                    color: Colors.white, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  widget.code.toString(),
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            
            // Detalhes adicionais quando expandido
            if (_isExpanded) ...[  
              const SizedBox(height: 12),
              Divider(color: Colors.white.withOpacity(0.2)),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detailRow('Binário:', '${widget.code.toRadixString(2).padLeft(8, '0')}'),
                      const SizedBox(height: 4),
                      _detailRow('Hexadecimal:', '0x${widget.code.toRadixString(16).toUpperCase()}'),
                      const SizedBox(height: 4),
                      _detailRow('Descrição:', widget.description),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AsciiInputSection extends StatefulWidget {
  const _AsciiInputSection();

  @override
  State<_AsciiInputSection> createState() => _AsciiInputSectionState();
}

class _AsciiInputSectionState extends State<_AsciiInputSection> {
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
        Text(
          "Teste você mesmo!",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          "Digite uma letra ou número abaixo para ver a conversão.",
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 20),

        // Seção interativa com TextFields
        Row(
          children: [
            // Campo para caractere
            Expanded(
              child: TextField(
                controller: _charController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Caractere",
                  labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
                maxLength: 1,
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
              ),
            ),
            
            // Botões de conversão
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  IconButton(
                    onPressed: _convertCharToAscii,
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    tooltip: "Converter para ASCII",
                  ),
                  IconButton(
                    onPressed: _convertAsciiToChar,
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    tooltip: "Converter para caractere",
                  ),
                ],
              ),
            ),
            
            // Campo para código ASCII
            Expanded(
              child: TextField(
                controller: _codeController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Código ASCII",
                  labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        
        // Mensagem de erro ou sucesso
        if (_errorMessage != null) ...[  
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.poppins(color: Colors.red.shade300, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
        
        if (_showSuccess) ...[  
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Conversão realizada com sucesso!",
                    style: GoogleFonts.poppins(color: Colors.green.shade300, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
