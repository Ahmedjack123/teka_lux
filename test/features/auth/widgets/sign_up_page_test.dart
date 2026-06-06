import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/register/register_cubit.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/register/register_state.dart';
import 'package:teka_luxe/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:teka_luxe/l10n/generated/app_localizations.dart';

class MockRegisterCubit extends MockCubit<RegisterState>
    implements RegisterCubit {}

Future<void> pumpSignUpPage(WidgetTester tester, MockRegisterCubit cubit,
    {bool settle = true}) async {
  if (GetIt.I.isRegistered<RegisterCubit>()) {
    GetIt.I.unregister<RegisterCubit>();
  }
  GetIt.I.registerFactory<RegisterCubit>(() => cubit);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SignUpPage(),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

void main() {
  late MockRegisterCubit mockCubit;

  setUp(() {
    mockCubit = MockRegisterCubit();
    when(() => mockCubit.state).thenReturn(const RegisterState());
    when(() => mockCubit.stream).thenAnswer(
      (_) => Stream.value(const RegisterState()),
    );
  });

  tearDown(() {
    if (GetIt.I.isRegistered<RegisterCubit>()) {
      GetIt.I.unregister<RegisterCubit>();
    }
  });

  group('SignUpPage Widget Tests', () {
    testWidgets('should display all 5 text fields', (tester) async {
      await pumpSignUpPage(tester, mockCubit);

      expect(find.byType(TextField), findsNWidgets(5));
    });

    testWidgets('should show validation errors when hasSubmitted',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const RegisterState(
          hasSubmitted: true,
          nameError: 'Name required',
          emailError: 'Email required',
          passwordError: 'Password required',
        ),
      );
      when(() => mockCubit.stream).thenAnswer(
        (_) => Stream.value(
          const RegisterState(
            hasSubmitted: true,
            nameError: 'Name required',
            emailError: 'Email required',
            passwordError: 'Password required',
          ),
        ),
      );

      await pumpSignUpPage(tester, mockCubit);

      expect(find.text('Name required'), findsOneWidget);
      expect(find.text('Email required'), findsOneWidget);
      expect(find.text('Password required'), findsOneWidget);
    });

    testWidgets('should show loading state when submitting', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const RegisterState(isSubmitting: true),
      );
      when(() => mockCubit.stream).thenAnswer(
        (_) => Stream.value(const RegisterState(isSubmitting: true)),
      );

      await pumpSignUpPage(tester, mockCubit, settle: false);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have terms checkbox', (tester) async {
      await pumpSignUpPage(tester, mockCubit);

      expect(find.byType(Checkbox), findsOneWidget);
    });
  });
}
