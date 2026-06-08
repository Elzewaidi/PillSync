import 'package:equatable/equatable.dart';

class ReportModel extends Equatable {
  final String medicineId;
  final String medicineName;
  final int weeklyTakenCount;
  final int weeklyMissedCount;
  final double adherencePercentage;

  const ReportModel({
    required this.medicineId,
    required this.medicineName,
    required this.weeklyTakenCount,
    required this.weeklyMissedCount,
    required this.adherencePercentage,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      medicineId: json['medicineId']?.toString() ?? '',
      medicineName: json['medicineName']?.toString() ?? '',
      weeklyTakenCount: _parseInt(json['weeklyTakenCount']),
      weeklyMissedCount: _parseInt(json['weeklyMissedCount']),
      adherencePercentage: _parseDouble(json['adherencePercentage']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      final clean = value.replaceAll('%', '').trim();
      return double.tryParse(clean) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineId': medicineId,
      'medicineName': medicineName,
      'weeklyTakenCount': weeklyTakenCount,
      'weeklyMissedCount': weeklyMissedCount,
      'adherencePercentage': adherencePercentage,
    };
  }

  @override
  List<Object?> get props => [
        medicineId,
        medicineName,
        weeklyTakenCount,
        weeklyMissedCount,
        adherencePercentage,
      ];
}
