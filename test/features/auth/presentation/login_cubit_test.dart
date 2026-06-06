import 'package:bloc_test/bloc_test.dart';
import 'package:teka_luxe/l10n/generated/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teka_luxe/core/constants/storage_keys.dart';
import 'package:teka_luxe/core/errors/auth_error_code.dart';
import 'package:teka_luxe/core/errors/failures.dart';
import 'package:teka_luxe/core/usecases/usecase.dart';
import 'package:teka_luxe/core/utils/result.dart';
import 'package:teka_luxe/features/auth/domain/entities/user.dart';
import 'package:teka_luxe/features/auth/domain/usecases/login.dart';
import 'package:teka_luxe/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/login/login_state.dart';
import 'package:teka_luxe/shared/services/local_storage_service.dart';

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSignInWithGoogleUseCase extends Mock
    implements SignInWithGoogleUseCase {}

class FakeAppLocalizations extends AppLocalizationsEn {
  FakeAppLocalizations() : super();
}

void main() {
  late MockLocalStorageService mockLocalStorage;
  late MockLoginUseCase mockLogin;
  late MockSignInWithGoogleUseCase mockGoogleSignIn;
  late FakeAppLocalizations l10n;

  const testUser = UserEntity(
    uid: 'uid-123',
    email: 'test@example.com',
    name: 'Test',
    emailVerified: true,
  );

  setUpAll(() {
    registerFallbackValue(
      const LoginParams(email: '', password: ''),
    );
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockLocalStorage = MockLocalStorageService();
    mockLogin = MockLoginUseCase();
    mockGoogleSignIn = MockSignInWithGoogleUseCase();
    l10n = FakeAppLocalizations();
  });

  LoginCubit buildCubit() => LoginCubit(
        localStorage: mockLocalStorage,
        login: mockLogin,
        signInWithGoogle: mockGoogleSignIn,
      );

  group('LoginCubit', () {
    test('initial state is correct', () {
      expect(buildCubit().state, const LoginState());
    });

    group('loadRememberedEmail', () {
      blocTest<LoginCubit, LoginState>(
        'should load remembered email from local storage',
        setUp: () {
          when(() => mockLocalStorage.getString(StorageKeys.rememberedEmail))
              .thenReturn('remembered@example.com');
        },
        build: buildCubit,
        act: (cubit) => cubit.loadRememberedEmail(),
        expect: () => [
          const LoginState(
            email: 'remembered@example.com',
            rememberMe: true,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'should not emit when no remembered email',
        setUp: () {
          when(() => mockLocalStorage.getString(StorageKeys.rememberedEmail))
              .thenReturn('');
        },
        build: buildCubit,
        act: (cubit) => cubit.loadRememberedEmail(),
        expect: () => [],
      );

      blocTest<LoginCubit, LoginState>(
        'should not emit when email already set',
        setUp: () {
          when(() => mockLocalStorage.getString(StorageKeys.rememberedEmail))
              .thenReturn('test@example.com');
        },
        build: buildCubit,
        seed: () => const LoginState(email: 'already@set.com'),
        act: (cubit) => cubit.loadRememberedEmail(),
        expect: () => [],
      );
    });

    group('emailChanged', () {
      blocTest<LoginCubit, LoginState>(
        'should update email and clear errors',
        build: buildCubit,
        act: (cubit) => cubit.emailChanged('test@example.com', l10n),
        expect: () => [
          const LoginState(email: 'test@example.com'),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'should validate email when hasSubmitted is true',
        build: buildCubit,
        seed: () => const LoginState(hasSubmitted: true),
        act: (cubit) => cubit.emailChanged('invalid', l10n),
        expect: () => [
          const LoginState(
            email: 'invalid',
            emailError: 'Enter a valid email address.',
            hasSubmitted: true,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'should clear requiresEmailVerification flag',
        build: buildCubit,
        seed: () => const LoginState(requiresEmailVerification: true),
        act: (cubit) => cubit.emailChanged('test@example.com', l10n),
        expect: () => [
          const LoginState(
            email: 'test@example.com',
            requiresEmailVerification: false,
          ),
        ],
      );
    });

    group('passwordChanged', () {
      blocTest<LoginCubit, LoginState>(
        'should update password and clear errors',
        build: buildCubit,
        act: (cubit) => cubit.passwordChanged('password123', l10n),
        expect: () => [
          const LoginState(password: 'password123'),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'should validate password when hasSubmitted is true',
        build: buildCubit,
        seed: () => const LoginState(hasSubmitted: true),
        act: (cubit) => cubit.passwordChanged('123', l10n),
        expect: () => [
          const LoginState(
            password: '123',
            passwordError: 'Use at least 6 characters.',
            hasSubmitted: true,
          ),
        ],
      );
    });

    group('rememberChanged', () {
      blocTest<LoginCubit, LoginState>(
        'should toggle rememberMe',
        build: buildCubit,
        act: (cubit) => cubit.rememberChanged(true),
        expect: () => [
          const LoginState(rememberMe: true),
        ],
      );
    });

    group('submit', () {
      blocTest<LoginCubit, LoginState>(
        'should emit success and persist email when rememberMe is true',
        setUp: () {
          when(() => mockLogin(any())).thenAnswer(
            (_) async => const Result.success(testUser),
          );
          when(() => mockLocalStorage.setString(any(), any()))
              .thenAnswer((_) async {});
        },
        build: buildCubit,
        seed: () => const LoginState(
          email: 'test@example.com',
          password: 'password123',
          rememberMe: true,
        ),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [
          const LoginState(
            email: 'test@example.com',
            password: 'password123',
            rememberMe: true,
            hasSubmitted: true,
          ),
          const LoginState(
            email: 'test@example.com',
            password: 'password123',
            rememberMe: true,
            hasSubmitted: true,
            isSubmitting: true,
          ),
          const LoginState(
            email: 'test@example.com',
            password: 'password123',
            rememberMe: true,
            hasSubmitted: true,
            isSubmitting: false,
            errorMessage: null,
          ),
        ],
        verify: (_) {
          verify(() => mockLocalStorage.setString(
                StorageKeys.rememberedEmail,
                'test@example.com',
              )).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'should remove remembered email when rememberMe is false',
        setUp: () {
          when(() => mockLogin(any())).thenAnswer(
            (_) async => const Result.success(testUser),
          );
          when(() => mockLocalStorage.remove(any()))
              .thenAnswer((_) async {});
        },
        build: buildCubit,
        seed: () => const LoginState(
          email: 'test@example.com',
          password: 'password123',
          rememberMe: false,
        ),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [
          const LoginState(
            email: 'test@example.com',
            password: 'password123',
            rememberMe: false,
            hasSubmitted: true,
          ),
          const LoginState(
            email: 'test@example.com',
            password: 'password123',
            rememberMe: false,
            hasSubmitted: true,
            isSubmitting: true,
          ),
          const LoginState(
            email: 'test@example.com',
            password: 'password123',
            rememberMe: false,
            hasSubmitted: true,
            isSubmitting: false,
            errorMessage: null,
          ),
        ],
        verify: (_) {
          verify(() => mockLocalStorage.remove(StorageKeys.rememberedEmail))
              .called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'should emit failure on invalid credentials',
        setUp: () {
          when(() => mockLogin(any())).thenAnswer(
            (_) async => const Result.failure(
              AuthFailure(errorCode: AuthErrorCode.invalidCredential),
            ),
          );
        },
        build: buildCubit,
        seed: () => const LoginState(
          email: 'test@example.com',
          password: 'wrongpass',
        ),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [
          const LoginState(
            email: 'test@example.com',
            password: 'wrongpass',
            hasSubmitted: true,
          ),
          const LoginState(
            email: 'test@example.com',
            password: 'wrongpass',
            hasSubmitted: true,
            isSubmitting: true,
          ),
          isA<LoginState>().having(
            (s) => s.isSubmitting,
            'isSubmitting',
            false,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'should set requiresEmailVerification when user email not verified',
        setUp: () {
          when(() => mockLogin(any())).thenAnswer(
            (_) async => const Result.success(
              UserEntity(
                uid: 'uid',
                email: 'test@example.com',
                name: 'Test',
                emailVerified: false,
              ),
            ),
          );
          when(() => mockLocalStorage.setString(any(), any()))
              .thenAnswer((_) async {});
        },
        build: buildCubit,
        seed: () => const LoginState(
          email: 'test@example.com',
          password: 'password123',
          rememberMe: true,
        ),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [
          const LoginState(
            email: 'test@example.com',
            password: 'password123',
            rememberMe: true,
            hasSubmitted: true,
          ),
          const LoginState(
            email: 'test@example.com',
            password: 'password123',
            rememberMe: true,
            hasSubmitted: true,
            isSubmitting: true,
          ),
          const LoginState(
            email: 'test@example.com',
            password: 'password123',
            rememberMe: true,
            hasSubmitted: true,
            isSubmitting: false,
            errorMessage: null,
            requiresEmailVerification: true,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'should not submit when validation fails',
        build: buildCubit,
        seed: () => const LoginState(email: '', password: ''),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [
          const LoginState(
            email: '',
            password: '',
            emailError: 'Enter your email address.',
            passwordError: 'Enter your password.',
            hasSubmitted: true,
          ),
        ],
        verify: (_) {
          verifyNever(() => mockLogin(any()));
        },
      );

      blocTest<LoginCubit, LoginState>(
        'should not submit when already busy',
        build: buildCubit,
        seed: () => const LoginState(
          email: 'test@example.com',
          password: 'password123',
          isSubmitting: true,
        ),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockLogin(any()));
        },
      );
    });

    group('signInWithGoogle', () {
      blocTest<LoginCubit, LoginState>(
        'should emit success on Google sign-in',
        setUp: () {
          when(() => mockGoogleSignIn(any()))
              .thenAnswer((_) async => const Result.success(testUser));
        },
        build: buildCubit,
        act: (cubit) => cubit.signInWithGoogle(l10n),
        expect: () => [
          const LoginState(isGoogleSubmitting: true),
          const LoginState(
            isGoogleSubmitting: false,
            errorMessage: null,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'should emit failure on Google sign-in error',
        setUp: () {
          when(() => mockGoogleSignIn(any())).thenAnswer(
            (_) async => const Result.failure(
              AuthFailure(errorCode: AuthErrorCode.networkRequestFailed),
            ),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.signInWithGoogle(l10n),
        expect: () => [
          const LoginState(isGoogleSubmitting: true),
          isA<LoginState>().having(
            (s) => s.isGoogleSubmitting,
            'isGoogleSubmitting',
            false,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'should not submit when already busy',
        build: buildCubit,
        seed: () => const LoginState(isSubmitting: true),
        act: (cubit) => cubit.signInWithGoogle(l10n),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockGoogleSignIn(any()));
        },
      );
    });
  });
}
