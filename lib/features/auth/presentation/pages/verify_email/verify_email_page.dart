import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';
import '../../../../../injection.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../bloc/verify_email_cubit.dart';
import 'widgets/verify_email_scaffold.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({
    this.emailJustSent = false,
    super.key,
  });

  final bool emailJustSent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VerifyEmailCubit>(),
      child: _VerifyEmailView(emailJustSent: emailJustSent),
    );
  }
}

class _VerifyEmailView extends StatefulWidget {
  const _VerifyEmailView({required this.emailJustSent});

  final bool emailJustSent;

  @override
  State<_VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<_VerifyEmailView>
    with WidgetsBindingObserver {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) {
      return;
    }

    _started = true;
    context.read<VerifyEmailCubit>().start(
          emailJustSent: widget.emailJustSent,
          l10n: AppLocalizations.of(context),
        );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<VerifyEmailCubit>().checkVerification(
            AppLocalizations.of(context),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
      builder: (context, state) {
        return VerifyEmailScaffold(
          isResending: state.isResending,
          isVerified: state.isVerified,
          resendSecondsRemaining: state.resendSecondsRemaining,
          message: state.message,
          errorMessage: state.errorMessage,
          onResend: () => context.read<VerifyEmailCubit>().resendEmail(l10n),
          onBackToLogin: () async {
            await context.read<VerifyEmailCubit>().signOut();
            if (!context.mounted) {
              return;
            }
            context.goNamed(RouteNames.login);
          },
          onNextToHome: () {
            context.goNamed(RouteNames.profile);
          },
        );
      },
    );
  }
}
