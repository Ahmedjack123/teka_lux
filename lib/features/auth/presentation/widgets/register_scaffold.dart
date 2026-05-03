import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../core/utils/device_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import 'auth_divider_label.dart';
import 'register_form_fields.dart';
import 'register_header.dart';
import 'register_login_prompt.dart';
import 'social_sign_in_button.dart';

class RegisterScaffold extends StatelessWidget {
  const RegisterScaffold({
    required this.onCreateAccount,
    required this.onGoogleSignIn,
    required this.onSignIn,
    super.key,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final horizontalPadding = DeviceHelper.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.textStrong),
      ),
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 760;
            final topSpacing = compact ? AppSizes.md : AppSizes.xl;
            final headerGap = compact ? AppSizes.lg : AppSizes.xl;
            final actionGap = compact ? AppSizes.lg : AppSizes.xl;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: compact ? AppSizes.md : AppSizes.lg,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxWidth: DeviceHelper.value(
                      context: context,
                      phone: AppBreakpoints.phoneMaxContentWidth,
                      tablet: 560,
                      desktop: 600,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: topSpacing),
                      RegisterHeader(compact: compact),
                      SizedBox(height: headerGap),
                      RegisterFormFields(compact: compact),
                      SizedBox(height: actionGap),
                      PrimaryButton(
                        label: l10n.createAccount,
                        onPressed: onCreateAccount,
                        height: compact ? 52 : AppSizes.buttonHeight,
                      ),
                      SizedBox(height: actionGap),
                      const AuthDividerLabel(),
                      SizedBox(height: compact ? AppSizes.md : AppSizes.lg),
                      SocialSignInButton(
                        label: l10n.continueWithGoogle,
                        onPressed: onGoogleSignIn,
                        compact: compact,
                      ),
                      SizedBox(height: actionGap),
                      RegisterLoginPrompt(
                        onSignIn: onSignIn,
                        compact: compact,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
