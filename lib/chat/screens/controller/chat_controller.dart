import 'package:flutter/material.dart';
import 'package:suporte_mes_app/core/service/chat_service.dart';

class ChatController extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List<Map<String, String>> mensagens = [];
  bool carregando = false;
  bool cancelarRequisicao = false;

  String categoriaSelecionada = 'IOP';

  final List<String> categoriasDisponiveis = ['TRAINING', 'IOP', 'EXPLANATION'];

  void alterarCategoria(String novaCategoria) {
    categoriaSelecionada = novaCategoria;
    notifyListeners();
  }

  Future<void> enviarMensagem() async {
    final texto = textController.text.trim();
    if (texto.isEmpty || carregando) return;

    mensagens.add({'remetente': 'user', 'texto': texto});
    carregando = true;
    cancelarRequisicao = false;
    textController.clear();
    notifyListeners();
    _rolarParaFim();

    final respostaIa = await _chatService.enviarPergunta(
      texto,
      categoriaSelecionada,
    );

    if (cancelarRequisicao) return;

    mensagens.add({'remetente': 'ai', 'texto': respostaIa});
    carregando = false;
    notifyListeners();
    _rolarParaFim();
  }

  void pararMensagem() {
    cancelarRequisicao = true;
    carregando = false;
    mensagens.add({
      'remetente': 'ai',
      'texto': '⚠️ Consulta interrompida pelo utilizador.',
    });
    notifyListeners();
    _rolarParaFim();
  }

  void novoChat() {
    mensagens.clear();
    carregando = false;
    cancelarRequisicao = false;
    notifyListeners();
  }

  void _rolarParaFim() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
