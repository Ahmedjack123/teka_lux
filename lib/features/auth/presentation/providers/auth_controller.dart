import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/validators.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/providers/storage_provider.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import 'auth_provider.dart';
import 'auth_state.dart';

final loginFormControllerProvider =
    NotifierProvider.autoDispose<LoginFormController, LoginFormState>(
  LoginFormController.new,
);

final registerFormControllerProvider =
    NotifierProvider.autoDispose<RegisterFormController, RegisterFormState>(
  RegisterFormController.new,
);

final forgotPasswordFormControllerProvider = NotifierProvider.autoDispose<
    ForgotPasswordFormController, ForgotPasswordFormState>(
  ForgotPasswordFormController.new,
);

final class LoginFormController extends Notifier<LoginFormState> {
  @override
  LoginFormState build() => const LoginFormState();

  Future<void> loadRememberedEmail() async {
    final storage = await ref.read(localStorageServiceProvider.future);
    final email = storage.getString(StorageKeys.rememberedEmail);

    if (email.isEmpty || state.email.isNotEmpty) {
      return;
    }

    state = state.copyWith(email: email, rememberMe: true);
  }

  void emailChanged(String value, AppLocalizations l10n) {
    state = state.copyWith(
      email: value,
      emailError: state.hasSubmitted ? Validators.email(value, l10n) : null,
      errorMessage: null,
      requiresEmailVerification: false,
    );
  }

  void passwordChanged(String value, AppLocalizations l10n) {
    state = state.copyWith(
      password: value,
      passwordError:
          state.hasSubmitted ? Validators.password(value, l10n) : null,
      errorMessage: null,
      requiresEmailVerification: false,
    );
  }

  void rememberChanged(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  Future<bool> submit(AppLocalizations l10n) async {
    if (state.isBusy || !_validate(l10n)) {
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      errorMessage: null,
      requiresEmailVerification: false,
    );

    final result = await ref.read(loginUseCaseProvider)(
      LoginParams(email: state.email, password: state.password),
    );

    return result.fold((failure) async {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: failure.localizedMessage(l10n),
      );
      return false;
    }, (user) async {
      await _persistRememberedEmail();

      if (!user.emailVerified) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: null,
          requiresEmailVerification: true,
        );
        return true;
      }

      state = state.copyWith(
        isSubmitting: false,
        errorMessage: null,
        requiresEmailVerification: false,
      );
      return true;
    });
  }

  Future<bool> signInWithGoogle(AppLocalizations l10n) async {
    if (state.isBusy) {
      return false;
    }

    state = state.copyWith(
      isGoogleSubmitting: true,
      errorMessage: null,
      requiresEmailVerification: false,
    );

    final result = await ref.read(signInWithGoogleUseCaseProvider)(
      const NoParams(),
    );

    return result.fold((failure) {
      state = state.copyWith(
        isGoogleSubmitting: false,
        errorMessage: failure.localizedMessage(l10n),
      );
      return false;
    }, (user) {
      state = state.copyWith(
        isGoogleSubmitting: false,
        errorMessage: null,
        requiresEmailVerification: !user.emailVerified,
      );
      return true;
    });
  }

  bool _validate(AppLocalizations l10n) {
    final emailError = Validators.email(state.email, l10n);
    final passwordError = Validators.password(state.password, l10n);

    state = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
      errorMessage: null,
      requiresEmailVerification: false,
      hasSubmitted: true,
    );

    return emailError == null && passwordError == null;
  }

  Future<void> _persistRememberedEmail() async {
    final storage = await ref.read(localStorageServiceProvider.future);

    if (state.rememberMe) {
      await storage.setString(StorageKeys.rememberedEmail, state.email.trim());
      return;
    }

    await storage.remove(StorageKeys.rememberedEmail);
  }
}

final class RegisterFormController extends Notifier<RegisterFormState> {
  @override
  RegisterFormState build() => const RegisterFormState();

