import 'package:equatable/equatable.dart';

abstract class AddMedicationState extends Equatable {
  const AddMedicationState();

  @override
  List<Object?> get props => [];
}

class AddMedicationInitial extends AddMedicationState {}

class AddMedicationLoading extends AddMedicationState {}

class AddMedicationSuccess extends AddMedicationState {
  final String medicineName;

  const AddMedicationSuccess(this.medicineName);

  @override
  List<Object?> get props => [medicineName];
}

class AddMedicationError extends AddMedicationState {
  final String message;

  const AddMedicationError(this.message);

  @override
  List<Object?> get props => [message];
}
