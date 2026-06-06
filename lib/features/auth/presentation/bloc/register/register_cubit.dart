import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../domain/usecases/register.dart';
import '../../../domain/usecases/sign_in_with_google.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({
    required RegisterUseCase register,
    required SignInWithGoogleUseCase signInWithGoogle,
  })  : _register = register,
        _signInWithGoogle = signInWithGoogle,
        super(const RegisterState());

  final RegisterUseCase _register;
  final SignInWithGoogleUseCase _signInWithGoogle;

  void nameChanged(String value, AppLocalizations l10n) {
    emit(
      state.copyWith(
        name: value,
        nameError: state.hasSubmitted ? Validators.name(value, l10n) : null,
        errorMessage: null,
      ),
    );
  }

  void phoneNumberChanged(String value, AppLocalizations l10n) {
    emit(
      state.copyWith(
        phoneNumber: value,
        phoneNumberError:
            state.hasSubmitted ? Validators.phoneNumber(value, l10n) : null,
        errorMessage: null,
      ),
    );
  }

  void emailChanged(String value, AppLocalizations l10n) {
    emit(
      state.copyWith(
        email: value,
        emailError: state.hasSubmitted ? Validators.email(value, l10n) : null,
        errorMessage: null,
      ),
    );
  }

  void passwordChanged(String value, AppLocalizations l10n) {
    emit(
      state.copyWith(
        password: value,
        passwordError:
            state.hasSubmitted ? Validators.password(value, l10n) : null,
        confirmPasswordError: state.hasSubmitted
            ? Validators.confirmPassword(state.confirmPassword, value, l10n)
            : null,
        errorMessage: null,
      ),
    );
  }

  void confirmPasswordChanged(String value, AppLocalizations l10n) {
    emit(
      state.copyWith(
        confirmPassword: value,
        confirmPasswordError: state.hasSubmitted
            ? Validators.confirmPassword(value, state.password, l10n)
            : null,
        errorMessage: null,
      ),
    );
  }

  void termsChanged(bool value, AppLocalizations l10n) {
    emit(
      state.copyWith(
        acceptedTerms: value,
        termsError:
            state.hasSubmitted && !value ? l10n.validationTermsRequired : null,
        errorMessage: null,
      ),
    );
  }

  Future<bool> submit(AppLocalizations l10n) async {
    if (state.isBusy || !_validate(l10n)) {
      return false;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final registerResult = await _register(
      RegisterParams(
        email: state.email,
        password: state.password,
        name: state.name,
        phoneNumber: state.phoneNumber,
      ),
    );

    return registerResult.fold((failure) async {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: failure.localizedMessage(l10n),
        ),
      );
      return false;
    }, (_) async {
      emit(state.copyWith(isSubmitting: false, errorMessage: null));
      return true;
    });
  }

  Future<bool> signInWithGoogle(AppLocalizations l10n) async {
    if (state.isBusy) {
      return false;
    }

    emit(state.copyWith(isGoogleSubmitting: true, errorMessage: null));

    final result = await _signInWithGoogle(const NoParams());

    return result.fold((failure) {
      emit(
        state.copyWith(
          isGoogleSubmitting: false,
          errorMessage: failure.localizedMessage(l10n),
        ),
      );
      return false;
    }, (_) {
      emit(state.copyWith(isGoogleSubmitting: false, errorMessage: null));
      return true;
    });
  }

  bool _validate(AppLocalizations l10n) {
    final nameError = Validators.name(state.name, l10n);
    final phoneNumberError = Validators.phoneNumber(state.phoneNumber, l10n);
    final emailError = Validators.email(state.email, l10n);
    final passwordError = Validators.password(state.password, l10n);
    final confirmPasswordError = Validators.confirmPassword(
      state.confirmPassword,
      state.password,
      l10n,
    );
    final termsError =
        state.acceptedTerms ? null : l10n.validationTermsRequired;

    emit(
      state.copyWith(
        nameError: nameError,
        phoneNumberError: phoneNumberError,
        emailError: emailError,
        passwordError: passwordError,
        confirmPasswordError: confirmPasswordError,
        termsError: termsError,
        errorMessage: null,
        hasSubmitted: true,
      ),
    );

    return nameError == null &&
        phoneNumberError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        termsError == null;
  }
}
