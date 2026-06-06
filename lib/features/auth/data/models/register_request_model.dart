class RegisterRequestModel {
  final String fullName;
  final String emailAddress;
  final String password;
  final String confirmPassword;
  final String? phoneNumber;
  final String? birthDate; 

  RegisterRequestModel({
    required this.fullName,
    required this.emailAddress,
    required this.password,
    required this.confirmPassword,
    this.phoneNumber,
    this.birthDate,
  });

 Map<String, dynamic> toJson() {
  return {
    
      'fullName': fullName,
      'emailAddress': emailAddress,
      'password': password,
      'confirmPassword': confirmPassword,
      'phoneNumber': phoneNumber ?? '',
      if (birthDate != null) 'birthDate': birthDate,
  
  };
}
}
