import 'package:flutter/material.dart';
import 'package:suporte_mes_app/chat/screens/controller/chat_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController _controller = ChatController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Column(
              children: [
                // --- CABEÇALHO ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 24, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Botão de voltar para a IOPScreen
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black87,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Suporte MES',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _controller.novoChat,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.pink.shade400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Novo',
                                style: TextStyle(
                                  color: Colors.pink.shade400,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- SELETOR DE CATEGORIA ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Row(
                    children: _controller.categoriasDisponiveis.map((cat) {
                      final isSelected =
                          _controller.categoriaSelecionada == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) _controller.alterarCategoria(cat);
                          },
                          selectedColor: Colors.teal.shade100,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.teal.shade900
                                : Colors.black54,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.teal
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // --- LISTA DE MENSAGENS ---
                Expanded(
                  child: ListView.builder(
                    controller: _controller.scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _controller.mensagens.length,
                    itemBuilder: (context, index) {
                      final msg = _controller.mensagens[index];
                      final isUser = msg['remetente'] == 'user';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.teal : Colors.grey.shade100,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(isUser ? 20 : 4),
                              bottomRight: Radius.circular(isUser ? 4 : 20),
                            ),
                          ),
                          child: MarkdownBody(
                            data: msg['texto'] ?? '',
                            selectable: true,
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                color: isUser ? Colors.white : Colors.black87,
                                fontSize: 16,
                                height: 1.4,
                              ),
                              strong: TextStyle(
                                color: isUser ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              listBullet: TextStyle(
                                color: isUser ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                if (_controller.carregando)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: LinearProgressIndicator(color: Colors.teal),
                  ),

                // --- BARRA DE DIGITAÇÃO ---
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, -4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _controller.textController,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: 'Descreva a sua dúvida ou problema...',
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                            onSubmitted: _controller.carregando
                                ? null
                                : (_) => _controller.enviarMensagem(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _controller.carregando
                            ? _controller.pararMensagem
                            : _controller.enviarMensagem,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: _controller.carregando
                              ? Colors.red.shade50
                              : Colors.teal,
                          child: Icon(
                            _controller.carregando
                                ? Icons.stop_rounded
                                : Icons.send_rounded,
                            color: _controller.carregando
                                ? Colors.redAccent
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
