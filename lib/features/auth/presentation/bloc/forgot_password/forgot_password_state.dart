import 'package:equatable/equatable.dart';

const _unset = Object();

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = '',
    this.emailError,
    this.errorMessage,
    this.successMessage,
    this.isSubmitting = false,
  });

  final String email;
  final String? emailError;
  final String? errorMessage;
  final String? successMessage;
  final bool isSubmitting;

  @override
  List<Object?> get props => [
        email,
        emailError,
        errorMessage,
        successMessage,
        isSubmitting,
      ];

  ForgotPasswordState copyWith({
    String? email,
    Object? emailError = _unset,
    Object? errorMessage = _unset,
    Object? successMessage = _unset,
    bool? isSubmitting,
  }) {
    return ForgotPasswordState(
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
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
