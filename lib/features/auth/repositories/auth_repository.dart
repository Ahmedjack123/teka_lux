import '../../../core/utils/result.dart';
import '../models/user_entity.dart';

abstract interface class AuthRepository {
  Stream<UserEntity?> authStateChanges();

  Future<Result<UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  });

  Future<Result<UserEntity>> signInWithGoogle();

  Future<Result<void>> sendPasswordResetEmail(String email);

  Future<Result<void>> verifyEmail();

  Future<Result<bool>> isCurrentUserEmailVerified();

  Future<Result<void>> signOut();

  Future<Result<UserEntity?>> getCurrentUser();
}
