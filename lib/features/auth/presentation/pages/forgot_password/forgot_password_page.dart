import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_controller.dart';
import 'widgets/forgot_password_scaffold.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(forgotPasswordFormControllerProvider);
    final controller = ref.read(forgotPasswordFormControllerProvider.notifier);

    return ForgotPasswordScaffold(
      emailController: _emailController,
      emailError: state.emailError,
      errorMessage: state.errorMessage,
      successMessage: state.successMessage,
      resendSecondsRemaining: state.resendSecondsRemaining,
      isSubmitting: state.isSubmitting,
      onEmailChanged: (value) => controller.emailChanged(value, l10n),
      onSubmit: () => controller.submit(l10n),
      onBackToLogin: () {
        context.goNamed(RouteNames.login);
      },
    );
  }
}
