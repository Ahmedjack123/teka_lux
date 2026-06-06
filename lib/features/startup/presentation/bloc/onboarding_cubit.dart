import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/complete_onboarding.dart';

enum OnboardingSaveStatus {
  idle,
  saving,
  success,
  failure,
}

class OnboardingState {
  const OnboardingState({
    this.status = OnboardingSaveStatus.idle,
  });

  final OnboardingSaveStatus status;

  bool get isSaving => status == OnboardingSaveStatus.saving;

  OnboardingState copyWith({OnboardingSaveStatus? status}) {
    return OnboardingState(status: status ?? this.status);
  }
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._completeOnboarding) : super(const OnboardingState());

  final CompleteOnboarding _completeOnboarding;

  Future<bool> complete() async {
    if (state.isSaving) {
      return false;
    }

    emit(state.copyWith(status: OnboardingSaveStatus.saving));

    try {
      await _completeOnboarding();
      emit(state.copyWith(status: OnboardingSaveStatus.success));
      return true;
    } on Object {
      emit(state.copyWith(status: OnboardingSaveStatus.failure));
      return false;
    }
  }
}
