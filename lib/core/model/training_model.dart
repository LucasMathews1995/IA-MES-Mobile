enum TrainingType {
  MES_VR,
  MES_PR,
  MES_GS,
  MES_CAL,
  MES_AL,
  GERAL;

  static TrainingType fromString(String? value) {
    return TrainingType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TrainingType.MES_VR,
    );
  }
}

class TrainingModel {
  final int? id;
  final String titulo;
  final TrainingType tipoMes;
  final String chamadoReferencia;
  final String text;

  const TrainingModel({
    this.id,
    required this.titulo,
    required this.tipoMes,
    required this.chamadoReferencia,
    required this.text,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      id: json['id'] as int?,
      titulo: json['titulo'] ?? '',
      tipoMes: TrainingType.fromString(json['tipoMes']),
      chamadoReferencia: json['chamadoReferencia']?.toString() ?? '',
      text: json['text'] ?? json['texto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'tipoMes': tipoMes.name,
      'chamadoReferencia': chamadoReferencia,
      'text': text,
    };
  }

  static List<TrainingModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => TrainingModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
