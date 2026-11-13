import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suporte_mes_app/core/constant/api_constants.dart';
import 'package:suporte_mes_app/core/service/auth_service.dart';
import 'package:suporte_mes_app/core/model/iop_model.dart';

class IopService {
  final String baseUrl = '${ApiConstants.baseUrl}';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (AuthService.token != null)
      'Authorization': 'Bearer ${AuthService.token}',
  };

  Future<List<IopModel>> buscarIops() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/iops'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return IopModel.fromJsonList(
          jsonDecode(utf8.decode(response.bodyBytes)),
        );
      } else {
        throw Exception(
          'Falha ao carregar as IOPs (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('Erro de conexão (IOP): $e');
      rethrow;
    }
  }
}
