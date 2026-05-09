const _unset = Object();

final class LoginFormState {
  const LoginFormState({
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

  LoginFormState copyWith({
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
    return LoginFormState(
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

final class RegisterFormState {
  const RegisterFormState({
    this.name = '',
    this.phoneNumber = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.nameError,
    this.phoneNumberError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.errorMessage,
    this.hasSubmitted = false,
    this.isSubmitting = false,
    this.isGoogleSubmitting = false,
  });

  final String name;
  final String phoneNumber;
  final String email;
  final String password;
  final String confirmPassword;
  final String? nameError;
  final String? phoneNumberError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? errorMessage;
  final bool hasSubmitted;
  final bool isSubmitting;
  final bool isGoogleSubmitting;

  bool get isBusy => isSubmitting || isGoogleSubmitting;

  RegisterFormState copyWith({
    String? name,
    String? phoneNumber,
    String? email,
    String? password,
    String? confirmPassword,
    Object? nameError = _unset,
    Object? phoneNumberError = _unset,
    Object? emailError = _unset,
    Object? passwordError = _unset,
    Object? confirmPasswordError = _unset,
    Object? errorMessage = _unset,
    bool? hasSubmitted,
    bool? isSubmitting,
    bool? isGoogleSubmitting,
  }) {
    return RegisterFormState(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      nameError:
          identical(nameError, _unset) ? this.nameError : nameError as String?,
      phoneNumberError: identical(phoneNumberError, _unset)
          ? this.phoneNumberError
          : phoneNumberError as String?,
      emailError: identical(emailError, _unset)
          ? this.emailError
          : emailError as String?,
      passwordError: identical(passwordError, _unset)
          ? this.passwordError
          : passwordError as String?,
      confirmPasswordError: identical(confirmPasswordError, _unset)
          ? this.confirmPasswordError
          : confirmPasswordError as String?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isGoogleSubmitting: isGoogleSubmitting ?? this.isGoogleSubmitting,
    );
  }
}

final class ForgotPasswordFormState {
  const ForgotPasswordFormState({
    this.email = '',
    this.emailError,
    this.errorMessage,
    this.successMessage,
    this.resendSecondsRemaining = 0,
    this.isSubmitting = false,
  });

  final String email;
  final String? emailError;
  final String? errorMessage;
  final String? successMessage;
  final int resendSecondsRemaining;
  final bool isSubmitting;

  bool get canSubmit => !isSubmitting && resendSecondsRemaining == 0;

  ForgotPasswordFormState copyWith({
    String? email,
    Object? emailError = _unset,
    Object? errorMessage = _unset,
    Object? successMessage = _unset,
    int? resendSecondsRemaining,
    bool? isSubmitting,
  }) {
    return ForgotPasswordFormState(
      email: email ?? this.email,
      emailError: identical(emailError, _unset)
          ? this.emailError
          : emailError as String?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      successMessage: identical(successMessage, _unset)
          ? this.successMessage
          : successMessage as String?,
      resendSecondsRemaining:
          resendSecondsRemaining ?? this.resendSecondsRemaining,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
