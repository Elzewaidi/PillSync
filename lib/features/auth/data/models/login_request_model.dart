class LoginRequestModel {
  final String emailAddress;
  final String password;

  LoginRequestModel({
    required this.emailAddress,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'emailAddress': emailAddress,
      'password': password,
    };
  }
}

