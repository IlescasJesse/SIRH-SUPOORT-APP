class BajaModel {
  final String id; // Cambiado a String para manejar ObjectId de MongoDB
  final String employeeName;
  final String numemp;
  final DateTime dischargeDate;
  final String reason;
  final String numpla;
  final String status;
  final String proyecto;

  BajaModel({
    required this.id,
    required this.employeeName,
    required this.numemp,
    required this.dischargeDate,
    required this.reason,
    required this.numpla,
    required this.status,
    required this.proyecto,
  });

  factory BajaModel.fromJson(Map<String, dynamic> json) {
    return BajaModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '0',
      employeeName:
          json['NOMBRE'] ?? json['employee_name'] ?? json['employeeName'] ?? '',
      numemp: json['NUMEMP']?.toString() ?? json['numemp']?.toString() ?? '',
      dischargeDate:
          DateTime.parse(json['discharge_date'] ?? json['dischargeDate']),
      reason: json['reason'] ?? '',
      numpla: json['NUMPLA']?.toString() ?? json['numpla']?.toString() ?? '',
      status: json['PROCESADO'] == true ? 'processed' : 'pending',
      proyecto: json['PROYECTO'] ?? json['proyecto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_name': employeeName,
      'numemp': numemp,
      'discharge_date': dischargeDate.toIso8601String(),
      'reason': reason,
      'numpla': numpla,
      'status': status,
      'proyecto': proyecto,
    };
  }

  String get dateStatus {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bajaDate =
        DateTime(dischargeDate.year, dischargeDate.month, dischargeDate.day);

    if (bajaDate.isAtSameMomentAs(today)) {
      return 'today';
    } else if (bajaDate.isBefore(today)) {
      return 'past';
    } else {
      return 'future';
    }
  }
}
