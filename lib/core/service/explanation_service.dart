import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suporte_mes_app/core/constant/api_constants.dart';
import 'package:suporte_mes_app/core/service/auth_service.dart';

class ExplanationService {
  final String baseUrl = '${ApiConstants.baseUrl}';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (AuthService.token != null)
      'Authorization': 'Bearer ${AuthService.token}',
  };

  Future<List<dynamic>> buscarExplicacoes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/explanation'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
        // Quando criar o modelo, altere para:
        // return ExplanationModel.fromJsonList(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception(
          'Falha ao carregar as Explicações (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('Erro de conexão (Explanation): $e');
      rethrow;
    }
  }
}
