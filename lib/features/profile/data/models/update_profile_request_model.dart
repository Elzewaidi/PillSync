class UpdateProfileRequestModel {
  final String fullName;
  final String emailAddress;
  final String? phoneNumber;
  final String? birthDate;
  final String? imageUrl;

  UpdateProfileRequestModel({
    required this.fullName,
    required this.emailAddress,
    this.phoneNumber,
    this.birthDate,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'emailAddress': emailAddress,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (birthDate != null) 'birthDate': birthDate,
      if (imageUrl != null) 'imageURL': imageUrl,
    };
  }
}
