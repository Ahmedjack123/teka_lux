import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';
import '../../../../../injection.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../bloc/forgot_password/forgot_password_cubit.dart';
import '../../bloc/forgot_password/forgot_password_state.dart';
import 'widgets/forgot_password_scaffold.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForgotPasswordCubit>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
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
    final controller = context.read<ForgotPasswordCubit>();

    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        return ForgotPasswordScaffold(
          emailController: _emailController,
          emailError: state.emailError,
          errorMessage: state.errorMessage,
          successMessage: state.successMessage,
          isSubmitting: state.isSubmitting,
          onEmailChanged: (value) => controller.emailChanged(value, l10n),
          onSubmit: () => controller.submit(l10n),
          onBackToLogin: () {
            context.goNamed(RouteNames.login);
          },
        );
      },
    );
  }
}
