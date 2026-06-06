import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/router/route_names.dart';
import 'core/theming/app_theme.dart';
import 'features/auth/presentation/bloc/auth_session_cubit.dart';
import 'injection.dart';
import 'l10n/generated/app_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthSessionCubit _authSessionCubit;
  late final _AuthRouteRefreshNotifier _refreshNotifier;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authSessionCubit = sl<AuthSessionCubit>();
    _refreshNotifier = _AuthRouteRefreshNotifier(_authSessionCubit);
    _router = AppRouter.build(
      refreshListenable: _refreshNotifier,
      redirect: _redirect,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    _refreshNotifier.dispose();
    _authSessionCubit.close();
    super.dispose();
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    final authState = _authSessionCubit.state;
    final location = state.matchedLocation;

    // Auth state still resolving — allow navigation
    if (!authState.isKnown) {
      return null;
    }

    final isAuthRoute = location == RouteNames.loginPath ||
        location == RouteNames.registerPath ||
        location == RouteNames.forgotPasswordPath;
    final isHomeRoute = location == RouteNames.homePath;
    final isVerifyRoute = location == RouteNames.verifyEmailPath;
    final isStartupRoute = location == RouteNames.startupPath ||
        location == RouteNames.onboardingPath;

    // Authenticated user on auth page → profile
    if (authState.isAuthenticated && isAuthRoute) {
      return RouteNames.profilePath;
    }

    // Unauthenticated user on protected page → login
    if (!authState.isAuthenticated && (isHomeRoute || isVerifyRoute)) {
      return RouteNames.loginPath;
    }

    // Authenticated but email not verified → verify email
    // (except verify page itself and startup/onboarding)
    if (authState.isAuthenticated &&
        !authState.isEmailVerified &&
        !isVerifyRoute &&
        !isStartupRoute) {
      return RouteNames.verifyEmailPath;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authSessionCubit,
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: _router,
      ),
    );
  }
}

final class _AuthRouteRefreshNotifier extends ChangeNotifier {
  _AuthRouteRefreshNotifier(AuthSessionCubit authSessionCubit) {
    _subscription = authSessionCubit.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthSessionState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
