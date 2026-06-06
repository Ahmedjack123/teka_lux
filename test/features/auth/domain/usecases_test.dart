import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teka_luxe/core/errors/auth_error_code.dart';
import 'package:teka_luxe/core/errors/failures.dart';
import 'package:teka_luxe/core/usecases/usecase.dart';
import 'package:teka_luxe/core/utils/result.dart';
import 'package:teka_luxe/features/auth/domain/entities/user.dart';
import 'package:teka_luxe/features/auth/domain/repositories/auth_repository.dart';
import 'package:teka_luxe/features/auth/domain/usecases/check_email_verified.dart';
import 'package:teka_luxe/features/auth/domain/usecases/forgot_password.dart';
import 'package:teka_luxe/features/auth/domain/usecases/get_current_user.dart';
import 'package:teka_luxe/features/auth/domain/usecases/login.dart';
import 'package:teka_luxe/features/auth/domain/usecases/logout.dart';
import 'package:teka_luxe/features/auth/domain/usecases/register.dart';
import 'package:teka_luxe/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:teka_luxe/features/auth/domain/usecases/verify_email.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late IAuthRepository mockRepository;

  const testUser = UserEntity(
    uid: 'uid-123',
    email: 'test@example.com',
    name: 'Test User',
    emailVerified: true,
  );

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('LoginUseCase', () {
    late LoginUseCase useCase;

    setUp(() {
      useCase = LoginUseCase(mockRepository);
    });

    test('should call repository.signInWithEmail with correct params', () async {
      when(() => mockRepository.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Result.success(testUser));

      final result = await useCase(
        const LoginParams(email: 'test@example.com', password: 'pass123'),
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals(testUser));
      verify(() => mockRepository.signInWithEmail(
            email: 'test@example.com',
            password: 'pass123',
          )).called(1);
    });

    test('should return failure when repository fails', () async {
      const failure = AuthFailure(errorCode: AuthErrorCode.invalidCredential);
      when(() => mockRepository.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Result.failure(failure));

      final result = await useCase(
        const LoginParams(email: 'test@example.com', password: 'wrong'),
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, equals(failure));
    });
  });

  group('RegisterUseCase', () {
    late RegisterUseCase useCase;

    setUp(() {
      useCase = RegisterUseCase(mockRepository);
    });

    test('should call repository.signUp with correct params', () async {
      when(() => mockRepository.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            name: any(named: 'name'),
            phoneNumber: any(named: 'phoneNumber'),
          )).thenAnswer((_) async => const Result.success(testUser));

      final result = await useCase(
        const RegisterParams(
          email: 'new@example.com',
          password: 'pass123',
          name: 'New User',
          phoneNumber: '0912345678',
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(() => mockRepository.signUp(
            email: 'new@example.com',
            password: 'pass123',
            name: 'New User',
            phoneNumber: '0912345678',
          )).called(1);
    });
  });

  group('SignInWithGoogleUseCase', () {
    late SignInWithGoogleUseCase useCase;

    setUp(() {
      useCase = SignInWithGoogleUseCase(mockRepository);
    });

    test('should call repository.signInWithGoogle', () async {
      when(() => mockRepository.signInWithGoogle())
          .thenAnswer((_) async => const Result.success(testUser));

      final result = await useCase(const NoParams());

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals(testUser));
      verify(() => mockRepository.signInWithGoogle()).called(1);
    });
  });

  group('ResetPasswordUseCase', () {
    late ResetPasswordUseCase useCase;

    setUp(() {
      useCase = ResetPasswordUseCase(mockRepository);
    });

    test('should call repository.sendPasswordResetEmail', () async {
      when(() => mockRepository.sendPasswordResetEmail(any()))
          .thenAnswer((_) async => const Result.success(null));

      final result = await useCase(
        const ResetPasswordParams(email: 'test@example.com'),
      );

      expect(result.isSuccess, isTrue);
      verify(() => mockRepository.sendPasswordResetEmail('test@example.com'))
          .called(1);
    });
  });

  group('VerifyEmailUseCase', () {
    late VerifyEmailUseCase useCase;

    setUp(() {
      useCase = VerifyEmailUseCase(mockRepository);
    });

    test('should call repository.verifyEmail', () async {
      when(() => mockRepository.verifyEmail())
          .thenAnswer((_) async => const Result.success(null));

      final result = await useCase(const NoParams());

      expect(result.isSuccess, isTrue);
      verify(() => mockRepository.verifyEmail()).called(1);
    });
  });

  group('CheckEmailVerifiedUseCase', () {
    late CheckEmailVerifiedUseCase useCase;

    setUp(() {
      useCase = CheckEmailVerifiedUseCase(mockRepository);
    });

    test('should return true when email is verified', () async {
      when(() => mockRepository.isCurrentUserEmailVerified())
          .thenAnswer((_) async => const Result.success(true));

      final result = await useCase(const NoParams());

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, isTrue);
    });
  });

  group('SignOutUseCase', () {
    late SignOutUseCase useCase;

    setUp(() {
      useCase = SignOutUseCase(mockRepository);
    });

    test('should call repository.signOut', () async {
      when(() => mockRepository.signOut())
          .thenAnswer((_) async => const Result.success(null));

      final result = await useCase(const NoParams());

      expect(result.isSuccess, isTrue);
      verify(() => mockRepository.signOut()).called(1);
    });
  });

  group('GetCurrentUserUseCase', () {
    late GetCurrentUserUseCase useCase;

    setUp(() {
      useCase = GetCurrentUserUseCase(mockRepository);
    });

    test('should return current user', () async {
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Result.success(testUser));

      final result = await useCase(const NoParams());

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals(testUser));
    });

    test('should return null when no user', () async {
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Result.success(null));

      final result = await useCase(const NoParams());

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, isNull);
    });
  });
}
