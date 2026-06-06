import 'package:bloc_test/bloc_test.dart';
import 'package:teka_luxe/l10n/generated/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teka_luxe/core/errors/auth_error_code.dart';
import 'package:teka_luxe/core/errors/failures.dart';
import 'package:teka_luxe/core/utils/result.dart';
import 'package:teka_luxe/features/auth/domain/usecases/forgot_password.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/forgot_password/forgot_password_state.dart';

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class FakeAppLocalizations extends AppLocalizationsEn {
  FakeAppLocalizations() : super();
}

void main() {
  late MockResetPasswordUseCase mockResetPassword;
  late FakeAppLocalizations l10n;

  setUpAll(() {
    registerFallbackValue(const ResetPasswordParams(email: ''));
  });

  setUp(() {
    mockResetPassword = MockResetPasswordUseCase();
    l10n = FakeAppLocalizations();
  });

  ForgotPasswordCubit buildCubit() =>
      ForgotPasswordCubit(mockResetPassword);

  group('ForgotPasswordCubit', () {
    test('initial state is correct', () {
      expect(buildCubit().state, const ForgotPasswordState());
    });

    group('emailChanged', () {
      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'should update email and validate',
        build: buildCubit,
        act: (cubit) => cubit.emailChanged('test@example.com', l10n),
        expect: () => [
          const ForgotPasswordState(email: 'test@example.com'),
        ],
      );

      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'should validate email format',
        build: buildCubit,
        act: (cubit) => cubit.emailChanged('invalid', l10n),
        expect: () => [
          const ForgotPasswordState(
            email: 'invalid',
            emailError: 'Enter a valid email address.',
          ),
        ],
      );

      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'should clear previous error/success on change',
        build: buildCubit,
        seed: () => const ForgotPasswordState(
          email: 'old@example.com',
          errorMessage: 'Previous error',
          successMessage: 'Previous success',
        ),
        act: (cubit) => cubit.emailChanged('new@example.com', l10n),
        expect: () => [
          const ForgotPasswordState(
            email: 'new@example.com',
            errorMessage: null,
            successMessage: null,
          ),
        ],
      );
    });

    group('submit', () {
      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'should emit success on valid email',
        setUp: () {
          when(() => mockResetPassword(any()))
              .thenAnswer((_) async => const Result.success(null));
        },
        build: buildCubit,
        seed: () => const ForgotPasswordState(email: 'test@example.com'),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [
          const ForgotPasswordState(
            email: 'test@example.com',
            isSubmitting: true,
          ),
          const ForgotPasswordState(
            email: 'test@example.com',
            isSubmitting: false,
            successMessage: 'Password reset email sent.',
          ),
        ],
      );

      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'should emit failure on error',
        setUp: () {
          when(() => mockResetPassword(any())).thenAnswer(
            (_) async => const Result.failure(
              AuthFailure(errorCode: AuthErrorCode.userNotFound),
            ),
          );
        },
        build: buildCubit,
        seed: () => const ForgotPasswordState(email: 'unknown@example.com'),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [
          const ForgotPasswordState(
            email: 'unknown@example.com',
            isSubmitting: true,
          ),
          isA<ForgotPasswordState>().having(
            (s) => s.isSubmitting,
            'isSubmitting',
            false,
          ),
        ],
      );

      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'should validate email and not submit when invalid',
        build: buildCubit,
        seed: () => const ForgotPasswordState(email: ''),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [
          const ForgotPasswordState(
            email: '',
            emailError: 'Enter your email address.',
          ),
        ],
        verify: (_) {
          verifyNever(() => mockResetPassword(any()));
        },
      );

      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'should not submit when already submitting',
        build: buildCubit,
        seed: () => const ForgotPasswordState(
          email: 'test@example.com',
          isSubmitting: true,
        ),
        act: (cubit) => cubit.submit(l10n),
        expect: () => [],
      );
    });
  });
}
