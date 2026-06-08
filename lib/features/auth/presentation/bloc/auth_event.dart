import 'package:equatable/equatable.dart';
import 'package:pillsync/features/auth/domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {
  const AppStarted();
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String? phoneNumber;
  final String? birthDate;

  const RegisterRequested({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phoneNumber,
    this.birthDate,
  });

  @override
  List<Object?> get props => [
    fullName, email, password, confirmPassword, phoneNumber, birthDate
  ];
}

class OTPVerificationRequested extends AuthEvent {
  final String email;
  final String otpCode;
  final bool isFromRegistration; 

  const OTPVerificationRequested({
    required this.email,
    required this.otpCode,
    this.isFromRegistration = false, 
  });

  @override
  List<Object> get props => [email, otpCode, isFromRegistration];
}

class ResendOTPRequested extends AuthEvent {
  final String email;

  const ResendOTPRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class ForgetPasswordRequested extends AuthEvent {
  final String email;

  const ForgetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class NavigateToRegister extends AuthEvent {
  const NavigateToRegister();
}

class NavigateToLogin extends AuthEvent {
  const NavigateToLogin();
}

class NavigateToOTP extends AuthEvent {
  final String email;

  const NavigateToOTP({required this.email});

  @override
  List<Object> get props => [email];
}

class NavigateToForgetPassword extends AuthEvent {
  const NavigateToForgetPassword();
}

class ResetAuthState extends AuthEvent {
  const ResetAuthState();
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String otpCode; 
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordRequested({
    required this.email,
    required this.otpCode, 
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, otpCode, newPassword, confirmPassword];
}
class UpdateUserData extends AuthEvent {
  final User updatedUser;
  const UpdateUserData(this.updatedUser);

  @override
  List<Object?> get props => [updatedUser];
}


