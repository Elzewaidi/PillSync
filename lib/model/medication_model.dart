import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Medication extends Equatable {
  final String name;
  final String time;
  final bool isTaken;
  final IconData icon;
  final Color color;

  final bool isActive;

  const Medication({
    required this.name,
    required this.time,
    this.isTaken = false,
    required this.icon,
    required this.color,
    this.isActive = true,
  });

  Medication copyWith({
    String? name,
    String? time,
    bool? isTaken,
    IconData? icon,
    Color? color,
    bool? isActive,
  }) {
    return Medication(
      name: name ?? this.name,
      time: time ?? this.time,
      isTaken: isTaken ?? this.isTaken,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [name, time, isTaken, icon, color, isActive];
}