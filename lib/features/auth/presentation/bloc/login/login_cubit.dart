import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/storage_keys.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../../shared/services/local_storage_service.dart';
import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/sign_in_with_google.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required LocalStorageService localStorage,
    required LoginUseCase login,
    required SignInWithGoogleUseCase signInWithGoogle,
  })  : _localStorage = localStorage,
        _login = login,
        _signInWithGoogle = signInWithGoogle,
        super(const LoginState());

  final LocalStorageService _localStorage;
  final LoginUseCase _login;
  final SignInWithGoogleUseCase _signInWithGoogle;

  void loadRememberedEmail() {
    final email = _localStorage.getString(StorageKeys.rememberedEmail);

    if (email.isEmpty || state.email.isNotEmpty) {
      return;
    }

    emit(state.copyWith(email: email, rememberMe: true));
  }

  void emailChanged(String value, AppLocalizations l10n) {
    emit(
      state.copyWith(
        email: value,
        emailError: state.hasSubmitted ? Validators.email(value, l10n) : null,
        errorMessage: null,
        requiresEmailVerification: false,
      ),
    );
  }

  void passwordChanged(String value, AppLocalizations l10n) {
    emit(
      state.copyWith(
        password: value,
        passwordError:
            state.hasSubmitted ? Validators.password(value, l10n) : null,
        errorMessage: null,
        requiresEmailVerification: false,
      ),
    );
  }

  void rememberChanged(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  Future<bool> submit(AppLocalizations l10n) async {
    if (state.isBusy || !_validate(l10n)) {
      return false;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        requiresEmailVerification: false,
      ),
    );

    final result = await _login(
      LoginParams(email: state.email, password: state.password),
    );

    return result.fold((failure) async {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: failure.localizedMessage(l10n),
        ),
      );
      return false;
    }, (user) async {
      await _persistRememberedEmail();

      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: null,
          requiresEmailVerification: !user.emailVerified,
        ),
      );
      return true;
    });
  }

  Future<bool> signInWithGoogle(AppLocalizations l10n) async {
    if (state.isBusy) {
      return false;
    }

    emit(
      state.copyWith(
        isGoogleSubmitting: true,
        errorMessage: null,
        requiresEmailVerification: false,
      ),
    );

    final result = await _signInWithGoogle(const NoParams());

    return result.fold((failure) {
      emit(
        state.copyWith(
          isGoogleSubmitting: false,
          errorMessage: failure.localizedMessage(l10n),
        ),
      );
      return false;
    }, (user) {
      emit(
        state.copyWith(
          isGoogleSubmitting: false,
          errorMessage: null,
          requiresEmailVerification: !user.emailVerified,
        ),
      );
      return true;
    });
  }

  bool _validate(AppLocalizations l10n) {
    final emailError = Validators.email(state.email, l10n);
    final passwordError = Validators.password(state.password, l10n);

    emit(
      state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
        errorMessage: null,
        requiresEmailVerification: false,
        hasSubmitted: true,
      ),
    );

    return emailError == null && passwordError == null;
  }

  Future<void> _persistRememberedEmail() async {
    if (state.rememberMe) {
      await _localStorage.setString(
        StorageKeys.rememberedEmail,
        state.email.trim(),
      );
      return;
    }

    await _localStorage.remove(StorageKeys.rememberedEmail);
  }
}
