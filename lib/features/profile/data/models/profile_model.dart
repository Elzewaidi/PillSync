import 'package:hive_ce/hive.dart';
import '../../domain/entities/profile.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 2)
class ProfileModel extends Profile {
  @HiveField(0)
  final String userIdField;

  @HiveField(1)
  final String fullNameField;

  @HiveField(2)
  final String emailAddressField;

  @HiveField(3)
  final String? phoneNumberField;

  @HiveField(4)
  final String? imageUrlField;

  @HiveField(5)
  final int? ageField;

  @HiveField(6)
  final String? birthDateField;

  @HiveField(7)
  final DateTime? createdAtField;

  @HiveField(8)
  final DateTime? updatedAtField;

  ProfileModel({
    required this.userIdField,
    required this.fullNameField,
    required this.emailAddressField,
    this.phoneNumberField,
    this.imageUrlField,
    this.ageField,
    this.birthDateField,
    this.createdAtField,
    this.updatedAtField,
  }) : super(
         userId: userIdField,
         fullName: fullNameField,
         emailAddress: emailAddressField,
         phoneNumber: phoneNumberField,
         imageUrl: imageUrlField,
         age: ageField,
         birthDate: birthDateField,
         createdAt: createdAtField,
         updatedAt: updatedAtField,
       );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userIdField: json['userId'] as String? ?? json['id'] as String? ?? '',
      fullNameField:
          json['fullName'] as String? ?? json['name'] as String? ?? '',
      emailAddressField:
          json['emailAddress'] as String? ?? json['email'] as String? ?? '',
      phoneNumberField: json['phoneNumber'] as String?,
      imageUrlField: json['imageURL'] as String? ?? json['imageUrl'] as String?,
      ageField: json['age'] != null ? (json['age'] as num).toInt() : null,
      birthDateField: json['birthDate'] as String?,
      createdAtField: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAtField: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userIdField,
      'fullName': fullNameField,
      'emailAddress': emailAddressField,
      'phoneNumber': phoneNumberField,
      'imageURL': imageUrlField,
      'age': ageField,
      'birthDate': birthDateField,
      'createdAt': createdAtField?.toIso8601String(),
      'updatedAt': updatedAtField?.toIso8601String(),
    };
  }

  /// Convert domain entity to model
  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      userIdField: profile.userId,
      fullNameField: profile.fullName,
      emailAddressField: profile.emailAddress,
      phoneNumberField: profile.phoneNumber,
      imageUrlField: profile.imageUrl,
      ageField: profile.age,
      birthDateField: profile.birthDate,
      createdAtField: profile.createdAt,
      updatedAtField: profile.updatedAt,
    );
  }
}
