import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:suporte_mes_app/core/constant/api_constants.dart';
import 'package:suporte_mes_app/core/service/auth_service.dart';

class ChatService {
  final String baseUrl = '${ApiConstants.baseUrl}/chat';

  Future<String> enviarPergunta(String pergunta, String categoria) async {
    final payload = {'pergunta': pergunta, 'categoriaSuporte': categoria};
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          // Injeta o Bearer Token obtido no login
          if (AuthService.token != null)
            'Authorization': 'Bearer ${AuthService.token}',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['resposta'];
      } else {
        return 'Erro no servidor: ${response.statusCode}';
      }
    } catch (e) {
      return 'Não foi possível ligar ao backend: $e';
    }
  }
}
