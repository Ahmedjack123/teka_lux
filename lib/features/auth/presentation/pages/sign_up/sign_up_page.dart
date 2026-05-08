import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_controller.dart';
import 'widgets/sign_up_scaffold.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(registerFormControllerProvider);
    final controller = ref.read(registerFormControllerProvider.notifier);

    return SignUpScaffold(
      nameController: _nameController,
      phoneNumberController: _phoneNumberController,
      emailController: _emailController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      nameError: state.nameError,
      phoneNumberError: state.phoneNumberError,
      emailError: state.emailError,
      passwordError: state.passwordError,
      confirmPasswordError: state.confirmPasswordError,
      errorMessage: state.errorMessage,
      isSubmitting: state.isSubmitting,
      isGoogleSubmitting: state.isGoogleSubmitting,
      onNameChanged: (value) => controller.nameChanged(value, l10n),
      onPhoneNumberChanged: (value) {
        controller.phoneNumberChanged(value, l10n);
      },
      onEmailChanged: (value) => controller.emailChanged(value, l10n),
      onPasswordChanged: (value) => controller.passwordChanged(value, l10n),
      onConfirmPasswordChanged: (value) {
        controller.confirmPasswordChanged(value, l10n);
      },
      onCreateAccount: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        final completed = await controller.submit(l10n);
        if (!context.mounted || !completed) {
          return;
        }
        context.goNamed(RouteNames.verifyEmail, extra: true);
      },
      onGoogleSignIn: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        final completed = await controller.signInWithGoogle(l10n);
        if (!context.mounted || !completed) {
          return;
        }
        context.goNamed(RouteNames.home);
      },
      onSignIn: () {
        FocusManager.instance.primaryFocus?.unfocus();
        context.goNamed(RouteNames.login);
      },
    );
  }
}
