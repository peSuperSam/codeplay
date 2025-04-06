import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_text_styles.dart';

/// Widget reutilizável para o mascote da aplicação.
class MascoteWidget extends StatelessWidget {
  /// Mensagem que o mascote irá exibir
  final String message;

  /// Se o mascote deve falar automaticamente (mantido para compatibilidade)
  final bool autoSpeak;

  /// Botão de ação adicional (opcional)
  final Widget? actionButton;

  /// Quando deve mostrar a imagem do mascote
  final bool showMascoteImage;

  /// Determina se o mascote deve ter uma animação pulsante
  final bool animate;

  /// Tipo de mascote a ser exibido
  final MascotType mascotType;

  const MascoteWidget({
    super.key,
    required this.message,
    this.autoSpeak = false,
    this.actionButton,
    this.showMascoteImage = true,
    this.animate = true,
    this.mascotType = MascotType.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(153),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getBorderColor(), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem do mascote
          if (showMascoteImage) _buildMascoteImage(),

          // Mensagem
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CodeBot diz:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getTitleColor(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(message, style: AppTextStyles.bodyStyle),
                if (actionButton != null) ...[
                  const SizedBox(height: 16),
                  Align(alignment: Alignment.centerRight, child: actionButton),
                ],
              ],
            ),
          ),

          // Ícone indicativo do tipo de mensagem
          _buildTypeIcon(),
        ],
      ),
    );
  }

  Widget _buildMascoteImage() {
    final baseWidget = Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: _getBorderColor().withAlpha(150), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.asset(AppConstants.mascoteImage, fit: BoxFit.cover),
      ),
    );

    return animate
        ? baseWidget
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scaleXY(
              begin: 1.0,
              end: 1.03,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
            )
        : baseWidget;
  }

  Widget _buildTypeIcon() {
    IconData icon;
    Color color;

    switch (mascotType) {
      case MascotType.success:
        icon = Icons.check_circle;
        color = Colors.green.shade300;
        break;
      case MascotType.error:
        icon = Icons.error;
        color = Colors.red.shade300;
        break;
      case MascotType.tip:
        icon = Icons.lightbulb;
        color = Colors.amber.shade300;
        break;
      default:
        icon = Icons.info;
        color = Colors.blue.shade300;
    }

    return Icon(icon, color: color, size: 24);
  }

  Color _getBorderColor() {
    switch (mascotType) {
      case MascotType.success:
        return Colors.green.shade700;
      case MascotType.error:
        return Colors.red.shade700;
      case MascotType.tip:
        return Colors.amber.shade700;
      default:
        return Colors.indigo.withAlpha(128);
    }
  }

  Color _getTitleColor() {
    switch (mascotType) {
      case MascotType.success:
        return Colors.green.shade300;
      case MascotType.error:
        return Colors.red.shade300;
      case MascotType.tip:
        return Colors.amber.shade300;
      default:
        return Colors.blue.shade300;
    }
  }
}

/// Tipos de aparência/personalidade para o mascote
enum MascotType { normal, success, error, tip }
