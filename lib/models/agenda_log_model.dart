class AgendaLogModel {
  final String id;
  final String tarea;
  final String estado;
  final String mensaje;
  final Map<String, dynamic> detalles;
  final int registrosProcesados;
  final int registrosExitosos;
  final int registrosErrores;
  final int? duracion;
  final String? error;
  final DateTime timestamp;

  AgendaLogModel({
    required this.id,
    required this.tarea,
    required this.estado,
    required this.mensaje,
    required this.detalles,
    required this.registrosProcesados,
    required this.registrosExitosos,
    required this.registrosErrores,
    this.duracion,
    this.error,
    required this.timestamp,
  });

  factory AgendaLogModel.fromJson(Map<String, dynamic> json) {
    return AgendaLogModel(
      id: json['_id']?.toString() ?? '',
      tarea: json['tarea'] ?? '',
      estado: json['estado'] ?? '',
      mensaje: json['mensaje'] ?? '',
      detalles: json['detalles'] ?? {},
      registrosProcesados: json['registrosProcesados'] ?? 0,
      registrosExitosos: json['registrosExitosos'] ?? 0,
      registrosErrores: json['registrosErrores'] ?? 0,
      duracion: json['duracion'],
      error: json['error'],
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get duracionFormateada {
    if (duracion == null) return '--';
    final seconds = (duracion! / 1000).toStringAsFixed(2);
    return '${seconds}s';
  }

  String get successRate {
    if (registrosProcesados == 0) return '0%';
    final rate = (registrosExitosos / registrosProcesados * 100).toStringAsFixed(1);
    return '$rate%';
  }
}
