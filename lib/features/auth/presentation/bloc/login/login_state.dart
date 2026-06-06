import 'package:equatable/equatable.dart';

const _unset = Object();

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.emailError,
    this.passwordError,
    this.errorMessage,
    this.requiresEmailVerification = false,
    this.hasSubmitted = false,
    this.isSubmitting = false,
    this.isGoogleSubmitting = false,
  });

  final String email;
  final String password;
  final bool rememberMe;
  final String? emailError;
  final String? passwordError;
  final String? errorMessage;
  final bool requiresEmailVerification;
  final bool hasSubmitted;
  final bool isSubmitting;
  final bool isGoogleSubmitting;

  bool get isBusy => isSubmitting || isGoogleSubmitting;

  @override
  List<Object?> get props => [
        email,
        password,
        rememberMe,
        emailError,
        passwordError,
        errorMessage,
        requiresEmailVerification,
        hasSubmitted,
        isSubmitting,
        isGoogleSubmitting,
      ];

  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    Object? emailError = _unset,
    Object? passwordError = _unset,
    Object? errorMessage = _unset,
    bool? requiresEmailVerification,
    bool? hasSubmitted,
    bool? isSubmitting,
    bool? isGoogleSubmitting,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      emailError: identical(emailError, _unset)
          ? this.emailError
          : emailError as String?,
      passwordError: identical(passwordError, _unset)
          ? this.passwordError
          : passwordError as String?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      requiresEmailVerification:
          requiresEmailVerification ?? this.requiresEmailVerification,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isGoogleSubmitting: isGoogleSubmitting ?? this.isGoogleSubmitting,
    );
  }
}
