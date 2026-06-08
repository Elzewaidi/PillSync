import 'package:hive_ce/hive.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends User {
  @HiveField(0)
  final String userIdField;

  @HiveField(1)
  final String emailAddressField;

  @HiveField(2)
  final String fullNameField;

  @HiveField(3)
  final String? imageUrlField;

  @HiveField(4)
  final bool isVerifiedField;

  @HiveField(5)
  final String tokenField;

  @HiveField(6)
  final String? phoneNumberField;

  @HiveField(7)
  final int? ageField;

  @HiveField(8)
  final String? birthDateField;

  UserModel({
    required this.userIdField,
    required this.emailAddressField,
    required this.fullNameField,
    this.imageUrlField,
    required this.isVerifiedField,
    required this.tokenField,
    this.phoneNumberField,
    this.ageField,
    this.birthDateField,
  }) : super(
         userId: userIdField,
         emailAddress: emailAddressField,
         fullName: fullNameField,
         imageUrl: imageUrlField,
         isVerified: isVerifiedField,
         token: tokenField,
         phoneNumber: phoneNumberField,
         age: ageField,
         birthDate: birthDateField,
       );

  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userIdField: json['userId'] as String? ?? '',
      emailAddressField: json['emailAddress'] as String? ?? '',
      fullNameField: json['fullName'] as String? ?? '',

      imageUrlField: (json['imageURL'] ?? json['imageURl']) as String?,
      isVerifiedField: json['isVerifed'] as bool? ?? false,
      tokenField: json['token'] as String? ?? '',
      phoneNumberField: json['phoneNumber'] as String?,
      ageField: json['age'] != null ? (json['age'] as num).toInt() : null,
      birthDateField: json['birthDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userIdField,
      'emailAddress': emailAddressField,
      'fullName': fullNameField,
      'imageURl': imageUrlField,
      'isVerifed': isVerifiedField,
      'token': tokenField,
      'phoneNumber': phoneNumberField,
      'age': ageField,
      'birthDate': birthDateField,
    };
  }


  @override
  UserModel copyWith({
    String? userId,
    String? emailAddress,
    String? fullName,
    String? imageUrl,
    bool? isVerified,
    String? token,
    String? phoneNumber,
    int? age,
    String? birthDate,
    bool clearImageUrl = false,
  }) {
    return UserModel(
      userIdField: userId ?? userIdField,
      emailAddressField: emailAddress ?? emailAddressField,
      fullNameField: fullName ?? fullNameField,
      imageUrlField: clearImageUrl ? null : (imageUrl ?? imageUrlField),
      isVerifiedField: isVerified ?? isVerifiedField,
      tokenField: token ?? tokenField,
      phoneNumberField: phoneNumber ?? phoneNumberField,
      ageField: age ?? ageField,
      birthDateField: birthDate ?? birthDateField,
    );
  }
}
