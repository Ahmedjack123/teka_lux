import 'package:bloc_test/bloc_test.dart';
import 'package:teka_luxe/l10n/generated/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teka_luxe/core/errors/auth_error_code.dart';
import 'package:teka_luxe/core/errors/failures.dart';
import 'package:teka_luxe/core/usecases/usecase.dart';
import 'package:teka_luxe/core/utils/result.dart';
import 'package:teka_luxe/features/auth/domain/usecases/check_email_verified.dart';
import 'package:teka_luxe/features/auth/domain/usecases/logout.dart';
import 'package:teka_luxe/features/auth/domain/usecases/verify_email.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/verify_email_cubit.dart';

class MockVerifyEmailUseCase extends Mock implements VerifyEmailUseCase {}

class MockCheckEmailVerifiedUseCase extends Mock
    implements CheckEmailVerifiedUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockAuthSessionCubit extends Mock implements AuthSessionCubit {}

class FakeAppLocalizations extends AppLocalizationsEn {
  FakeAppLocalizations() : super();
}

void main() {
  late MockVerifyEmailUseCase mockVerifyEmail;
  late MockCheckEmailVerifiedUseCase mockCheckVerified;
  late MockSignOutUseCase mockSignOut;
  late MockAuthSessionCubit mockAuthSessionCubit;
  late FakeAppLocalizations l10n;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockVerifyEmail = MockVerifyEmailUseCase();
    mockCheckVerified = MockCheckEmailVerifiedUseCase();
    mockSignOut = MockSignOutUseCase();
    mockAuthSessionCubit = MockAuthSessionCubit();
    l10n = FakeAppLocalizations();

    when(() => mockAuthSessionCubit.refresh())
        .thenAnswer((_) async {});
  });

  VerifyEmailCubit buildCubit() => VerifyEmailCubit(
        verifyEmail: mockVerifyEmail,
        checkEmailVerified: mockCheckVerified,
        signOut: mockSignOut,
        authSessionCubit: mockAuthSessionCubit,
      );

  group('VerifyEmailCubit', () {
    test('initial state is correct', () {
      final cubit = buildCubit();
      expect(cubit.state, const VerifyEmailState());
      cubit.close();
    });

    group('start', () {
      blocTest<VerifyEmailCubit, VerifyEmailState>(
        'should start cooldown when emailJustSent is true',
        setUp: () {
          when(() => mockCheckVerified(any()))
              .thenAnswer((_) async => const Result.success(false));
          when(() => mockVerifyEmail(any()))
              .thenAnswer((_) async => const Result.success(null));
        },
        build: buildCubit,
        act: (cubit) => cubit.start(
          emailJustSent: true,
          l10n: l10n,
        ),
        expect: () => [
          const VerifyEmailState(
            resendSecondsRemaining: VerifyEmailCubit.resendCooldownSeconds,
          ),
          const VerifyEmailState(
            isResending: true,
            resendSecondsRemaining: VerifyEmailCubit.resendCooldownSeconds,
          ),
          const VerifyEmailState(
            isChecking: true,
            isResending: true,
            resendSecondsRemaining: VerifyEmailCubit.resendCooldownSeconds,
          ),
          const VerifyEmailState(
            isChecking: true,
            isResending: false,
            message: 'Verification email sent.',
            resendSecondsRemaining: VerifyEmailCubit.resendCooldownSeconds,
          ),
          const VerifyEmailState(
            isChecking: false,
            isResending: false,
            message: 'Verification email sent.',
            resendSecondsRemaining: VerifyEmailCubit.resendCooldownSeconds,
          ),
        ],
      );

      blocTest<VerifyEmailCubit, VerifyEmailState>(
        'should check verification immediately when emailJustSent is false',
        setUp: () {
          when(() => mockCheckVerified(any()))
              .thenAnswer((_) async => const Result.success(false));
        },
        build: buildCubit,
        act: (cubit) => cubit.start(
          emailJustSent: false,
          l10n: l10n,
        ),
        expect: () => [
          const VerifyEmailState(isChecking: true),
          const VerifyEmailState(isChecking: false),
        ],
      );
    });

    group('checkVerification', () {
      blocTest<VerifyEmailCubit, VerifyEmailState>(
        'should emit isVerified when email is verified',
        setUp: () {
          when(() => mockCheckVerified(any()))
              .thenAnswer((_) async => const Result.success(true));
        },
        build: buildCubit,
        act: (cubit) => cubit.checkVerification(l10n),
        expect: () => [
          const VerifyEmailState(isChecking: true),
          const VerifyEmailState(
            isChecking: false,
            isVerified: true,
            resendSecondsRemaining: 0,
          ),
        ],
        verify: (_) {
          verify(() => mockAuthSessionCubit.refresh()).called(1);
        },
      );

      blocTest<VerifyEmailCubit, VerifyEmailState>(
        'should emit not verified when email is not verified',
        setUp: () {
          when(() => mockCheckVerified(any()))
              .thenAnswer((_) async => const Result.success(false));
        },
        build: buildCubit,
        act: (cubit) => cubit.checkVerification(l10n),
        expect: () => [
          const VerifyEmailState(isChecking: true),
          const VerifyEmailState(isChecking: false),
        ],
      );

      blocTest<VerifyEmailCubit, VerifyEmailState>(
        'should not check when already verified',
        build: buildCubit,
        seed: () => const VerifyEmailState(isVerified: true),
        act: (cubit) => cubit.checkVerification(l10n),
        expect: () => [],
      );

      blocTest<VerifyEmailCubit, VerifyEmailState>(
        'should not check when already checking',
        build: buildCubit,
        seed: () => const VerifyEmailState(isChecking: true),
        act: (cubit) => cubit.checkVerification(l10n),
        expect: () => [],
      );
    });

    group('resendEmail', () {
      blocTest<VerifyEmailCubit, VerifyEmailState>(
        'should emit success and start cooldown on resend',
        setUp: () {
          when(() => mockVerifyEmail(any()))
              .thenAnswer((_) async => const Result.success(null));
        },
        build: buildCubit,
        act: (cubit) => cubit.resendEmail(l10n),
        expect: () => [
          const VerifyEmailState(
            isResending: true,
            message: null,
            errorMessage: null,
          ),
          const VerifyEmailState(
            isResending: false,
            message: 'Verification email sent.',
            resendSecondsRemaining: VerifyEmailCubit.resendCooldownSeconds,
          ),
        ],
      );

      blocTest<VerifyEmailCubit, VerifyEmailState>(
        'should emit failure on resend error',
        setUp: () {
          when(() => mockVerifyEmail(any())).thenAnswer(
            (_) async => const Result.failure(
              AuthFailure(errorCode: AuthErrorCode.tooManyRequests),
            ),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.resendEmail(l10n),
        expect: () => [
          const VerifyEmailState(
            isResending: true,
            message: null,
            errorMessage: null,
          ),
          isA<VerifyEmailState>().having(
            (s) => s.isResending,
            'isResending',
            false,
          ),
        ],
      );

      blocTest<VerifyEmailCubit, VerifyEmailState>(
        'should not resend when cooldown is active',
        build: buildCubit,
        seed: () => const VerifyEmailState(resendSecondsRemaining: 30),
        act: (cubit) => cubit.resendEmail(l10n),
        expect: () => [],
      );

      blocTest<VerifyEmailCubit, VerifyEmailState>(
        'should not resend when already verified',
        build: buildCubit,
        seed: () => const VerifyEmailState(isVerified: true),
        act: (cubit) => cubit.resendEmail(l10n),
        expect: () => [],
      );
    });

    group('signOut', () {
      blocTest<VerifyEmailCubit, VerifyEmailState>(
        'should call signOut and refresh auth session',
        setUp: () {
          when(() => mockSignOut(any()))
              .thenAnswer((_) async => const Result.success(null));
        },
        build: buildCubit,
        act: (cubit) => cubit.signOut(),
        expect: () => [],
        verify: (_) {
          verify(() => mockSignOut(any())).called(1);
          verify(() => mockAuthSessionCubit.refresh()).called(1);
        },
      );
    });
  });
}
