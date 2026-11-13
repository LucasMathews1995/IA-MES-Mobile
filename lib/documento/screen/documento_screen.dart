import 'package:flutter/material.dart';
import 'package:suporte_mes_app/documento/controller/documento_controller.dart';
import 'package:suporte_mes_app/core/model/iop_model.dart';
import 'package:suporte_mes_app/core/model/training_model.dart';

class _CategoriaConfig {
  final String labelDropdown;
  final String appBarTitle;
  final String tituloLabel;
  final String equipamentoLabel;
  final String chamadoLabel;
  final String conteudoHeader;
  final String conteudoHint;
  final String botaoSalvar;
  final String mensagemSucesso;

  const _CategoriaConfig({
    required this.labelDropdown,
    required this.appBarTitle,
    required this.tituloLabel,
    required this.equipamentoLabel,
    required this.chamadoLabel,
    required this.conteudoHeader,
    required this.conteudoHint,
    required this.botaoSalvar,
    required this.mensagemSucesso,
  });
}

class CriarDocumentoPage extends StatefulWidget {
  const CriarDocumentoPage({super.key});

  @override
  State<CriarDocumentoPage> createState() => _CriarDocumentoPageState();
}

class _CriarDocumentoPageState extends State<CriarDocumentoPage> {
  final _tituloController = TextEditingController();
  final _chamadoController = TextEditingController();
  final _textoController = TextEditingController();

  final _controller = CriarDocumentoController();

  String _categoriaSelecionada = 'iops';
  EquipmentType _equipamentoSelecionado = EquipmentType.LRC;
  TrainingType _trainingTypeSelecionado = TrainingType.MES_VR;

  static const _defaultConfig = _CategoriaConfig(
    labelDropdown: 'IOP',
    appBarTitle: 'Criar Nova Norma (IOP)',
    tituloLabel: 'Título da IOP',
    equipamentoLabel: 'Equipamento / Linha',
    chamadoLabel: 'Chamado Referência',
    conteudoHeader: 'Conteúdo da Norma (Passo a passo):',
    conteudoHint: 'Digite o passo a passo operacional da IOP aqui...',
    botaoSalvar: 'Salvar IOP',
    mensagemSucesso: 'IOP salva com sucesso!',
  );

  static const Map<String, _CategoriaConfig> _configuracoes = {
    'iops': _defaultConfig,
    'training': _CategoriaConfig(
      labelDropdown: 'TRAINING',
      appBarTitle: 'Criar Novo Treinamento',
      tituloLabel: 'Tema do Treinamento',
      equipamentoLabel: 'Sistema / Módulo Alvo',
      chamadoLabel: 'Código / Chamado Base (Opcional)',
      conteudoHeader: 'Roteiro / Material de Treinamento:',
      conteudoHint:
          'Descreva os tópicos, instruções e boas práticas do treinamento...',
      botaoSalvar: 'Salvar Treinamento',
      mensagemSucesso: 'Treinamento salvo com sucesso!',
    ),
    'explanation': _CategoriaConfig(
      labelDropdown: 'EXPLANATION',
      appBarTitle: 'Criar Nova Explicação Técnica',
      tituloLabel: 'Assunto / Conceito',
      equipamentoLabel: 'Equipamento / Processo Relacionado',
      chamadoLabel: 'Chamado Origem (Opcional)',
      conteudoHeader: 'Detalhamento Técnico / Causa Raiz:',
      conteudoHint:
          'Explique o funcionamento, arquitetura ou solução do problema...',
      botaoSalvar: 'Salvar Explicação',
      mensagemSucesso: 'Explicação salva com sucesso!',
    ),
  };

  _CategoriaConfig get _configAtual =>
      _configuracoes[_categoriaSelecionada] ?? _defaultConfig;

  @override
  void dispose() {
    _tituloController.dispose();
    _chamadoController.dispose();
    _textoController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _salvarDocumento() async {
    if (_tituloController.text.trim().isEmpty ||
        _textoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_configAtual.tituloLabel} e Conteúdo são obrigatórios',
          ),
        ),
      );
      return;
    }

    await _controller.salvarPorCategoria(
      categoria: _categoriaSelecionada,
      titulo: _tituloController.text.trim(),
      equipamento: _equipamentoSelecionado,
      tipoMes: _trainingTypeSelecionado,
      chamadoReferencia: _chamadoController.text.trim(),
      texto: _textoController.text.trim(),
    );

    if (!mounted) return;

    if (_controller.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_configAtual.mensagemSucesso),
          backgroundColor: Colors.teal,
        ),
      );
      Navigator.pop(context);
    } else if (_controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _configAtual;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          config.appBarTitle,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown de Categoria
            DropdownButtonFormField<String>(
              value: _categoriaSelecionada,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _configuracoes.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value.labelDropdown),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _categoriaSelecionada = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // 1º Campo: Título
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(
                labelText: config.tituloLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),

            // 2º Campo: Dropdown tipado com TrainingType ou EquipmentType
            if (_categoriaSelecionada == 'training')
              DropdownButtonFormField<TrainingType>(
                key: const ValueKey('dropdown_training'),
                value: _trainingTypeSelecionado,
                decoration: InputDecoration(
                  labelText: config.equipamentoLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.precision_manufacturing),
                ),
                items: TrainingType.values.map((tipo) {
                  return DropdownMenuItem<TrainingType>(
                    value: tipo,
                    child: Text(tipo.name),
                  );
                }).toList(),
                onChanged: (TrainingType? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _trainingTypeSelecionado = newValue;
                    });
                  }
                },
              )
            else
              DropdownButtonFormField<EquipmentType>(
                key: const ValueKey('dropdown_equipment'),
                value: _equipamentoSelecionado,
                decoration: InputDecoration(
                  labelText: config.equipamentoLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.precision_manufacturing),
                ),
                items: EquipmentType.values.map((equip) {
                  return DropdownMenuItem<EquipmentType>(
                    value: equip,
                    child: Text(equip.name),
                  );
                }).toList(),
                onChanged: (EquipmentType? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _equipamentoSelecionado = newValue;
                    });
                  }
                },
              ),
            const SizedBox(height: 16),

            // 3º Campo: Chamado Referência
            TextField(
              controller: _chamadoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: config.chamadoLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 16),

            // 4º Campo: Conteúdo
            Text(
              config.conteudoHeader,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _textoController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: config.conteudoHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botão Salvar
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _controller.isLoading ? null : _salvarDocumento,
                    icon: _controller.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      _controller.isLoading
                          ? 'Salvando...'
                          : config.botaoSalvar,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
