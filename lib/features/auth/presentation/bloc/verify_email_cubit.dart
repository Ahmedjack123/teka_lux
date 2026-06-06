import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/usecases/check_email_verified.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/verify_email.dart';
import 'auth_session_cubit.dart';

const _unset = Object();

class VerifyEmailState extends Equatable {
  const VerifyEmailState({
    this.isChecking = false,
    this.isResending = false,
    this.isVerified = false,
    this.resendSecondsRemaining = 0,
    this.message,
    this.errorMessage,
  });

  final bool isChecking;
  final bool isResending;
  final bool isVerified;
  final int resendSecondsRemaining;
  final String? message;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        isChecking,
        isResending,
        isVerified,
        resendSecondsRemaining,
        message,
        errorMessage,
      ];

  VerifyEmailState copyWith({
    bool? isChecking,
    bool? isResending,
    bool? isVerified,
    int? resendSecondsRemaining,
    Object? message = _unset,
    Object? errorMessage = _unset,
  }) {
    return VerifyEmailState(
      isChecking: isChecking ?? this.isChecking,
      isResending: isResending ?? this.isResending,
      isVerified: isVerified ?? this.isVerified,
      resendSecondsRemaining:
          resendSecondsRemaining ?? this.resendSecondsRemaining,
      message: identical(message, _unset) ? this.message : message as String?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit({
    required VerifyEmailUseCase verifyEmail,
    required CheckEmailVerifiedUseCase checkEmailVerified,
    required SignOutUseCase signOut,
    required AuthSessionCubit authSessionCubit,
  })  : _verifyEmail = verifyEmail,
        _checkEmailVerified = checkEmailVerified,
        _signOut = signOut,
        _authSessionCubit = authSessionCubit,
        super(const VerifyEmailState());

  static const int resendCooldownSeconds = 60;

  final VerifyEmailUseCase _verifyEmail;
  final CheckEmailVerifiedUseCase _checkEmailVerified;
  final SignOutUseCase _signOut;
  final AuthSessionCubit _authSessionCubit;

  Timer? _verificationTimer;
  Timer? _cooldownTimer;

  void start({
    required bool emailJustSent,
    required AppLocalizations l10n,
  }) {
    if (emailJustSent) {
      emit(
        state.copyWith(
          resendSecondsRemaining: resendCooldownSeconds,
        ),
      );
      _startResendCooldown();
      // Send the initial verification email
      unawaited(_sendVerificationEmail(l10n));
    }

    _verificationTimer ??= Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkVerification(l10n),
    );
    unawaited(checkVerification(l10n));
  }

  Future<void> checkVerification(AppLocalizations l10n) async {
    if (state.isChecking || state.isVerified || isClosed) {
      return;
    }

    emit(state.copyWith(isChecking: true));

    final result = await _checkEmailVerified(const NoParams());

    if (isClosed) {
      return;
    }

    result.fold((failure) {
      emit(
        state.copyWith(
          isChecking: false,
          errorMessage: failure.localizedMessage(l10n),
        ),
      );
    }, (verified) {
      if (!verified) {
        emit(state.copyWith(isChecking: false));
        return;
      }

      _verificationTimer?.cancel();
      _cooldownTimer?.cancel();
      unawaited(_authSessionCubit.refresh());

      emit(
        state.copyWith(
          isChecking: false,
          isVerified: true,
          message: null,
          errorMessage: null,
          resendSecondsRemaining: 0,
        ),
      );
    });
  }

  Future<void> resendEmail(AppLocalizations l10n) async {
    if (state.isResending ||
        state.isVerified ||
        state.resendSecondsRemaining > 0) {
      return;
    }

    await _sendVerificationEmail(l10n);
  }

  Future<void> _sendVerificationEmail(AppLocalizations l10n) async {
    emit(
      state.copyWith(
        isResending: true,
        message: null,
        errorMessage: null,
      ),
    );

    final result = await _verifyEmail(const NoParams());

    if (isClosed) {
      return;
    }

    result.fold((failure) {
      emit(
        state.copyWith(
          isResending: false,
          errorMessage: failure.localizedMessage(l10n),
        ),
      );
    }, (_) {
      emit(
        state.copyWith(
          isResending: false,
          message: l10n.emailVerificationSent,
          resendSecondsRemaining: resendCooldownSeconds,
        ),
      );
      _startResendCooldown();
    });
  }

  Future<void> signOut() async {
    await _signOut(const NoParams());
    await _authSessionCubit.refresh();
  }

  void _startResendCooldown() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }

      if (state.resendSecondsRemaining <= 1) {
        timer.cancel();
        emit(state.copyWith(resendSecondsRemaining: 0));
        return;
      }

      emit(
        state.copyWith(
          resendSecondsRemaining: state.resendSecondsRemaining - 1,
        ),
      );
    });
  }

  @override
  Future<void> close() async {
    _verificationTimer?.cancel();
    _cooldownTimer?.cancel();
    return super.close();
  }
}
