import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_controller.dart';
import 'widgets/login_scaffold.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    Future.microtask(() async {
      await ref
          .read(loginFormControllerProvider.notifier)
          .loadRememberedEmail();
      final email = ref.read(loginFormControllerProvider).email;
      if (mounted && email.isNotEmpty && _emailController.text.isEmpty) {
        _emailController.text = email;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(loginFormControllerProvider);
    final controller = ref.read(loginFormControllerProvider.notifier);

    return LoginScaffold(
      rememberMe: state.rememberMe,
      emailController: _emailController,
      passwordController: _passwordController,
      emailError: state.emailError,
      passwordError: state.passwordError,
      errorMessage: state.errorMessage,
      isSubmitting: state.isSubmitting,
      isGoogleSubmitting: state.isGoogleSubmitting,
      onRememberChanged: controller.rememberChanged,
      onEmailChanged: (value) => controller.emailChanged(value, l10n),
      onPasswordChanged: (value) => controller.passwordChanged(value, l10n),
      onForgotPassword: () {
        FocusManager.instance.primaryFocus?.unfocus();
        context.pushNamed(RouteNames.forgotPassword);
      },
      onSignUp: () {
        FocusManager.instance.primaryFocus?.unfocus();
        context.pushNamed(RouteNames.register);
      },
      onSignIn: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        final completed = await controller.submit(l10n);
        if (!context.mounted) {
          return;
        }

        final latestState = ref.read(loginFormControllerProvider);
        if (latestState.requiresEmailVerification) {
          context.goNamed(RouteNames.verifyEmail);
          return;
        }

        if (!completed) {
          return;
        }

        context.goNamed(RouteNames.home);
      },
      onGoogleSignIn: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        final completed = await controller.signInWithGoogle(l10n);
        if (!context.mounted) {
          return;
        }

        final latestState = ref.read(loginFormControllerProvider);
        if (latestState.requiresEmailVerification) {
          context.goNamed(RouteNames.verifyEmail);
          return;
        }

        if (!completed) {
          return;
        }

        context.goNamed(RouteNames.home);
      },
    );
  }
}
