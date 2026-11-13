import 'dart:convert';

class IopModel {
  final int? id;
  final String titulo;
  final EquipmentType equipamento;
  final String chamadoReferencia;
  final String texto;

  const IopModel({
    this.id,
    required this.titulo,
    required this.equipamento,
    required this.chamadoReferencia,
    required this.texto,
  });

  factory IopModel.fromJson(Map<String, dynamic> json) {
    return IopModel(
      id: json['id'] as int?,
      titulo: json['titulo'] ?? '',
      equipamento: EquipmentType.fromString(
        json['equipamento'] ?? json['EquipmentType'],
      ),
      chamadoReferencia: json['chamadoReferencia']?.toString() ?? '',
      texto: json['texto'] ?? json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'equipamento': equipamento.name,
      'EquipmentType': equipamento.name,
      'chamadoReferencia': chamadoReferencia,
      'texto': texto,
      'text': texto,
    };
  }

  static List<IopModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((item) => IopModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

enum EquipmentType {
  LRC,
  LTF,
  LZC,
  SLIITER,
  LTQ,
  GERAL;

  static EquipmentType fromString(String? value) {
    return EquipmentType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EquipmentType.GERAL,
    );
  }
}
