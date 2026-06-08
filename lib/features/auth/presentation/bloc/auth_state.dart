import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthIdle extends AuthState {
  const AuthIdle();
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class OTPVerificationRequired extends AuthState {
  final String email;

  const OTPVerificationRequired({required this.email});

  @override
  List<Object?> get props => [email];
}

class RegistrationSuccess extends AuthState {
  final String email;

  const RegistrationSuccess({required this.email});

  @override
  List<Object?> get props => [email];
}

class OTPVerificationSuccess extends AuthState {
  const OTPVerificationSuccess();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class ForgetPasswordEmailSent extends AuthState {
  final String email;
  const ForgetPasswordEmailSent({required this.email});

  @override
  List<Object?> get props => [email];
}

class NavigateToForgetPasswordState extends AuthState {
  const NavigateToForgetPasswordState();
}

class RegistrationSuccessMessage extends AuthState {
  final String message;
  const RegistrationSuccessMessage(this.message);
  @override
  List<Object?> get props => [message];
}
class ResetPasswordSuccess extends AuthState {
  const ResetPasswordSuccess();
}