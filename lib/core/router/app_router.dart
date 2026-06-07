import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/sign_up/sign_up_page.dart';
import '../../features/auth/presentation/pages/verify_email/verify_email_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/profile/presentation/pages/addresses_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/startup/presentation/pages/onboarding_page.dart';
import '../../features/startup/presentation/pages/startup_page.dart';
import 'route_names.dart';

class AppRouter {
  const AppRouter._();

  static final router = build();

  static GoRouter build({
    Listenable? refreshListenable,
    GoRouterRedirect? redirect,
  }) {
    return GoRouter(
      initialLocation: RouteNames.startupPath,
      refreshListenable: refreshListenable,
      redirect: redirect,
      routes: _routes,
    );
  }

  static final _routes = [
    GoRoute(
      path: RouteNames.startupPath,
      name: RouteNames.startup,
      pageBuilder: (context, state) {
        return _fadePage(state, const StartupPage());
      },
    ),
    GoRoute(
      path: RouteNames.homePath,
      name: RouteNames.home,
      pageBuilder: (context, state) {
        return _fadePage(state, const HomePage());
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
        return _fadeSlidePage(state, const LoginPage());
      },
    ),
    GoRoute(
      path: RouteNames.registerPath,
      name: RouteNames.register,
      pageBuilder: (context, state) {
        return _fadeSlidePage(state, const SignUpPage());
      },
    ),
    GoRoute(
      path: RouteNames.forgotPasswordPath,
      name: RouteNames.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: RouteNames.verifyEmailPath,
      name: RouteNames.verifyEmail,
      pageBuilder: (context, state) {
        return _fadeSlidePage(
          state,
          VerifyEmailPage(emailJustSent: state.extra == true),
        );
      },
    ),
    GoRoute(
      path: RouteNames.profilePath,
      name: RouteNames.profile,
      pageBuilder: (context, state) {
        return _fadePage(state, const ProfilePage());
      },
      routes: [
        GoRoute(
          path: 'addresses',
          name: RouteNames.addresses,
          pageBuilder: (context, state) {
            return _fadePage(state, const AddressesPage());
          },
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.ordersPath,
      name: RouteNames.orders,
      pageBuilder: (context, state) {
        return _fadePage(state, const OrdersPage());
      },
    ),
    GoRoute(
      path: RouteNames.searchPath,
      name: RouteNames.search,
      pageBuilder: (context, state) {
        return _fadePage(state, const SearchPage());
      },
    ),
  ];

  static CustomTransitionPage<void> _fadePage(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 160),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(opacity: curvedAnimation, child: child);
      },
    );
  }

  static CustomTransitionPage<void> _fadeSlidePage(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 240),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(.04, 0),
          end: Offset.zero,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
    );
  }
}
