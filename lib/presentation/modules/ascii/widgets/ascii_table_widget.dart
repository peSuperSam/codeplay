import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AsciiTableWidget extends StatefulWidget {
  const AsciiTableWidget({super.key});

  @override
  State<AsciiTableWidget> createState() => _AsciiTableWidgetState();
}

class _AsciiTableWidgetState extends State<AsciiTableWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da seção
        Row(
          children: [
            Icon(Icons.table_chart, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            Text(
              "TABELA ASCII COMPLETA",
              style: GoogleFonts.orbitron(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Botão para expandir/recolher a tabela
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue.shade900.withAlpha(77),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha(51)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isExpanded ? "Recolher Tabela" : "Expandir Tabela",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ),
              ],
            ),
          ),
        ),

        // Tabela ASCII (visível apenas quando expandida)
        AnimatedCrossFade(
          firstChild: const SizedBox(height: 0),
          secondChild: _buildAsciiTable(),
          crossFadeState:
              _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _buildAsciiTable() {
    return Animate(
      effects: [
        FadeEffect(duration: 400.ms),
        SlideEffect(
          begin: const Offset(0, -0.1),
          end: Offset.zero,
          duration: 400.ms,
        ),
      ],
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.blue.shade900.withAlpha(77),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.blue.shade200.withAlpha(51),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(77),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DataTable(
              horizontalMargin: 8,
              dataRowMinHeight: 48,
              headingRowHeight: 56,
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(
                Colors.blue.shade800.withAlpha(153),
              ),
              dataRowColor: WidgetStateProperty.all(Colors.transparent),
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.white.withAlpha(51)),
              ),
              columns: [
                DataColumn(label: _headerText('Dec')),
                DataColumn(label: _headerText('Hex')),
                DataColumn(label: _headerText('Char')),
                DataColumn(label: _headerText('Descrição')),
              ],
              rows: _generateAsciiRows(),
              checkboxHorizontalMargin: 0,
              clipBehavior: Clip.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: GoogleFonts.orbitron(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1,
      ),
    );
  }

  List<DataRow> _generateAsciiRows() {
    List<DataRow> rows = [];

    // Caracteres de controle (0-31)
    for (int i = 0; i <= 31; i++) {
      rows.add(_createAsciiRow(i, getControlCharDescription(i)));
    }

    // Caracteres imprimíveis (32-127)
    for (int i = 32; i <= 127; i++) {
      rows.add(_createAsciiRow(i, ''));
    }

    return rows;
  }

  DataRow _createAsciiRow(int code, String description) {
    String char = code >= 32 && code <= 126 ? String.fromCharCode(code) : '';
    String desc =
        description.isNotEmpty
            ? description
            : (code >= 32 ? 'Caractere imprimível' : '');

    return DataRow(
      cells: [
        DataCell(Text(code.toString(), style: _cellTextStyle())),
        DataCell(
          Text(
            '0x${code.toRadixString(16).toUpperCase().padLeft(2, '0')}',
            style: _cellTextStyle(),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  code >= 32 ? Colors.amber.withAlpha(77) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color:
                    code >= 32
                        ? Colors.amber.withAlpha(128)
                        : Colors.transparent,
              ),
            ),
            child: Text(
              code >= 32 && code <= 126 ? char : (code < 32 ? 'CTRL' : 'DEL'),
              style: GoogleFonts.orbitron(
                fontSize: 14,
                color: Colors.white,
                fontWeight: code >= 32 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
        DataCell(Text(desc, style: _cellTextStyle())),
      ],
    );
  }

  TextStyle _cellTextStyle() {
    return GoogleFonts.poppins(fontSize: 14, color: Colors.white);
  }

  String getControlCharDescription(int code) {
    switch (code) {
      case 0:
        return 'NUL (Nulo)';
      case 1:
        return 'SOH (Início de Cabeçalho)';
      case 2:
        return 'STX (Início de Texto)';
      case 3:
        return 'ETX (Fim de Texto)';
      case 4:
        return 'EOT (Fim de Transmissão)';
      case 5:
        return 'ENQ (Enquiry)';
      case 6:
        return 'ACK (Acknowledge)';
      case 7:
        return 'BEL (Bell)';
      case 8:
        return 'BS (Backspace)';
      case 9:
        return 'HT (Tab Horizontal)';
      case 10:
        return 'LF (Line Feed)';
      case 11:
        return 'VT (Tab Vertical)';
      case 12:
        return 'FF (Form Feed)';
      case 13:
        return 'CR (Carriage Return)';
      case 14:
        return 'SO (Shift Out)';
      case 15:
        return 'SI (Shift In)';
      case 16:
        return 'DLE (Data Link Escape)';
      case 17:
        return 'DC1 (Device Control 1)';
      case 18:
        return 'DC2 (Device Control 2)';
      case 19:
        return 'DC3 (Device Control 3)';
      case 20:
        return 'DC4 (Device Control 4)';
      case 21:
        return 'NAK (Negative Acknowledge)';
      case 22:
        return 'SYN (Synchronous Idle)';
      case 23:
        return 'ETB (End of Trans. Block)';
      case 24:
        return 'CAN (Cancel)';
      case 25:
        return 'EM (End of Medium)';
      case 26:
        return 'SUB (Substitute)';
      case 27:
        return 'ESC (Escape)';
      case 28:
        return 'FS (File Separator)';
      case 29:
        return 'GS (Group Separator)';
      case 30:
        return 'RS (Record Separator)';
      case 31:
        return 'US (Unit Separator)';
      default:
        return '';
    }
  }
}
