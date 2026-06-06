import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/validators.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../domain/usecases/forgot_password.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._resetPassword)
      : super(const ForgotPasswordState());

  final ResetPasswordUseCase _resetPassword;

  void emailChanged(String value, AppLocalizations l10n) {
    emit(
      state.copyWith(
        email: value,
        emailError: value.isEmpty ? null : Validators.email(value, l10n),
        errorMessage: null,
        successMessage: null,
      ),
    );
  }

  Future<bool> submit(AppLocalizations l10n) async {
    if (state.isSubmitting) {
      return false;
    }

    final emailError = Validators.email(state.email, l10n);
    emit(
      state.copyWith(
        emailError: emailError,
        errorMessage: null,
        successMessage: null,
      ),
    );

    if (emailError != null) {
      return false;
    }

    emit(state.copyWith(isSubmitting: true));

    final result =
        await _resetPassword(ResetPasswordParams(email: state.email));

    return result.fold((failure) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: failure.localizedMessage(l10n),
        ),
      );
      return false;
    }, (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: l10n.passwordResetEmailSent,
        ),
      );
      return true;
    });
  }
}
