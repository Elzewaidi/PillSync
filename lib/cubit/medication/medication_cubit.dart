import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:pillsync/api/api_manager.dart';
import 'package:pillsync/api/medication_repository.dart';
import 'package:pillsync/model/medication_model.dart';

import 'medication_state.dart';

class MedicationCubit extends Cubit<MedicationState> {
  final MedicationRepository _repository;

  MedicationCubit(this._repository) : super(MedicationInitial());

  Medication? get nextUpcomingMedication {
    if (state is! MedicationLoaded) return null;
    final medications = (state as MedicationLoaded).medications;
    final now = DateTime.now();

    final upcoming = medications.where((med) {
      if (med.isTaken) return false;
      final scheduledDateTime = _scheduledDateTimeForToday(med.timeTotake);
      return scheduledDateTime != null && scheduledDateTime.isAfter(now);
    }).toList();

    if (upcoming.isEmpty) return null;

    upcoming.sort((a, b) {
      final firstTime = _scheduledDateTimeForToday(a.timeTotake)!;
      final secondTime = _scheduledDateTimeForToday(b.timeTotake)!;
      return firstTime.compareTo(secondTime);
    });

    return upcoming.first;
  }

  String getCountdownText(String timeTotake) {
    final scheduledDateTime = _scheduledDateTimeForToday(timeTotake);
    if (scheduledDateTime == null) return '';
    final diff = scheduledDateTime.difference(DateTime.now());
    if (diff.inMinutes <= 0) return 'Due now';
    if (diff.inMinutes < 60) return 'in ${diff.inMinutes} minutes';
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    if (minutes == 0) return 'in $hours hours';
    return 'in $hours h $minutes min';
  }

  Future<void> loadMedications({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      if (state is MedicationLoaded || state is MedicationActionSuccess) {
        return;
      }
      if (state is MedicationLoading) {
        return;
      }
    }

    emit(MedicationLoading());
    try {
      final meds = await _repository.getMedications();
      emit(MedicationLoaded(meds));
    } on NetworkException catch (e) {
      emit(MedicationError(e.message));
    } catch (e) {
      emit(const MedicationError('Server Error: Please try again later.'));
    }
  }

  void toggleMedication(Medication med) {
    if (state is MedicationLoaded) {
      final List<Medication> currentMeds =
          (state as MedicationLoaded).medications;
      final updatedMeds = currentMeds.map((m) {
        if (_isSameMedication(m, med)) {
          return m.copyWith(isTaken: !m.isTaken);
        }
        return m;
      }).toList();
      emit(MedicationLoaded(updatedMeds));
    }
  }

  void markMedicationTakenById(String id) {
    if (state is! MedicationLoaded) return;
    final currentMeds = (state as MedicationLoaded).medications;
    final updatedMeds = currentMeds.map((m) {
      if (m.id == id) {
        return m.copyWith(isTaken: true);
      }
      return m;
    }).toList();
    emit(
        MedicationActionSuccess(updatedMeds, 'Success: Dose marked as taken.'));
  }

  void toggleReminder(Medication med) {
    if (state is MedicationLoaded) {
      final List<Medication> currentMeds =
          (state as MedicationLoaded).medications;
      final updatedMeds = currentMeds.map((m) {
        if (_isSameMedication(m, med)) {
          return m.copyWith(isActive: !m.isActive);
        }
        return m;
      }).toList();
      emit(MedicationLoaded(updatedMeds));
    }
  }

  Future<void> deleteMedicine(String id) async {
    if (state is! MedicationLoaded) return;

    final currentMeds = (state as MedicationLoaded).medications;
    final updatedMeds = currentMeds.where((med) => med.id != id).toList();

    // Optimistic update for smoother UI response.
    emit(MedicationLoaded(updatedMeds));

    try {
      await _repository.deleteMedication(id);
    } catch (e) {
      // Keep UI/server state aligned if delete fails.
      await loadMedications(forceRefresh: true);
    }
  }

  DateTime? _scheduledDateTimeForToday(String timeTotake) {
    try {
      final parsedTime = DateFormat('hh:mm a').parseStrict(timeTotake);
      final now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (_) {
      return null;
    }
  }

  bool _isSameMedication(Medication a, Medication b) {
    if (a.id.isNotEmpty && b.id.isNotEmpty) {
      return a.id == b.id;
    }
    return a.medicineName == b.medicineName &&
        a.timeTotake == b.timeTotake &&
        a.dosage == b.dosage;
  }
}
