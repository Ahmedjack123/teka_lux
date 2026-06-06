import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/usecases/logout.dart';
import '../../../auth/presentation/bloc/auth_session_cubit.dart';

enum HomeStatus {
  idle,
  signingOut,
  signedOut,
  failure,
}

class HomeState {
  const HomeState({
    this.status = HomeStatus.idle,
  });

  final HomeStatus status;

  bool get isSigningOut => status == HomeStatus.signingOut;
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required SignOutUseCase signOut,
    required AuthSessionCubit authSessionCubit,
  })  : _signOut = signOut,
        _authSessionCubit = authSessionCubit,
        super(const HomeState());

  final SignOutUseCase _signOut;
  final AuthSessionCubit _authSessionCubit;

  Future<void> signOut() async {
    if (state.isSigningOut) {
      return;
    }

    emit(const HomeState(status: HomeStatus.signingOut));

    final result = await _signOut(const NoParams());

    await result.fold((_) async {
      emit(const HomeState(status: HomeStatus.failure));
    }, (_) async {
      await _authSessionCubit.refresh();
      emit(const HomeState(status: HomeStatus.signedOut));
    });
  }
}
