import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String userId;
  final String fullName;
  final String emailAddress;
  final String? phoneNumber;
  final String? imageUrl;
  final int? age;
  final String? birthDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Profile({
    required this.userId,
    required this.fullName,
    required this.emailAddress,
    this.phoneNumber,
    this.imageUrl,
    this.age,
    this.birthDate,
    this.createdAt,
    this.updatedAt,
  });

  Profile copyWith({
    String? userId,
    String? fullName,
    String? emailAddress,
    String? phoneNumber,
    String? imageUrl,
    int? age,
    String? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      emailAddress: emailAddress ?? this.emailAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      age: age ?? this.age,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    fullName,
    emailAddress,
    phoneNumber,
    imageUrl,
    age,
    birthDate,
    createdAt,
    updatedAt,
  ];
}
