import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pillsync/api/api_manager.dart';
import 'package:pillsync/api/medication_repository.dart';
import 'package:pillsync/model/medication_model.dart';
import 'package:pillsync/utils/app_colors.dart';

import 'add_medication_state.dart';

class AddMedicationCubit extends Cubit<AddMedicationState> {
  AddMedicationCubit(this._repository) : super(AddMedicationInitial());

  final MedicationRepository _repository;

  Future<void> addMedication({
    required String medicineName,
    required String dosage,
    required String typeOfDrug,
    required String frequency,
    required String startDate,
    required String endDate,
    required String timeTotake,
    required String instructions,
  }) async {
    emit(AddMedicationLoading());
    try {
      final medication = Medication(
        id: '',
        medicineName: medicineName,
        dosage: dosage,
        typeOfDrug: typeOfDrug,
        frequency: frequency,
        startDate: startDate,
        endDate: endDate,
        timeTotake: timeTotake,
        instructions: instructions,
        memberId: MedicationRepository.currentUserId,
        isDeleted: false,
        icon: Icons.medication,
        color: AppColors.primary,
      );

      await _repository.addMedication(medication);
      emit(AddMedicationSuccess(medicineName));
    } on NetworkException catch (e) {
      emit(AddMedicationError(e.message));
    } catch (e) {
      emit(const AddMedicationError('Server Error: Please try again later.'));
    }
  }
}
