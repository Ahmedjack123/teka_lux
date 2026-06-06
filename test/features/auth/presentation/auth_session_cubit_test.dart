import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teka_luxe/core/errors/failures.dart';
import 'package:teka_luxe/core/errors/auth_error_code.dart';
import 'package:teka_luxe/core/usecases/usecase.dart';
import 'package:teka_luxe/core/utils/result.dart';
import 'package:teka_luxe/features/auth/domain/entities/user.dart';
import 'package:teka_luxe/features/auth/domain/repositories/auth_repository.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/auth_session_cubit.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  const testUser = UserEntity(
    uid: 'uid-123',
    email: 'test@example.com',
    name: 'Test User',
    emailVerified: true,
  );

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  AuthSessionCubit buildCubit() => AuthSessionCubit(mockRepository);

  group('AuthSessionCubit', () {
    test('initial state is unknown', () {
      expect(
        buildCubit().state,
        const AuthSessionState.unknown(),
      );
    });

    group('start', () {
      blocTest<AuthSessionCubit, AuthSessionState>(
        'should emit authenticated when user is present',
        setUp: () {
          when(() => mockRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(testUser));
        },
        build: buildCubit,
        act: (cubit) => cubit.start(),
        expect: () => [
          const AuthSessionState.authenticated(testUser),
        ],
      );

      blocTest<AuthSessionCubit, AuthSessionState>(
        'should emit unauthenticated when user is null',
        setUp: () {
          when(() => mockRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(null));
        },
        build: buildCubit,
        act: (cubit) => cubit.start(),
        expect: () => [
          const AuthSessionState.unauthenticated(),
        ],
      );

      blocTest<AuthSessionCubit, AuthSessionState>(
        'should emit unauthenticated then authenticated on user change',
        setUp: () {
          when(() => mockRepository.authStateChanges())
              .thenAnswer((_) => Stream.fromIterable([null, testUser]));
        },
        build: buildCubit,
        act: (cubit) => cubit.start(),
        expect: () => [
          const AuthSessionState.unauthenticated(),
          const AuthSessionState.authenticated(testUser),
        ],
      );

      blocTest<AuthSessionCubit, AuthSessionState>(
        'should emit authenticated then unauthenticated on sign out',
        setUp: () {
          when(() => mockRepository.authStateChanges())
              .thenAnswer((_) => Stream.fromIterable([testUser, null]));
        },
        build: buildCubit,
        act: (cubit) => cubit.start(),
        expect: () => [
          const AuthSessionState.authenticated(testUser),
          const AuthSessionState.unauthenticated(),
        ],
      );
    });

    group('refresh', () {
      blocTest<AuthSessionCubit, AuthSessionState>(
        'should emit authenticated when getCurrentUser returns user',
        setUp: () {
          when(() => mockRepository.getCurrentUser())
              .thenAnswer((_) async => const Result.success(testUser));
        },
        build: buildCubit,
        act: (cubit) => cubit.refresh(),
        expect: () => [
          const AuthSessionState.authenticated(testUser),
        ],
      );

      blocTest<AuthSessionCubit, AuthSessionState>(
        'should emit unauthenticated when getCurrentUser returns null',
        setUp: () {
          when(() => mockRepository.getCurrentUser())
              .thenAnswer((_) async => const Result.success(null));
        },
        build: buildCubit,
        act: (cubit) => cubit.refresh(),
        expect: () => [
          const AuthSessionState.unauthenticated(),
        ],
      );

      blocTest<AuthSessionCubit, AuthSessionState>(
        'should emit unauthenticated when getCurrentUser fails',
        setUp: () {
          when(() => mockRepository.getCurrentUser()).thenAnswer(
            (_) async => const Result.failure(
              AuthFailure(errorCode: AuthErrorCode.unknown),
            ),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.refresh(),
        expect: () => [
          const AuthSessionState.unauthenticated(),
        ],
      );
    });

    group('state getters', () {
      test('isKnown returns false for unknown state', () {
        const state = AuthSessionState.unknown();
        expect(state.isKnown, isFalse);
        expect(state.isAuthenticated, isFalse);
        expect(state.isEmailVerified, isFalse);
      });

      test('isKnown returns true for authenticated state', () {
        const state = AuthSessionState.authenticated(testUser);
        expect(state.isKnown, isTrue);
        expect(state.isAuthenticated, isTrue);
        expect(state.isEmailVerified, isTrue);
      });

      test('isKnown returns true for unauthenticated state', () {
        const state = AuthSessionState.unauthenticated();
        expect(state.isKnown, isTrue);
        expect(state.isAuthenticated, isFalse);
        expect(state.isEmailVerified, isFalse);
      });

      test('isEmailVerified returns false for unverified user', () {
        const unverifiedUser = UserEntity(
          uid: 'uid',
          email: 'test@example.com',
          name: 'Test',
          emailVerified: false,
        );
        const state = AuthSessionState.authenticated(unverifiedUser);
        expect(state.isEmailVerified, isFalse);
      });
    });
  });
}