  void nameChanged(String value, AppLocalizations l10n) {
    state = state.copyWith(
      name: value,
      nameError: state.hasSubmitted ? Validators.name(value, l10n) : null,
      errorMessage: null,
    );
  }

  void phoneNumberChanged(String value, AppLocalizations l10n) {
    state = state.copyWith(
      phoneNumber: value,
      phoneNumberError:
          state.hasSubmitted ? Validators.phoneNumber(value, l10n) : null,
      errorMessage: null,
    );
  }

  void emailChanged(String value, AppLocalizations l10n) {
    state = state.copyWith(
      email: value,
      emailError: state.hasSubmitted ? Validators.email(value, l10n) : null,
      errorMessage: null,
    );
  }

  void passwordChanged(String value, AppLocalizations l10n) {
    state = state.copyWith(
      password: value,
      passwordError:
          state.hasSubmitted ? Validators.password(value, l10n) : null,
      confirmPasswordError: state.hasSubmitted
          ? Validators.confirmPassword(state.confirmPassword, value, l10n)
          : null,
      errorMessage: null,
    );
  }

  void confirmPasswordChanged(String value, AppLocalizations l10n) {
    state = state.copyWith(
      confirmPassword: value,
      confirmPasswordError: state.hasSubmitted
          ? Validators.confirmPassword(value, state.password, l10n)
          : null,
      errorMessage: null,
    );
  }

  Future<bool> submit(AppLocalizations l10n) async {
    if (state.isBusy || !_validate(l10n)) {
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    final registerResult = await ref.read(registerUseCaseProvider)(
      RegisterParams(
        email: state.email,
        password: state.password,
        name: state.name,
        phoneNumber: state.phoneNumber,
      ),
    );

    return registerResult.fold((failure) async {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: failure.localizedMessage(l10n),
      );
      return false;
    }, (_) {
      state = state.copyWith(isSubmitting: false, errorMessage: null);
      return true;
    });
  }

  Future<bool> signInWithGoogle(AppLocalizations l10n) async {
    if (state.isBusy) {
      return false;
    }

    state = state.copyWith(isGoogleSubmitting: true, errorMessage: null);

    final result = await ref.read(signInWithGoogleUseCaseProvider)(
      const NoParams(),
    );

    return result.fold((failure) {
      state = state.copyWith(
        isGoogleSubmitting: false,
        errorMessage: failure.localizedMessage(l10n),
      );
      return false;
    }, (_) {
      state = state.copyWith(isGoogleSubmitting: false, errorMessage: null);
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

    state = state.copyWith(
      nameError: nameError,
      phoneNumberError: phoneNumberError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      errorMessage: null,
      hasSubmitted: true,
    );

    return nameError == null &&
        phoneNumberError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }
}

final class ForgotPasswordFormController
    extends Notifier<ForgotPasswordFormState> {
  @override
  ForgotPasswordFormState build() => const ForgotPasswordFormState();

  void emailChanged(String value, AppLocalizations l10n) {
    state = state.copyWith(
      email: value,
      emailError: value.isEmpty ? null : Validators.email(value, l10n),
      errorMessage: null,
      successMessage: null,
    );
  }

  Future<bool> submit(AppLocalizations l10n) async {
    if (state.isSubmitting) {
      return false;
    }

    final emailError = Validators.email(state.email, l10n);
    state = state.copyWith(
      emailError: emailError,
      errorMessage: null,
      successMessage: null,
    );

    if (emailError != null) {
      return false;
    }

    state = state.copyWith(isSubmitting: true);

    final result = await ref.read(resetPasswordUseCaseProvider)(
      ResetPasswordParams(email: state.email),
    );

    return result.fold((failure) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: failure.localizedMessage(l10n),
      );
      return false;
    }, (_) {
      state = state.copyWith(
        isSubmitting: false,
        successMessage: l10n.passwordResetEmailSent,
      );
      return true;
    });
  }
}
