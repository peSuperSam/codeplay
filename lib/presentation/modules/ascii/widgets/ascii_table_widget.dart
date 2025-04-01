import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        // Botão para expandir/recolher a tabela
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tabela ASCII Completa",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),

        // Tabela ASCII (visível apenas quando expandida)
        AnimatedCrossFade(
          firstChild: const SizedBox(height: 0),
          secondChild: _buildAsciiTable(),
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _buildAsciiTable() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            horizontalMargin: 4, // Reduzido de 8 para 4
            dataRowMinHeight: 48,
            headingRowHeight: 56,
            columnSpacing: 6, // Reduzido de 12 para 6
            headingRowColor: MaterialStateProperty.all(Colors.blue.shade900.withOpacity(0.3)),
            dataRowColor: MaterialStateProperty.all(Colors.transparent),
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            columns: [
              DataColumn(label: _headerText('Dec')),
              DataColumn(label: _headerText('Hex')),
              DataColumn(label: _headerText('Char')),
              DataColumn(label: _headerText('Descrição')),
            ],
            rows: _generateAsciiRows(),
          ),
        ),
      ),
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: Colors.white,
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
    String desc = description.isNotEmpty ? description : (code >= 32 ? 'Caractere imprimível' : '');
    
    return DataRow(
      cells: [
        DataCell(Text(code.toString(), style: _cellTextStyle())),
        DataCell(Text('0x${code.toRadixString(16).toUpperCase().padLeft(2, '0')}', style: _cellTextStyle())),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: code >= 32 ? Colors.blue.shade800.withOpacity(0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            code >= 32 && code <= 126 ? char : (code < 32 ? 'CTRL' : 'DEL'),
            style: _cellTextStyle(),
          ),
        )),
        DataCell(Text(desc, style: _cellTextStyle())),
      ],
    );
  }

  TextStyle _cellTextStyle() {
    return GoogleFonts.poppins(
      fontSize: 12,
      color: Colors.white,
    );
  }

  String getControlCharDescription(int code) {
    switch (code) {
      case 0: return 'NUL (Nulo)';
      case 1: return 'SOH (Início de Cabeçalho)';
      case 2: return 'STX (Início de Texto)';
      case 3: return 'ETX (Fim de Texto)';
      case 4: return 'EOT (Fim de Transmissão)';
      case 5: return 'ENQ (Enquiry)';
      case 6: return 'ACK (Acknowledge)';
      case 7: return 'BEL (Bell)';
      case 8: return 'BS (Backspace)';
      case 9: return 'HT (Tab Horizontal)';
      case 10: return 'LF (Line Feed)';
      case 11: return 'VT (Tab Vertical)';
      case 12: return 'FF (Form Feed)';
      case 13: return 'CR (Carriage Return)';
      case 14: return 'SO (Shift Out)';
      case 15: return 'SI (Shift In)';
      case 16: return 'DLE (Data Link Escape)';
      case 17: return 'DC1 (Device Control 1)';
      case 18: return 'DC2 (Device Control 2)';
      case 19: return 'DC3 (Device Control 3)';
      case 20: return 'DC4 (Device Control 4)';
      case 21: return 'NAK (Negative Acknowledge)';
      case 22: return 'SYN (Synchronous Idle)';
      case 23: return 'ETB (End of Trans. Block)';
      case 24: return 'CAN (Cancel)';
      case 25: return 'EM (End of Medium)';
      case 26: return 'SUB (Substitute)';
      case 27: return 'ESC (Escape)';
      case 28: return 'FS (File Separator)';
      case 29: return 'GS (Group Separator)';
      case 30: return 'RS (Record Separator)';
      case 31: return 'US (Unit Separator)';
      default: return '';
    }
  }
}