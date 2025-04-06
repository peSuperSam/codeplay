import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Widget para exibir exemplos de caracteres ASCII com visualização detalhada
class AsciiExampleCard extends StatefulWidget {
  final String char;
  final int code;
  final String description;

  const AsciiExampleCard({
    super.key,
    required this.char,
    required this.code,
    required this.description,
  });

  @override
  State<AsciiExampleCard> createState() => _AsciiExampleCardState();
}

class _AsciiExampleCardState extends State<AsciiExampleCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Animate(
        effects: [
          ScaleEffect(
            delay: 300.ms,
            duration: 300.ms,
            curve: Curves.easeOut,
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.0, 1.0),
          ),
        ],
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                _isExpanded
                    ? Colors.blue.shade800.withAlpha(153)
                    : Colors.blue.shade900.withAlpha(77),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  _isExpanded
                      ? Colors.blue.shade300.withAlpha(153)
                      : Colors.white.withAlpha(51),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(51),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.withAlpha(102)),
                    ),
                    child: Text(
                      '"${widget.char}"',
                      style: GoogleFonts.orbitron(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_downward,
                    size: 14,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.code.toString(),
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Detalhes adicionais quando expandido
              AnimatedCrossFade(
                firstChild: const SizedBox(height: 0),
                secondChild: _buildExpandedDetails(),
                crossFadeState:
                    _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedDetails() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.white.withAlpha(77)),
          const SizedBox(height: 8),
          _detailRow('Binário:', widget.code.toRadixString(2).padLeft(8, '0')),
          const SizedBox(height: 4),
          _detailRow(
            'Hexadecimal:',
            '0x${widget.code.toRadixString(16).toUpperCase().padLeft(2, '0')}',
          ),
          const SizedBox(height: 4),
          _detailRow('Descrição:', widget.description),
        ],
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
            color: Colors.amber.withAlpha(230),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
