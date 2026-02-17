import 'package:bloc/bloc.dart';
import 'package:pillsync/api/medication_repository.dart';
import 'package:pillsync/model/medication_model.dart';
import 'medication_state.dart';

class MedicationCubit extends Cubit<MedicationState> {
  final MedicationRepository _repository;

  MedicationCubit(this._repository) : super(MedicationInitial());

  Future<void> loadMedications() async {
    emit(MedicationLoading());
    try {
      final meds = await _repository.getMedications();
      emit(MedicationLoaded(meds));
    } catch (e) {
      emit(MedicationError(e.toString()));
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
}
