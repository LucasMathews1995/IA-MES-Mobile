import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suporte_mes_app/core/model/iop_model.dart';
import 'package:suporte_mes_app/core/model/training_model.dart';

class CriarDocumentoController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;

  static const String _baseUrl = 'http://localhost:8080/api';

  Future<void> salvarPorCategoria({
    required String categoria,
    required String titulo,
    required EquipmentType equipamento,
    required TrainingType tipoMes,
    required String chamadoReferencia,
    required String texto,
  }) async {
    switch (categoria) {
      case 'iops':
        final iop = IopModel(
          titulo: titulo,
          equipamento: equipamento,
          chamadoReferencia: chamadoReferencia,
          texto: texto,
        );
        await salvarIop(iop);
        break;
      case 'training':
        final training = TrainingModel(
          titulo: titulo,
          tipoMes: tipoMes,
          chamadoReferencia: chamadoReferencia,
          text: texto,
        );
        await salvarTraining(training);
        break;
      case 'explanation':
        await salvarExplanation(
          titulo: titulo,
          equipamento: equipamento,
          chamadoReferencia: chamadoReferencia,
          texto: texto,
        );
        break;
      default:
        errorMessage = 'Categoria inválida: $categoria';
        notifyListeners();
    }
  }

  Future<void> salvarIop(IopModel iop) async {
    await _enviarRequisicao(endpoint: '$_baseUrl/iops', payload: iop.toJson());
  }

  Future<void> salvarTraining(TrainingModel training) async {
    await _enviarRequisicao(
      endpoint: '$_baseUrl/training',
      payload: training.toJson(),
    );
  }

  Future<void> salvarExplanation({
    required String titulo,
    required EquipmentType equipamento,
    required String chamadoReferencia,
    required String texto,
  }) async {
    await _enviarRequisicao(
      endpoint: '$_baseUrl/explanation',
      payload: {
        "titulo": titulo,
        "equipamento": equipamento.name,
        "EquipmentType": equipamento.name,
        "chamadoReferencia": chamadoReferencia,
        "texto": texto,
        "text": texto,
      },
    );
  }

  Future<void> _enviarRequisicao({
    required String endpoint,
    required Map<String, dynamic> payload,
  }) async {
    isLoading = true;
    errorMessage = null;
    isSuccess = false;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print('Payload enviado: $payload');
      print('Resposta recebida: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        isSuccess = true;
      } else {
        errorMessage =
            'Erro ao salvar (${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      errorMessage = 'Falha na conexão: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
