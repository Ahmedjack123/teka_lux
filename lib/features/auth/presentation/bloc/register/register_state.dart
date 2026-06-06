import 'package:equatable/equatable.dart';

const _unset = Object();

class RegisterState extends Equatable {
  const RegisterState({
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
    this.termsError,
    this.errorMessage,
    this.acceptedTerms = false,
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
  final String? termsError;
  final String? errorMessage;
  final bool acceptedTerms;
  final bool hasSubmitted;
  final bool isSubmitting;
  final bool isGoogleSubmitting;

  bool get isBusy => isSubmitting || isGoogleSubmitting;

  @override
  List<Object?> get props => [
        name,
        phoneNumber,
        email,
        password,
        confirmPassword,
        nameError,
        phoneNumberError,
        emailError,
        passwordError,
        confirmPasswordError,
        termsError,
        errorMessage,
        acceptedTerms,
        hasSubmitted,
        isSubmitting,
        isGoogleSubmitting,
      ];

  RegisterState copyWith({
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
    Object? termsError = _unset,
    Object? errorMessage = _unset,
    bool? acceptedTerms,
    bool? hasSubmitted,
    bool? isSubmitting,
    bool? isGoogleSubmitting,
  }) {
    return RegisterState(
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
      termsError: identical(termsError, _unset)
          ? this.termsError
          : termsError as String?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isGoogleSubmitting: isGoogleSubmitting ?? this.isGoogleSubmitting,
    );
  }
}
