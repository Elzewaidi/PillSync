import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/api/medication_repository.dart';
import 'package:pillsync/model/medication_model.dart';

import 'medication_state.dart';

class MedicationCubit extends Cubit<MedicationState> {
  final MedicationRepository _repository;
  final _notificationTriggerController = StreamController<Medication>.broadcast();
  Stream<Medication> get notificationStream => _notificationTriggerController.stream;

  void triggerNotification(Medication med) {
    _notificationTriggerController.add(med);
  }

  @override
  Future<void> close() {
    _notificationTriggerController.close();
    return super.close();
  }

  MedicationCubit(this._repository) : super(MedicationInitial());

  Future<void> loadMedications() async {
    emit(MedicationLoading());
    try {
      final meds = await _repository.getMedications();
      emit(MedicationLoaded(meds));
    } catch (e) {
      // API error fallback to mock data
      final fallbackMeds = [
        const Medication(
          id: "mock_1",
          medicineName: "Panadol Extra",
          dosage: "2 tablets",
          typeOfDrug: "tablet",
          frequency: "Daily",
          startDate: "2026-06-01",
          endDate: "2026-06-30",
          timeTotake: "08:00 AM",
          instructions: "Take after meals for headache relief.",
          memberId: "mock_user",
          isDeleted: false,
          isTaken: false,
          icon: Icons.medication,
          color: Colors.blueAccent,
        ),
        const Medication(
          id: "mock_2",
          medicineName: "Concor 5mg",
          dosage: "1 tablet",
          typeOfDrug: "tablet",
          frequency: "Daily",
          startDate: "2026-06-01",
          endDate: "2026-06-30",
          timeTotake: "10:00 AM",
          instructions: "Take before breakfast on an empty stomach.",
          memberId: "mock_user",
          isDeleted: false,
          isTaken: true,
          icon: Icons.medication,
          color: Colors.cyan,
        ),
        const Medication(
          id: "mock_3",
          medicineName: "Augmentin 1g",
          dosage: "1 tablet",
          typeOfDrug: "tablet",
          frequency: "Every 12 hours",
          startDate: "2026-06-01",
          endDate: "2026-06-10",
          timeTotake: "09:00 PM",
          instructions: "Complete the full antibiotic course.",
          memberId: "mock_user",
          isDeleted: false,
          isTaken: false,
          icon: Icons.medication,
          color: Colors.purpleAccent,
        ),
      ];
      emit(MedicationLoaded(fallbackMeds));
    }
  }

  void toggleMedication(Medication med) {
    if (state is MedicationLoaded) {
      final List<Medication> currentMeds =
          (state as MedicationLoaded).medications;
      final updatedMeds = currentMeds.map((m) {
        if (m == med) {
          return m.copyWith(isTaken: !m.isTaken);
        }
        return m;
      }).toList();
      emit(MedicationLoaded(updatedMeds));
    }
  }

  void toggleReminder(Medication med) {
    if (state is MedicationLoaded) {
      final List<Medication> currentMeds =
          (state as MedicationLoaded).medications;
      final updatedMeds = currentMeds.map((m) {
        if (m == med) {
          return m.copyWith(isActive: !m.isActive);
        }
        return m;
      }).toList();
      emit(MedicationLoaded(updatedMeds));
    }
  }

  Medication? get nextUpcomingMedication {
    if (state is MedicationLoaded) {
      final meds = (state as MedicationLoaded).medications;
      if (meds.isEmpty) return null;

      final untakenMeds = meds.where((m) => !m.isTaken).toList();
      if (untakenMeds.isEmpty) return null;

      final now = DateTime.now();
      untakenMeds.sort((a, b) {
        final aTime = _parseTimeString(a.timeTotake, now);
        final bTime = _parseTimeString(b.timeTotake, now);
        return aTime.compareTo(bTime);
      });

      for (var med in untakenMeds) {
        final medTime = _parseTimeString(med.timeTotake, now);
        if (medTime.isAfter(now)) {
          return med;
        }
      }

      return untakenMeds.first;
    }
    return null;
  }

  DateTime _parseTimeString(String timeStr, DateTime referenceDate) {
    try {
      final clean = timeStr.trim().toUpperCase();
      int hour = 0;
      int minute = 0;

      if (clean.contains('AM') || clean.contains('PM')) {
        final parts = clean.split(RegExp(r'\s+'));
        final isPm = clean.contains('PM');
        final timeParts = parts[0].split(':');
        hour = int.parse(timeParts[0]);
        minute = int.parse(timeParts[1]);
        if (isPm && hour < 12) {
          hour += 12;
        } else if (!isPm && hour == 12) {
          hour = 0;
        }
      } else {
        final parts = clean.split(':');
        hour = int.parse(parts[0]);
        minute = int.parse(parts[1]);
      }

      return DateTime(
        referenceDate.year,
        referenceDate.month,
        referenceDate.day,
        hour,
        minute,
      );
    } catch (_) {
      return referenceDate;
    }
  }

  String getCountdownText(String timeStr) {
    final now = DateTime.now();
    final medTime = _parseTimeString(timeStr, now);

    if (medTime.isBefore(now)) {
      return "Dose time has passed";
    }

    final difference = medTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return "In $hours hr $minutes min";
    } else {
      return "In $minutes min";
    }
  }
}
