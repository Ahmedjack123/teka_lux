import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/startup_state.dart';
import '../../domain/usecases/resolve_initial_route.dart';

enum StartupViewStatus {
  loading,
  resolved,
  failure,
}

class StartupViewState {
  const StartupViewState({
    required this.status,
    this.destination,
  });

  const StartupViewState.loading()
      : status = StartupViewStatus.loading,
        destination = null;

  const StartupViewState.resolved(this.destination)
      : status = StartupViewStatus.resolved;

  const StartupViewState.failure()
      : status = StartupViewStatus.failure,
        destination = null;

  final StartupViewStatus status;
  final StartupDestination? destination;
}

class StartupCubit extends Cubit<StartupViewState> {
  StartupCubit(this._resolveInitialRoute)
      : super(const StartupViewState.loading());

  final ResolveInitialRoute _resolveInitialRoute;

  Future<void> resolve() async {
    emit(const StartupViewState.loading());

    try {
      final destination = await _resolveInitialRoute();
      emit(StartupViewState.resolved(destination));
    } on Object {
      emit(const StartupViewState.failure());
    }
  }
}
