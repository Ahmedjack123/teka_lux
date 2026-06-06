import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';
import '../../../../../injection.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../bloc/login/login_cubit.dart';
import '../../bloc/login/login_state.dart';
import 'widgets/login_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>()..loadRememberedEmail(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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

    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          previous.email != current.email ||
          previous.rememberMe != current.rememberMe,
      listener: (context, state) {
        _syncRememberedEmail(state);
      },
      buildWhen: (prev, curr) =>
          prev.isSubmitting != curr.isSubmitting ||
          prev.isGoogleSubmitting != curr.isGoogleSubmitting ||
          prev.errorMessage != curr.errorMessage ||
          prev.emailError != curr.emailError ||
          prev.passwordError != curr.passwordError ||
          prev.rememberMe != curr.rememberMe ||
          prev.requiresEmailVerification != curr.requiresEmailVerification,
      builder: (context, state) {
        // Sync remembered email on first build if needed
        _syncRememberedEmail(state);

        return LoginScaffold(
          rememberMe: state.rememberMe,
          emailController: _emailController,
          passwordController: _passwordController,
          emailError: state.emailError,
          passwordError: state.passwordError,
          errorMessage: state.errorMessage,
          isSubmitting: state.isSubmitting,
          isGoogleSubmitting: state.isGoogleSubmitting,
          onRememberChanged: context.read<LoginCubit>().rememberChanged,
          onEmailChanged: (value) {
            // Update controller text so validation reads correct value
            _emailController.text = value;
            _emailController.selection = TextSelection.collapsed(
              offset: value.length,
            );
            context.read<LoginCubit>().emailChanged(value, l10n);
          },
          onPasswordChanged: (value) {
            _passwordController.text = value;
            _passwordController.selection = TextSelection.collapsed(
              offset: value.length,
            );
            context.read<LoginCubit>().passwordChanged(value, l10n);
          },
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
            final cubit = context.read<LoginCubit>();
            final completed = await cubit.submit(l10n);
            if (!context.mounted) return;

            final latestState = cubit.state;
            if (latestState.requiresEmailVerification) {
              context.goNamed(RouteNames.verifyEmail);
              return;
            }
            if (!completed) return;
            context.goNamed(RouteNames.profile);
          },
          onGoogleSignIn: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            final cubit = context.read<LoginCubit>();
            final completed = await cubit.signInWithGoogle(l10n);
            if (!context.mounted) return;

            final latestState = cubit.state;
            if (latestState.requiresEmailVerification) {
              context.goNamed(RouteNames.verifyEmail);
              return;
            }
            if (!completed) return;
            context.goNamed(RouteNames.profile);
          },
        );
      },
    );
  }

  void _syncRememberedEmail(LoginState state) {
    final email = state.email;

    // Only sync if:
    // 1. Email is not empty
    // 2. Controller text is different from state email
    if (email.isEmpty || _emailController.text == email) {
      return;
    }

    _emailController.value = TextEditingValue(
      text: email,
      selection: TextSelection.collapsed(offset: email.length),
    );
  }
}
