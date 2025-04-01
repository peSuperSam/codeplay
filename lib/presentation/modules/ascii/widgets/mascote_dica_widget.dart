import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MascoteDicaWidget extends StatefulWidget {
  const MascoteDicaWidget({super.key});

  @override
  State<MascoteDicaWidget> createState() => _MascoteDicaWidgetState();
}

class _MascoteDicaWidgetState extends State<MascoteDicaWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  int _dicaAtual = 0;
  
  final List<String> _dicas = [
    "A tabela ASCII foi criada em 1963 para padronizar a comunicação entre computadores.",
    "ASCII significa American Standard Code for Information Interchange.",
    "Cada caractere ASCII ocupa apenas 1 byte de memória.",
    "O espaço em branco tem o código ASCII 32.",
    "Os números de 0 a 9 começam no código 48 (para o dígito '0').",
    "As letras maiúsculas começam no código 65 (para 'A').",
    "As letras minúsculas começam no código 97 (para 'a').",
    "A diferença entre uma letra maiúscula e minúscula é sempre 32.",
    "O código 127 representa o caractere DEL (delete).",
    "Os códigos de 0 a 31 são caracteres de controle não imprimíveis.",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _proximaDica() {
    setState(() {
      _dicaAtual = (_dicaAtual + 1) % _dicas.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _proximaDica,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade900.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade200.withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mascote animado
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: Image.asset(
                    'assets/images/mascote.png',
                    height: 60,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            
            // Balão de dica
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Você sabia?",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _dicas[_dicaAtual],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Toque para mais dicas",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.touch_app,
                        size: 14,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}