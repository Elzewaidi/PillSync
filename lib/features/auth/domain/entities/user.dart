import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String emailAddress;
  final String fullName;
  final String? imageUrl;
  final bool isVerified;
  final String token;
  final String? phoneNumber;
  final int? age;
  final String? birthDate;

  const User({
    required this.userId,
    required this.emailAddress,
    required this.fullName,
    this.imageUrl,
    required this.isVerified,
    required this.token,
    this.phoneNumber,
    this.age,
    this.birthDate,
  });


  User copyWith({
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
    return User(
      userId: userId ?? this.userId,
      emailAddress: emailAddress ?? this.emailAddress,
      fullName: fullName ?? this.fullName,
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      isVerified: isVerified ?? this.isVerified,
      token: token ?? this.token,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      birthDate: birthDate ?? this.birthDate,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    emailAddress,
    fullName,
    imageUrl,
    isVerified,
    token,
    phoneNumber,
    age,
    birthDate,
  ];
}
