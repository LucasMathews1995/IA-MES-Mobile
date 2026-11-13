import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:suporte_mes_app/core/model/iop_model.dart';
import 'package:suporte_mes_app/core/model/training_model.dart';

class DetailsScreen extends StatelessWidget {
  final IopModel? iop;
  final TrainingModel? training;

  const DetailsScreen({super.key, this.iop, this.training});

  void _copiarTexto(BuildContext context, String texto, String mensagem) {
    Clipboard.setData(ClipboardData(text: texto));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Extrair os dados comuns baseado em qual modelo foi recebido
    final String titulo = iop?.titulo ?? training?.titulo ?? 'Detalhes';
    final String texto =
        iop?.texto ??
        training?.text ??
        ''; // Note que no TrainingModel o campo é 'text'
    final String idStr = iop?.id?.toString() ?? training?.id?.toString() ?? '';
    final String chamadoRef =
        iop?.chamadoReferencia ?? training?.chamadoReferencia ?? '';

    // Opcional: Categoria/Tipo específico
    final String tipoLabel = iop != null ? 'IOP' : 'Training';
    final String subtipoLabel = iop != null
        ? 'Equipamento: ${iop!.equipamento.name}'
        : 'Tipo: ${training?.tipoMes.name ?? ''}';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0.5,
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: OutlinedButton.icon(
              onPressed: () => _copiarTexto(
                context,
                texto,
                'Procedimento copiado para a área de transferência!',
              ),
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: Text('Copiar $tipoLabel'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0F172A),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. CARTÃO DE CABEÇALHO E METADADOS
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Linha de Badges
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _buildBadge(
                            label: '$tipoLabel #$idStr',
                            bgColor: const Color(0xFFE0F2FE),
                            textColor: const Color(0xFF0369A1),
                            icon: Icons.description_outlined,
                          ),
                          _buildBadge(
                            label: subtipoLabel,
                            bgColor: const Color(0xFFF1F5F9),
                            textColor: const Color(0xFF334155),
                            icon: Icons.precision_manufacturing_outlined, // Pode trocar o ícone se for training
                          ),
                          if (chamadoRef.isNotEmpty)
                            InkWell(
                              onTap: () => _copiarTexto(
                                context,
                                chamadoRef,
                                'Número do chamado $chamadoRef copiado!',
                              ),
                              borderRadius: BorderRadius.circular(6),
                              child: _buildBadge(
                                label: 'Chamado Ref: $chamadoRef',
                                bgColor: const Color(0xFFFEF3C7),
                                textColor: const Color(0xFFB45309),
                                icon: Icons.confirmation_number_outlined,
                                trailingIcon: Icons.copy,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Título Principal
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 2. CARTÃO DO CONTEÚDO (MARKDOWN)
                Container(
                  padding: const EdgeInsets.all(28.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: MarkdownBody(
                    data: texto,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      h3: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        height: 1.8,
                      ),
                      p: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF334155),
                        height: 1.6,
                      ),
                      listBullet: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF0284C7),
                        fontWeight: FontWeight.bold,
                      ),
                      strong: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                      blockSpacing: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color bgColor,
    required Color textColor,
    required IconData icon,
    IconData? trailingIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 6),
            Icon(trailingIcon, size: 13, color: textColor.withOpacity(0.8)),
          ],
        ],
      ),
    );
  }
}
