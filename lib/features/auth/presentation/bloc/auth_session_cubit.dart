import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthSessionStatus {
  unknown,
  unauthenticated,
  authenticated,
}

class AuthSessionState extends Equatable {
  const AuthSessionState({
    required this.status,
    this.user,
  });

  const AuthSessionState.unknown()
      : status = AuthSessionStatus.unknown,
        user = null;

  const AuthSessionState.unauthenticated()
      : status = AuthSessionStatus.unauthenticated,
        user = null;

  const AuthSessionState.authenticated(this.user)
      : status = AuthSessionStatus.authenticated;

  final AuthSessionStatus status;
  final UserEntity? user;

  bool get isKnown => status != AuthSessionStatus.unknown;
  bool get isAuthenticated => status == AuthSessionStatus.authenticated;
  bool get isEmailVerified => user?.emailVerified ?? false;

  @override
  List<Object?> get props => [status, user];
}

class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit(this._repository) : super(const AuthSessionState.unknown());

  final IAuthRepository _repository;
  StreamSubscription<UserEntity?>? _subscription;

  void start() {
    _subscription ??= _repository.authStateChanges().listen(_setUser);
  }

  Future<void> refresh() async {
    final result = await _repository.getCurrentUser();
    result.fold((_) => _setUser(null), _setUser);
  }

  void _setUser(UserEntity? user) {
    if (isClosed) {
      return;
    }

    emit(
      user == null
          ? const AuthSessionState.unauthenticated()
          : AuthSessionState.authenticated(user),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
