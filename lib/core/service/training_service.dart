import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suporte_mes_app/core/constant/api_constants.dart';
import 'package:suporte_mes_app/core/service/auth_service.dart';
import 'package:suporte_mes_app/core/model/training_model.dart';

class TrainingService {
  final String baseUrl = '${ApiConstants.baseUrl}';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (AuthService.token != null)
      'Authorization': 'Bearer ${AuthService.token}',
  };

  Future<List<TrainingModel>> buscarTrainings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/training'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonDecoded = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        return TrainingModel.fromJsonList(jsonDecoded);
      } else {
        throw Exception(
          'Falha ao carregar os Treinamentos (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('Erro de conexão (Training): $e');
      rethrow; // Retorna o erro para o controlador/UI tratar em vez de devolver uma lista vazia e silenciosa
    }
  }
}
