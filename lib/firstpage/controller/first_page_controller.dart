import 'package:flutter/foundation.dart';
import 'package:suporte_mes_app/core/service/explanation_service.dart';
import 'package:suporte_mes_app/core/service/iop_service.dart';
import 'package:suporte_mes_app/core/service/training_service.dart';

// import 'iop_service.dart';

class FirstPageController extends ChangeNotifier {
  final IopService _iopService = IopService();
  final TrainingService _trainingService = TrainingService();
  final ExplanationService _explanationService = ExplanationService();
  String _categoriaSelecionada = 'IOP';
  String get categoriaSelecionada => _categoriaSelecionada;

  final List<String> categoriasDisponiveis = ['TRAINING', 'IOP', 'EXPLANATION'];

  List<dynamic> _iopsFiltradas = [];
  List<dynamic> get iopsFiltradas => _iopsFiltradas;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Carrega os dados com base na categoria selecionada atualmente
  Future<void> carregarDadosPorCategoria(String categoria) async {
    _isLoading = true;
    _errorMessage = null;
    _categoriaSelecionada = categoria;
    notifyListeners();

    try {
      if (categoria == 'TRAINING') {
        _iopsFiltradas = await _trainingService.buscarTrainings();
      } else if (categoria == 'EXPLANATION') {
        _iopsFiltradas = await _explanationService.buscarExplicacoes();
      } else {
        _iopsFiltradas = await _iopService.buscarIops();
      }
    } catch (e) {
      _errorMessage = 'Erro ao carregar os dados: $e';
      _iopsFiltradas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método disparado quando o utilizador clica numa pílula do seletor
  void selecionarCategoria(String categoria) {
    if (_categoriaSelecionada != categoria) {
      carregarDadosPorCategoria(categoria);
    }
  }
}
