import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:teka_luxe/features/auth/presentation/pages/login/login_page.dart';
import 'package:teka_luxe/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:teka_luxe/features/auth/presentation/pages/verify_email/verify_email_page.dart';
import 'package:teka_luxe/features/home/presentation/pages/home_page.dart';

import 'helpers/test_app.dart';
import 'mocks/mock_auth_remote_datasource.dart';

/// Integration test for the full auth flow.
///
/// This test runs the actual app UI with a mocked auth backend,
/// covering: register → verify email → login → logout.
///
/// Run with:
///   flutter test integration_test/auth_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration Test', () {
    late MockAuthRemoteDatasource mockDatasource;

    setUp(() async {
      mockDatasource = await bootstrapTestApp();
    });

    tearDown(() {
      mockDatasource.dispose();
    });

    // ─────────────────────────────────────────────────────────────
    // Helpers
    // ─────────────────────────────────────────────────────────────

    Future<void> pumpApp(WidgetTester tester) async {
      runTestApp();
      // Wait for app to render startup page
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    Future<void> waitForNavigation(WidgetTester tester) async {
      // Allow go_router transitions and cubit state changes to settle
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
    }

    Future<void> enterTextInField(
      WidgetTester tester,
      Finder finder,
      String text,
    ) async {
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pump();
      await tester.enterText(finder, text);
      await tester.pump();
    }

    Future<void> tapPrimaryButton(WidgetTester tester, String label) async {
      final finder = find.widgetWithText(ElevatedButton, label);
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pump();
    }

    // ─────────────────────────────────────────────────────────────
    // Tests
    // ─────────────────────────────────────────────────────────────

    testWidgets('app launches and navigates from startup to login', (
      tester,
    ) async {
      await pumpApp(tester);

      // Startup page should show first, then redirect to login
      await waitForNavigation(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('navigate from login to sign up page', (tester) async {
      await pumpApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(LoginPage), findsOneWidget);

      // Tap "Create Account" / sign up prompt
      final signUpFinder = find.textContaining(
        'Create Account',
        findRichText: true,
      );
      if (signUpFinder.evaluate().isNotEmpty) {
        await tester.tap(signUpFinder);
      } else {
        // Try the text button at the bottom
        final signUpButton = find.widgetWithText(TextButton, 'Sign up');
        if (signUpButton.evaluate().isNotEmpty) {
          await tester.tap(signUpButton);
        }
      }
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(SignUpPage), findsOneWidget);
    });

    testWidgets('full flow: register → verify → login → logout', (tester) async {
      const testEmail = 'integration@test.com';
      const testPassword = 'Password123!';
      const testName = 'Integration User';
      const testPhone = '0912345678';

      await pumpApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // ── 1. Should be on Login page ──
      expect(find.byType(LoginPage), findsOneWidget);

      // ── 2. Navigate to Sign Up ──
      final signUpPrompt = find.textContaining('Sign up', findRichText: true);
      if (signUpPrompt.evaluate().isNotEmpty) {
        await tester.ensureVisible(signUpPrompt);
        await tester.tap(signUpPrompt);
      }
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(SignUpPage), findsOneWidget);

      // ── 3. Fill registration form ──
      // Find all text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsAtLeastNWidgets(5));

      // Name field (first)
      await enterTextInField(tester, textFields.at(0), testName);

      // Phone field (second)
      await enterTextInField(tester, textFields.at(1), testPhone);

      // Email field (third)
      await enterTextInField(tester, textFields.at(2), testEmail);

      // Password field (fourth)
      await enterTextInField(tester, textFields.at(3), testPassword);

      // Confirm password field (fifth)
      await enterTextInField(tester, textFields.at(4), testPassword);

      // Accept terms checkbox
      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().isNotEmpty) {
        await tester.tap(checkboxes.first);
        await tester.pump();
      }

      // ── 4. Submit registration ──
      await tapPrimaryButton(tester, 'Create Account');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      // Should navigate to verify email page
      await tester.pump(const Duration(milliseconds: 800));
      expect(find.byType(VerifyEmailPage), findsOneWidget);

      // ── 5. Simulate email verification from "backend" ──
      mockDatasource.verifyCurrentUserEmail();

      // Wait for the verification polling to pick it up
      // The VerifyEmailCubit polls every 3 seconds
      await tester.pump(const Duration(seconds: 4));

      // Should show success state with "Next" button
      final nextButton = find.widgetWithText(ElevatedButton, 'Next');
      expect(nextButton, findsOneWidget);

      // Tap Next to go to home
      await tester.tap(nextButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // ── 6. Should be on Home page ──
      expect(find.byType(HomePage), findsOneWidget);

      // ── 7. Logout ──
      final logoutButton = find.widgetWithText(OutlinedButton, 'Logout');
      expect(logoutButton, findsOneWidget);
      await tester.tap(logoutButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      // Should be back on Login page
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('login with existing registered user', (tester) async {
      const testEmail = 'existing@test.com';
      const testPassword = 'Password123!';
      const testName = 'Existing User';

      // Pre-seed a user in the mock datasource
      mockDatasource.setCurrentUser(
        await mockDatasource.signUp(
          email: testEmail,
          password: testPassword,
          name: testName,
          phoneNumber: '0911111111',
        ),
      );
      await mockDatasource.signOut();

      await pumpApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(LoginPage), findsOneWidget);

      // Fill login form
      final textFields = find.byType(TextField);
      await enterTextInField(tester, textFields.at(0), testEmail);
      await enterTextInField(tester, textFields.at(1), testPassword);

      // Submit login
      await tapPrimaryButton(tester, 'Sign In');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      // Should navigate to home (user is pre-verified)
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('login shows error for wrong password', (tester) async {
      const testEmail = 'wrongpass@test.com';
      const testPassword = 'Password123!';

      // Pre-seed user
      await mockDatasource.signUp(
        email: testEmail,
        password: testPassword,
        name: 'Wrong Pass User',
        phoneNumber: '0922222222',
      );
      await mockDatasource.signOut();

      await pumpApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Fill login with wrong password
      final textFields = find.byType(TextField);
      await enterTextInField(tester, textFields.at(0), testEmail);
      await enterTextInField(tester, textFields.at(1), 'wrongpassword');

      // Submit
      await tapPrimaryButton(tester, 'Sign In');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      // Should still be on login with error
      expect(find.byType(LoginPage), findsOneWidget);
      // Error message should appear
      expect(find.textContaining('password', findRichText: true), findsWidgets);
    });

    testWidgets('sign up prevents duplicate email', (tester) async {
      const testEmail = 'duplicate@test.com';
      const testPassword = 'Password123!';

      // Pre-seed user
      await mockDatasource.signUp(
        email: testEmail,
        password: testPassword,
        name: 'First User',
        phoneNumber: '0933333333',
      );
      await mockDatasource.signOut();

      await pumpApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to sign up
      final signUpPrompt = find.textContaining('Sign up', findRichText: true);
      if (signUpPrompt.evaluate().isNotEmpty) {
        await tester.tap(signUpPrompt);
      }
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Fill form with same email
      final textFields = find.byType(TextField);
      await enterTextInField(tester, textFields.at(0), 'Second User');
      await enterTextInField(tester, textFields.at(1), '0944444444');
      await enterTextInField(tester, textFields.at(2), testEmail);
      await enterTextInField(tester, textFields.at(3), testPassword);
      await enterTextInField(tester, textFields.at(4), testPassword);

      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().isNotEmpty) {
        await tester.tap(checkboxes.first);
        await tester.pump();
      }

      // Submit
      await tapPrimaryButton(tester, 'Create Account');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      // Should still be on sign up with error
      expect(find.byType(SignUpPage), findsOneWidget);
    });

    testWidgets('keyboard does not cause overflow on auth pages', (tester) async {
      await pumpApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap email field to trigger keyboard
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);
      await tester.tap(textFields.first);
      await tester.pump();

      // No overflow should occur (Flutter would throw if it did)
      expect(tester.takeException(), isNull);

      // Dismiss keyboard
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
    });

    testWidgets('scroll works on login page', (tester) async {
      await pumpApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final scrollable = find.byType(Scrollable);
      expect(scrollable, findsWidgets);

      // Fling down then up
      await tester.fling(scrollable.first, const Offset(0, -200), 500);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.fling(scrollable.first, const Offset(0, 200), 500);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}
