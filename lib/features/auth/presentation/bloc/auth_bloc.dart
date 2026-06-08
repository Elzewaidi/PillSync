import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/features/auth/domain/usecases/reset_password.dart';
import 'package:pillsync/features/auth/domain/usecases/send_otp.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_auth_status.dart';
import '../../domain/usecases/forget_password.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/verify_otp.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Register _register;
  final VerifyOTP _verifyOTP;
  final SendOTP _sendOTP;
  final Logout _logout;
  final CheckAuthStatus _checkAuthStatus;
  final ForgetPassword _forgetPassword;
  final ResetPassword _resetPassword;

  AuthBloc({
    required Login login,
    required Register register,
    required VerifyOTP verifyOTP,
    required SendOTP sendOTP,
    required Logout logout,
    required CheckAuthStatus checkAuthStatus,
    required ForgetPassword forgetPassword,
    required ResetPassword resetPassword,
  }) : _login = login,
       _register = register,
       _verifyOTP = verifyOTP,
       _sendOTP = sendOTP,
       _logout = logout,
       _checkAuthStatus = checkAuthStatus,
       _forgetPassword = forgetPassword,

       _resetPassword = resetPassword,
       super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<OTPVerificationRequested>(_onOTPVerificationRequested);
    on<ResendOTPRequested>(_onResendOTPRequested);
    on<ForgetPasswordRequested>(_onForgetPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<NavigateToRegister>(_onNavigateToRegister);
    on<NavigateToLogin>(_onNavigateToLogin);
    on<NavigateToOTP>(_onNavigateToOTP);
    on<NavigateToForgetPassword>(_onNavigateToForgetPassword);
    on<ResetAuthState>(_onResetAuthState);
    on<UpdateUserData>(_onUpdateUserData);
   



  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _checkAuthStatus(const NoParams());

    result.fold((failure) => emit(const Unauthenticated()), (user) {
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
    });
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _login(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold((failure) => emit(AuthError(failure.message)), (user) {
      emit(Authenticated(user));
    });
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _register(
      RegisterParams(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
        phoneNumber: event.phoneNumber,
        birthDate: event.birthDate,
      ),
    );

    if (result.isLeft()) {
      final failure = result.fold((f) => f, (_) => null)!;
      emit(AuthError(failure.message));
      return;
    }

    final user = result.fold((_) => null, (u) => u)!;

    emit(const AuthLoading());

    final sendOtpResult = await _sendOTP(
      SendOTPParams(email: user.emailAddress, token: user.token),
    );

    sendOtpResult.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(OTPVerificationRequired(email: user.emailAddress)),
    );
  }

  Future<void> _onOTPVerificationRequested(
    OTPVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    String? token;

   
    if (event.isFromRegistration) {
      final userResult = await _checkAuthStatus(const NoParams());
      token = userResult.fold((_) => null, (user) => user?.token);
    }

    final result = await _verifyOTP(
      VerifyOTPParams(
        email: event.email.trim(),
        otpCode: event.otpCode.trim(),
        token: token,
        requiresAuth: event.isFromRegistration,
      ),
    );

    if (result.isLeft()) {
      final failure = result.fold((f) => f, (_) => null)!;
      emit(AuthError(failure.message));
      return;
    }

    final isVerified = result.fold((_) => false, (v) => v);

    if (isVerified) {
      if (event.isFromRegistration) {
        final updatedUser = await _checkAuthStatus(const NoParams());
        updatedUser.fold(
          (_) => emit(const OTPVerificationSuccess()),
          (user) => user != null
              ? emit(Authenticated(user))
              : emit(const OTPVerificationSuccess()),
        );
      } else {
        // Forget Password
        emit(const OTPVerificationSuccess());
      }
    } else {
      emit(const AuthError('Invalid or expired OTP.'));
    }
  }

  Future<void> _onResendOTPRequested(
    ResendOTPRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final userResult = await _checkAuthStatus(const NoParams());
    final token = userResult.fold((_) => null, (user) => user?.token);

    final result = await _sendOTP(
      SendOTPParams(email: event.email, token: token),
    );

    result.fold((failure) => emit(AuthError(failure.message)), (_) {
      emit(OTPVerificationRequired(email: event.email));
    });
  }

  Future<void> _onForgetPasswordRequested(
    ForgetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _forgetPassword(
      ForgetPasswordParams(email: event.email),
    );

    result.fold((failure) => emit(AuthError(failure.message)), (_) {
      emit(ForgetPasswordEmailSent(email: event.email));
    });
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _resetPassword(
      ResetPasswordParams(
        email: event.email,
        otpCode: event.otpCode,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const ResetPasswordSuccess()),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _logout(const NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  void _onNavigateToRegister(
    NavigateToRegister event,
    Emitter<AuthState> emit,
  ) {
    emit(const Unauthenticated());
  }

  void _onNavigateToLogin(NavigateToLogin event, Emitter<AuthState> emit) {
    emit(const Unauthenticated());
  }

  void _onNavigateToOTP(NavigateToOTP event, Emitter<AuthState> emit) {
    emit(OTPVerificationRequired(email: event.email));
  }

  void _onNavigateToForgetPassword(
    NavigateToForgetPassword event,
    Emitter<AuthState> emit,
  ) {
    emit(const NavigateToForgetPasswordState());
  }

  void _onResetAuthState(ResetAuthState event, Emitter<AuthState> emit) {
    emit(const AuthIdle());
  }
 void _onUpdateUserData(UpdateUserData event, Emitter<AuthState> emit) {
  emit(Authenticated(event.updatedUser));
}

}
