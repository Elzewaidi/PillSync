import 'package:equatable/equatable.dart';
import 'package:pillsync/model/pharmacy_model.dart';

abstract class PharmacyState extends Equatable {
  const PharmacyState();

  @override
  List<Object> get props => [];
}

class PharmacyInitial extends PharmacyState {}

class PharmacyLoading extends PharmacyState {}

class PharmacyLoaded extends PharmacyState {
  final List<PharmacyModel> pharmacies;
  final String currentLocationName;

  const PharmacyLoaded(this.pharmacies, this.currentLocationName);

  @override
  List<Object> get props => [pharmacies, currentLocationName];
}

class PharmacyError extends PharmacyState {
  final String message;

  const PharmacyError(this.message);

  @override
  List<Object> get props => [message];
}
