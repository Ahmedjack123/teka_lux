import 'package:bloc_test/bloc_test.dart';
import 'package:teka_luxe/l10n/generated/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teka_luxe/core/errors/auth_error_code.dart';
import 'package:teka_luxe/core/errors/failures.dart';
import 'package:teka_luxe/core/usecases/usecase.dart';
import 'package:teka_luxe/core/utils/result.dart';
import 'package:teka_luxe/features/auth/domain/entities/user.dart';
import 'package:teka_luxe/features/auth/domain/usecases/register.dart';
import 'package:teka_luxe/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/register/register_cubit.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/register/register_state.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockSignInWithGoogleUseCase extends Mock
    implements SignInWithGoogleUseCase {}

class FakeAppLocalizations extends AppLocalizationsEn {
  FakeAppLocalizations() : super();
}

void main() {
  late MockRegisterUseCase mockRegister;
  late MockSignInWithGoogleUseCase mockGoogleSignIn;
  late FakeAppLocalizations l10n;

  const testUser = UserEntity(
    uid: 'uid-123',
    email: 'test@example.com',
    name: 'Test User',
    emailVerified: true,
  );

  setUpAll(() {
    registerFallbackValue(
      const RegisterParams(
        email: '',
        password: '',
        name: '',
        phoneNumber: '',
      ),
    );
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockRegister = MockRegisterUseCase();
    mockGoogleSignIn = MockSignInWithGoogleUseCase();
    l10n = FakeAppLocalizations();
  });

  RegisterCubit buildCubit() => RegisterCubit(
        register: mockRegister,
        signInWithGoogle: mockGoogleSignIn,
      );

  group('RegisterCubit', () {
    test('initial state is correct', () {
      expect(buildCubit().state, const RegisterState());
    });

    group('field changes', () {
      blocTest<RegisterCubit, RegisterState>(
        'nameChanged should update name',
        build: buildCubit,
        act: (cubit) => cubit.nameChanged('John Doe', l10n),
        expect: () => [
          const RegisterState(name: 'John Doe'),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'phoneNumberChanged should update phone',
        build: buildCubit,
        act: (cubit) => cubit.phoneNumberChanged('0912345678', l10n),
        expect: () => [
          const RegisterState(phoneNumber: '0912345678'),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emailChanged should update email',
        build: buildCubit,
        act: (cubit) => cubit.emailChanged('test@example.com', l10n),
        expect: () => [
          const RegisterState(email: 'test@example.com'),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'passwordChanged should update password and re-validate confirm',
        build: buildCubit,
        seed: () => const RegisterState(
          hasSubmitted: true,
          confirmPassword: 'password123',
        ),
        act: (cubit) => cubit.passwordChanged('different', l10n),
        expect: () => [
          const RegisterState(
            password: 'different',
            confirmPassword: 'password123',
            confirmPasswordError: 'Passwords do not match.',
            hasSubmitted: true,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'confirmPasswordChanged should validate match',
        build: buildCubit,
        seed: () => const RegisterState(
          hasSubmitted: true,
          password: 'password123',
        ),
        act: (cubit) =>
            cubit.confirmPasswordChanged('wrong', l10n),
        expect: () => [
          const RegisterState(
            confirmPassword: 'wrong',
            confirmPasswordError: 'Passwords do not match.',
            password: 'password123',
            hasSubmitted: true,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'termsChanged should update acceptedTerms',
        build: buildCubit,
        act: (cubit) => cubit.termsChanged(true, l10n),
        expect: () => [
          const RegisterState(acceptedTerms: true),
        ],
      );
    });

    group('submit', () {
      blocTest<RegisterCubit, RegisterState>(
        'should emit success on valid registration',
        setUp: () {
          when(() => mockRegister(any()))
              .thenAnswer((_) async => const Result.success(testUser));
        },
        build: buildCubit,
        seed: () => const RegisterState(
          name: 'John Doe',
          phoneNumber: '0912345678',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          acceptedTerms: true,
        ),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [
          const RegisterState(
            name: 'John Doe',
            phoneNumber: '0912345678',
            email: 'test@example.com',
            password: 'password123',
            confirmPassword: 'password123',
            acceptedTerms: true,
            hasSubmitted: true,
          ),
          const RegisterState(
            name: 'John Doe',
            phoneNumber: '0912345678',
            email: 'test@example.com',
            password: 'password123',
            confirmPassword: 'password123',
            acceptedTerms: true,
            hasSubmitted: true,
            isSubmitting: true,
          ),
          const RegisterState(
            name: 'John Doe',
            phoneNumber: '0912345678',
            email: 'test@example.com',
            password: 'password123',
            confirmPassword: 'password123',
            acceptedTerms: true,
            hasSubmitted: true,
            isSubmitting: false,
            errorMessage: null,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'should emit failure on registration error',
        setUp: () {
          when(() => mockRegister(any())).thenAnswer(
            (_) async => const Result.failure(
              AuthFailure(errorCode: AuthErrorCode.emailAlreadyInUse),
            ),
          );
        },
        build: buildCubit,
        seed: () => const RegisterState(
          name: 'John Doe',
          phoneNumber: '0912345678',
          email: 'exists@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          acceptedTerms: true,
        ),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [
          const RegisterState(
            name: 'John Doe',
            phoneNumber: '0912345678',
            email: 'exists@example.com',
            password: 'password123',
            confirmPassword: 'password123',
            acceptedTerms: true,
            hasSubmitted: true,
          ),
          const RegisterState(
            name: 'John Doe',
            phoneNumber: '0912345678',
            email: 'exists@example.com',
            password: 'password123',
            confirmPassword: 'password123',
            acceptedTerms: true,
            hasSubmitted: true,
            isSubmitting: true,
          ),
          isA<RegisterState>().having(
            (s) => s.isSubmitting,
            'isSubmitting',
            false,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'should validate all fields and not submit when invalid',
        build: buildCubit,
        seed: () => const RegisterState(
          name: '',
          phoneNumber: '',
          email: '',
          password: '',
          confirmPassword: '',
          acceptedTerms: false,
        ),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [
          const RegisterState(
            name: '',
            phoneNumber: '',
            email: '',
            password: '',
            confirmPassword: '',
            acceptedTerms: false,
            nameError: 'Enter your full name.',
            phoneNumberError: 'Enter your phone number.',
            emailError: 'Enter your email address.',
            passwordError: 'Enter your password.',
            confirmPasswordError: 'Confirm your password.',
            termsError: 'Agree to the terms and privacy policy to continue.',
            hasSubmitted: true,
          ),
        ],
        verify: (_) {
          verifyNever(() => mockRegister(any()));
        },
      );

      blocTest<RegisterCubit, RegisterState>(
        'should not submit when already busy',
        build: buildCubit,
        seed: () => const RegisterState(isSubmitting: true),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [],
      );
    });

    group('signInWithGoogle', () {
      blocTest<RegisterCubit, RegisterState>(
        'should emit success on Google sign-in',
        setUp: () {
          when(() => mockGoogleSignIn(any()))
              .thenAnswer((_) async => const Result.success(testUser));
        },
        build: buildCubit,
        act: (cubit) => cubit.signInWithGoogle(l10n),
        expect: () => [
          const RegisterState(isGoogleSubmitting: true),
          const RegisterState(
            isGoogleSubmitting: false,
            errorMessage: null,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'should not submit when already busy',
        build: buildCubit,
        seed: () => const RegisterState(isSubmitting: true),
        act: (cubit) => cubit.signInWithGoogle(l10n),
        expect: () => [],
      );
    });
  });
}
