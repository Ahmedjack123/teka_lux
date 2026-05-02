import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/startup/presentation/pages/onboarding_page.dart';
import '../../features/startup/presentation/pages/startup_page.dart';
import 'route_names.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: RouteNames.startupPath,
    routes: [
      GoRoute(
        path: RouteNames.startupPath,
        name: RouteNames.startup,
        pageBuilder: (context, state) {
          return _fadePage(state, const StartupPage());
        },
      ),
      GoRoute(
        path: RouteNames.onboardingPath,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) {
          return _fadePage(state, const OnboardingPage());
        },
      ),
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        pageBuilder: (context, state) {
          return _fadePage(state, const LoginPage());
        },
      ),
      GoRoute(
        path: RouteNames.registerPath,
        name: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPasswordPath,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
    ],
  );

  static CustomTransitionPage<void> _fadePage(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
