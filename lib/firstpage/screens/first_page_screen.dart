import 'package:flutter/material.dart';
import 'package:suporte_mes_app/chat/screens/chat_screen.dart';
import 'package:suporte_mes_app/core/model/iop_model.dart';
import 'package:suporte_mes_app/core/model/training_model.dart';
import 'package:suporte_mes_app/details/screen/details_screen.dart';
import 'package:suporte_mes_app/documento/screen/documento_screen.dart';
import 'package:suporte_mes_app/firstpage/controller/first_page_controller.dart';

class FirstPageScreen extends StatefulWidget {
  const FirstPageScreen({super.key});

  @override
  State<FirstPageScreen> createState() => _FirstPageScreenState();
}

class _FirstPageScreenState extends State<FirstPageScreen> {
  // Instancia o controller
  final FirstPageController _controller = FirstPageController();

  @override
  void initState() {
    super.initState();
    _controller.carregarDadosPorCategoria('IOP');
  }

  Widget _buildSeletorCategorias() {
    return Container(
      height: 60, // Altura ajustada para acomodar o botão
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Expanded faz a lista de categorias ocupar o espaço restante à esquerda
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _controller.categoriasDisponiveis.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {
                final categoria = _controller.categoriasDisponiveis[index];

                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final bool isSelected =
                        _controller.categoriaSelecionada == categoria;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(categoria),
                        selected: isSelected,
                        selectedColor: Colors.teal.shade700,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (bool selected) {
                          if (selected) {
                            _controller.selecionarCategoria(categoria);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Botão de Nova Norma fixo à direita
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CriarDocumentoPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Novo IOP/Treinamento'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _abrirDetalheIop(BuildContext context, IopModel iop) {
    // Troque 'dynamic' pelo seu 'IopModel'
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsScreen(iop: iop)),
    );
  }

  void _abrirDetalheTraining(BuildContext context, TrainingModel training) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(training: training),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Biblioteca de Normas (IOPs)',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text(
          'Assistente IA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSeletorCategorias(), // Chama o método atualizado aqui
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                if (_controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.teal),
                  );
                }

                if (_controller.errorMessage != null) {
                  return Center(child: Text(_controller.errorMessage!));
                }

                final iops = _controller.iopsFiltradas;

                if (iops.isEmpty) {
                  return const Center(
                    child: Text('Nenhum item encontrado para esta categoria.'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount:
                      iops.length, // iops aqui na verdade pode conter Trainings
                  itemBuilder: (context, index) {
                    final itemAtual = iops[index]; // Agora é dynamic ou Object

                    // Variáveis para extrair os dados comuns (ID, Título, Chamado)
                    // independentemente do tipo do modelo
                    String idStr = '';
                    String titulo = '';
                    String chamado = '';

                    if (itemAtual is IopModel) {
                      idStr = itemAtual.id?.toString() ?? '';
                      titulo = itemAtual.titulo ?? '';
                      chamado = itemAtual.chamadoReferencia ?? '';
                    } else if (itemAtual is TrainingModel) {
                      idStr = itemAtual.id?.toString() ?? '';
                      titulo = itemAtual.titulo; // TrainingModel não tem ?? '' no título, é required
                      chamado = itemAtual.chamadoReferencia;
                    }

                    return InkWell(
                      onTap: () {
                        // Verifica o tipo antes de abrir o ecrã de detalhes
                        if (itemAtual is IopModel) {
                          _abrirDetalheIop(context, itemAtual);
                        } else if (itemAtual is TrainingModel) {
                          _abrirDetalheTraining(context, itemAtual);
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  idStr,
                                  style: TextStyle(
                                    color: Colors.teal.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: Text(
                                  titulo,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                chamado,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
