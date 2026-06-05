import 'package:equatable/equatable.dart';

class PharmacyModel extends Equatable {
  final String name;
  final double rating;
  final double distanceInMeters;
  final String address;
  final String phone;
  final bool isOpen;
  final String rawOpeningHours;
  final double? latitude;
  final double? longitude;

  const PharmacyModel({
    required this.name,
    required this.rating,
    required this.distanceInMeters,
    required this.address,
    required this.phone,
    required this.isOpen,
    required this.rawOpeningHours,
    this.latitude,
    this.longitude,
  });

  PharmacyModel copyWith({
    String? name,
    double? rating,
    double? distanceInMeters,
    String? address,
    String? phone,
    bool? isOpen,
    String? rawOpeningHours,
    double? latitude,
    double? longitude,
  }) {
    return PharmacyModel(
      name: name ?? this.name,
      rating: rating ?? this.rating,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isOpen: isOpen ?? this.isOpen,
      rawOpeningHours: rawOpeningHours ?? this.rawOpeningHours,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
        name,
        rating,
        distanceInMeters,
        address,
        phone,
        isOpen,
        rawOpeningHours,
        latitude,
        longitude,
      ];
}
