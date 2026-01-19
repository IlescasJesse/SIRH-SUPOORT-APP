class DashboardModel {
  final int totalLogs;
  final int completedTasks;
  final int failedTasks;
  final double successRate;
  final List<RecentActivity> recentActivities;

  DashboardModel({
    required this.totalLogs,
    required this.completedTasks,
    required this.failedTasks,
    required this.successRate,
    required this.recentActivities,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalLogs: json['totalLogs'] ?? 0,
      completedTasks: json['completedTasks'] ?? 0,
      failedTasks: json['failedTasks'] ?? 0,
      successRate: (json['successRate'] ?? 0.0).toDouble(),
      recentActivities: (json['recentActivities'] as List?)
              ?.map((e) => RecentActivity.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class RecentActivity {
  final String tarea;
  final String estado;
  final String mensaje;
  final DateTime timestamp;

  RecentActivity({
    required this.tarea,
    required this.estado,
    required this.mensaje,
    required this.timestamp,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      tarea: json['tarea'] ?? '',
      estado: json['estado'] ?? '',
      mensaje: json['mensaje'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}
