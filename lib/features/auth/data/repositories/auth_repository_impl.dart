import '../../../../core/errors/auth_error_code.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

final class AuthRepositoryImpl implements IAuthRepository {
  const AuthRepositoryImpl(this._remoteDatasource);

  final AuthRemoteDatasource _remoteDatasource;

  @override
  Stream<UserEntity?> authStateChanges() {
    return _remoteDatasource.authStateChanges().map((user) => user?.toEntity());
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() {
    return _guard(() async {
      final user = await _remoteDatasource.getCurrentUser();
      return user?.toEntity();
    });
  }

  @override
  Future<Result<UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final user = await _remoteDatasource.signInWithEmail(
        email: email,
        password: password,
      );
      return user.toEntity();
    });
  }

  @override
  Future<Result<UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) {
    return _guard(() async {
      final user = await _remoteDatasource.signUp(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
      );
      return user.toEntity();
    });
  }

  @override
  Future<Result<UserEntity>> signInWithGoogle() {
    return _guard(() async {
      final user = await _remoteDatasource.signInWithGoogle();
      return user.toEntity();
    });
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) {
    return _guard(() => _remoteDatasource.sendPasswordResetEmail(email));
  }

  @override
  Future<Result<void>> verifyEmail() {
    return _guard(_remoteDatasource.verifyEmail);
  }

  @override
  Future<Result<bool>> isCurrentUserEmailVerified() {
    return _guard(_remoteDatasource.isCurrentUserEmailVerified);
  }

  @override
  Future<Result<void>> signOut() {
    return _guard(_remoteDatasource.signOut);
  }

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Result<T>.success(await action());
    } on AuthException catch (exception) {
      return Result<T>.failure(exception.toFailure());
    } catch (exception, stackTrace) {
      return Result<T>.failure(
        AuthFailure(
          errorCode: AuthErrorCode.unknown,
          debugMessage: exception.toString(),
          cause: exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
