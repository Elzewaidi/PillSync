import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Medication extends Equatable {
  final String id;
  final String medicineName;
  final String dosage;
  final String typeOfDrug;
  final String frequency;
  final String startDate;
  final String endDate;
  final String timeTotake;
  final String instructions;
  final String memberId;
  final bool isDeleted;
  final bool isTaken;
  final IconData icon;
  final Color color;
  final bool isActive;

  const Medication({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.typeOfDrug,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.timeTotake,
    required this.instructions,
    required this.memberId,
    required this.isDeleted,
    this.isTaken = false,
    required this.icon,
    required this.color,
    this.isActive = true,
  });

  String get name => medicineName;

  String get time => timeTotake;

  factory Medication.fromJson(Map<String, dynamic> json) {
    final String id = (json['id'] ?? '').toString();
    final String typeOfDrug = (json['typeOfDrug'] ?? '').toString();
    return Medication(
      id: id,
      medicineName: (json['medicineName'] ?? '').toString(),
      dosage: (json['dosage'] ?? '').toString(),
      typeOfDrug: typeOfDrug,
      frequency: (json['frequency'] ?? '').toString(),
      startDate: (json['startDate'] ?? '').toString(),
      endDate: (json['endDate'] ?? '').toString(),
      timeTotake: (json['timeTotake'] ?? '').toString(),
      instructions: (json['instructions'] ?? '').toString(),
      memberId: (json['memberId'] ?? '').toString(),
      isDeleted: json['isDeleted'] == true,
      icon: _iconForDrugType(typeOfDrug),
      color: _colorForId(id),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'dosage': dosage,
      'typeOfDrug': typeOfDrug,
      'frequency': frequency,
      'startDate': startDate,
      'endDate': endDate,
      'timeTotake': timeTotake,
      'instructions': instructions,
    };
  }

  Medication copyWith({
    String? id,
    String? medicineName,
    String? dosage,
    String? typeOfDrug,
    String? frequency,
    String? startDate,
    String? endDate,
    String? timeTotake,
    String? instructions,
    String? memberId,
    bool? isDeleted,
    bool? isTaken,
    IconData? icon,
    Color? color,
    bool? isActive,
  }) {
    return Medication(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      typeOfDrug: typeOfDrug ?? this.typeOfDrug,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      timeTotake: timeTotake ?? this.timeTotake,
      instructions: instructions ?? this.instructions,
      memberId: memberId ?? this.memberId,
      isDeleted: isDeleted ?? this.isDeleted,
      isTaken: isTaken ?? this.isTaken,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    medicineName,
    dosage,
    typeOfDrug,
    frequency,
    startDate,
    endDate,
    timeTotake,
    instructions,
    memberId,
    isDeleted,
    isTaken,
    icon,
    color,
    isActive,
  ];

  static IconData _iconForDrugType(String typeOfDrug) {
    final normalized = typeOfDrug.toLowerCase();
    if (normalized.contains('tablet') || normalized.contains('capsule')) {
      return Icons.medication;
    }
    if (normalized.contains('syrup') || normalized.contains('liquid')) {
      return Icons.local_drink;
    }
    if (normalized.contains('injection')) {
      return Icons.vaccines;
    }
    return Icons.access_time;
  }

  static Color _colorForId(String id) {
    const palette = <Color>[
      Colors.blueAccent,
      Colors.cyan,
      Colors.purpleAccent,
      Colors.teal,
      Colors.orange,
      Colors.indigo,
      Colors.green,
    ];
    final index = id.isEmpty ? 0 : id.hashCode.abs() % palette.length;
    return palette[index];
  }
}