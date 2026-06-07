import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teka_luxe/core/errors/auth_error_code.dart';
import 'package:teka_luxe/core/errors/exceptions.dart';
import 'package:teka_luxe/core/errors/failures.dart';
import 'package:teka_luxe/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:teka_luxe/features/auth/data/models/user_model.dart';
import 'package:teka_luxe/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:teka_luxe/features/auth/domain/entities/user.dart';
import 'package:teka_luxe/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  late AuthRemoteDatasource mockDatasource;
  late IAuthRepository repository;

  const testUserModel = UserModel(
    uid: 'test-uid-123',
    email: 'test@example.com',
    name: 'Test User',
    emailVerified: true,
    phoneNumber: '0912345678',
    photoUrl: 'https://example.com/photo.jpg',
  );

  const testUserEntity = UserEntity(
    uid: 'test-uid-123',
    email: 'test@example.com',
    name: 'Test User',
    emailVerified: true,
    phoneNumber: '0912345678',
    photoUrl: 'https://example.com/photo.jpg',
  );

  setUp(() {
    mockDatasource = MockAuthRemoteDatasource();
    repository = AuthRepositoryImpl(mockDatasource);
  });

  group('AuthRepositoryImpl', () {
    group('signInWithEmail', () {
      test('should return Success with UserEntity on successful login',
          () async {
        when(() => mockDatasource.signInWithEmail(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => testUserModel);

        final result = await repository.signInWithEmail(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, equals(testUserEntity));
        verify(() => mockDatasource.signInWithEmail(
              email: 'test@example.com',
              password: 'password123',
            )).called(1);
      });

      test('should return Failure on AuthException', () async {
        when(() => mockDatasource.signInWithEmail(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(
          const AuthException(errorCode: AuthErrorCode.invalidCredential),
        );

        final result = await repository.signInWithEmail(
          email: 'test@example.com',
          password: 'wrong',
        );

        expect(result.isFailure, isTrue);
        expect(
          result.failureOrNull,
          isA<AuthFailure>().having(
            (f) => f.errorCode,
            'errorCode',
            AuthErrorCode.invalidCredential,
          ),
        );
      });

      test('should return Failure with unknown on unexpected error', () async {
        when(() => mockDatasource.signInWithEmail(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('network error'));

        final result = await repository.signInWithEmail(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result.isFailure, isTrue);
        expect(
          result.failureOrNull,
          isA<AuthFailure>().having(
            (f) => f.errorCode,
            'errorCode',
            AuthErrorCode.unknown,
          ),
        );
      });
    });

    group('signUp', () {
      test('should return Success with UserEntity on successful registration',
          () async {
        when(() => mockDatasource.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
              phoneNumber: any(named: 'phoneNumber'),
            )).thenAnswer((_) async => testUserModel);

        final result = await repository.signUp(
          email: 'new@example.com',
          password: 'password123',
          name: 'New User',
          phoneNumber: '0912345678',
        );

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, equals(testUserEntity));
      });

      test('should return Failure on email-already-in-use', () async {
        when(() => mockDatasource.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
              phoneNumber: any(named: 'phoneNumber'),
            )).thenThrow(
          const AuthException(errorCode: AuthErrorCode.emailAlreadyInUse),
        );

        final result = await repository.signUp(
          email: 'exists@example.com',
          password: 'password123',
          name: 'User',
          phoneNumber: '0912345678',
        );

        expect(result.isFailure, isTrue);
        expect(
          (result.failureOrNull as AuthFailure).errorCode,
          AuthErrorCode.emailAlreadyInUse,
        );
      });
    });

    group('signInWithGoogle', () {
      test('should return Success on Google sign-in', () async {
        when(() => mockDatasource.signInWithGoogle())
            .thenAnswer((_) async => testUserModel);

        final result = await repository.signInWithGoogle();

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, equals(testUserEntity));
      });

      test('should return Failure on Google sign-in error', () async {
        when(() => mockDatasource.signInWithGoogle()).thenThrow(
          const AuthException(
              errorCode: AuthErrorCode.accountExistsWithDifferentCredential),
        );

        final result = await repository.signInWithGoogle();

        expect(result.isFailure, isTrue);
        expect(
          (result.failureOrNull as AuthFailure).errorCode,
          AuthErrorCode.accountExistsWithDifferentCredential,
        );
      });
    });

    group('sendPasswordResetEmail', () {
      test('should return Success on valid email', () async {
        when(() => mockDatasource.sendPasswordResetEmail(any()))
            .thenAnswer((_) async {});

        final result =
            await repository.sendPasswordResetEmail('test@example.com');

        expect(result.isSuccess, isTrue);
        verify(() => mockDatasource.sendPasswordResetEmail('test@example.com'))
            .called(1);
      });

      test('should return Failure on user-not-found', () async {
        when(() => mockDatasource.sendPasswordResetEmail(any())).thenThrow(
          const AuthException(errorCode: AuthErrorCode.userNotFound),
        );

        final result =
            await repository.sendPasswordResetEmail('unknown@example.com');

        expect(result.isFailure, isTrue);
        expect(
          (result.failureOrNull as AuthFailure).errorCode,
          AuthErrorCode.userNotFound,
        );
      });
    });

    group('signOut', () {
      test('should return Success on sign out', () async {
        when(() => mockDatasource.signOut()).thenAnswer((_) async {});

        final result = await repository.signOut();

        expect(result.isSuccess, isTrue);
      });

      test('should return Failure on sign out error', () async {
        when(() => mockDatasource.signOut())
            .thenThrow(Exception('sign out failed'));

        final result = await repository.signOut();

        expect(result.isFailure, isTrue);
      });
    });

    group('getCurrentUser', () {
      test('should return Success with user when authenticated', () async {
        when(() => mockDatasource.getCurrentUser())
            .thenAnswer((_) async => testUserModel);

        final result = await repository.getCurrentUser();

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, equals(testUserEntity));
      });

      test('should return Success with null when not authenticated', () async {
        when(() => mockDatasource.getCurrentUser())
            .thenAnswer((_) async => null);

        final result = await repository.getCurrentUser();

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, isNull);
      });
    });

    group('isCurrentUserEmailVerified', () {
      test('should return Success with true when verified', () async {
        when(() => mockDatasource.isCurrentUserEmailVerified())
            .thenAnswer((_) async => true);

        final result = await repository.isCurrentUserEmailVerified();

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, isTrue);
      });

      test('should return Success with false when not verified', () async {
        when(() => mockDatasource.isCurrentUserEmailVerified())
            .thenAnswer((_) async => false);

        final result = await repository.isCurrentUserEmailVerified();

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, isFalse);
      });
    });

    group('authStateChanges', () {
      test('should map UserModel stream to UserEntity stream', () {
        when(() => mockDatasource.authStateChanges())
            .thenAnswer((_) => Stream.value(testUserModel));

        final stream = repository.authStateChanges();

        expect(stream, emits(testUserEntity));
      });

      test('should emit null when user is null', () {
        when(() => mockDatasource.authStateChanges())
            .thenAnswer((_) => Stream.value(null));

        final stream = repository.authStateChanges();

        expect(stream, emits(null));
      });
    });
  });
}
