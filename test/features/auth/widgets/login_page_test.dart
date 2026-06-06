import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/login/login_state.dart';
import 'package:teka_luxe/features/auth/presentation/pages/login/login_page.dart';
import 'package:teka_luxe/l10n/generated/app_localizations.dart';

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

Future<void> pumpLoginPage(WidgetTester tester, MockLoginCubit cubit,
    {bool settle = true}) async {
  if (GetIt.I.isRegistered<LoginCubit>()) {
    GetIt.I.unregister<LoginCubit>();
  }
  GetIt.I.registerFactory<LoginCubit>(() => cubit);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LoginPage(),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

void main() {
  late MockLoginCubit mockCubit;

  setUp(() {
    mockCubit = MockLoginCubit();
    when(() => mockCubit.state).thenReturn(const LoginState());
    when(() => mockCubit.stream).thenAnswer(
      (_) => Stream.value(const LoginState()),
    );
    when(() => mockCubit.loadRememberedEmail()).thenReturn(null);
  });

  tearDown(() {
    if (GetIt.I.isRegistered<LoginCubit>()) {
      GetIt.I.unregister<LoginCubit>();
    }
  });

  group('LoginPage Widget Tests', () {
    testWidgets('should display login form elements', (tester) async {
      await pumpLoginPage(tester, mockCubit);

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('should show loading state when submitting', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const LoginState(isSubmitting: true),
      );
      when(() => mockCubit.stream).thenAnswer(
        (_) => Stream.value(const LoginState(isSubmitting: true)),
      );

      await pumpLoginPage(tester, mockCubit, settle: false);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message when login fails', (tester) async {
      const errorMessage = 'Invalid credentials';
      when(() => mockCubit.state).thenReturn(
        const LoginState(errorMessage: errorMessage),
      );
      when(() => mockCubit.stream).thenAnswer(
        (_) => Stream.value(const LoginState(errorMessage: errorMessage)),
      );

      await pumpLoginPage(tester, mockCubit);

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should show email error when validation fails',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const LoginState(emailError: 'Invalid email'),
      );
      when(() => mockCubit.stream).thenAnswer(
        (_) => Stream.value(const LoginState(emailError: 'Invalid email')),
      );

      await pumpLoginPage(tester, mockCubit);

      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('should pre-fill email when remembered', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const LoginState(email: 'remembered@example.com', rememberMe: true),
      );
      when(() => mockCubit.stream).thenAnswer(
        (_) => Stream.value(
          const LoginState(email: 'remembered@example.com', rememberMe: true),
        ),
      );

      await pumpLoginPage(tester, mockCubit);

      final emailField = find.byType(TextField).first;
      final controller = tester.widget<TextField>(emailField).controller;
      expect(controller?.text, equals('remembered@example.com'));
    });
  });
}
