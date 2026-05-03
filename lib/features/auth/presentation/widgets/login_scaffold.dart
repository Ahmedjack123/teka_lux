import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../core/utils/device_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import 'auth_divider_label.dart';
import 'login_form_fields.dart';
import 'login_header.dart';
import 'login_options_row.dart';
import 'login_signup_prompt.dart';
import 'social_sign_in_button.dart';

class LoginScaffold extends StatelessWidget {
  const LoginScaffold({
    required this.rememberMe,
    required this.onRememberChanged,
    required this.onForgotPassword,
    required this.onSignUp,
    required this.onSignIn,
    required this.onGoogleSignIn,
    super.key,
  });

  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;
  final VoidCallback onSignIn;
  final VoidCallback onGoogleSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final horizontalPadding = DeviceHelper.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 720;
            final topSpacing = compact
                ? AppSizes.lg
                : DeviceHelper.authTopSpacing(context) * .72;
            final headerGap = compact ? AppSizes.xl : 48.0;
            final sectionGap = compact ? AppSizes.md : AppSizes.lg;
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
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: topSpacing),
                        LoginHeader(compact: compact),
                        SizedBox(height: headerGap),
                        LoginFormFields(compact: compact),
                        SizedBox(height: sectionGap),
                        LoginOptionsRow(
                          rememberMe: rememberMe,
                          onRememberChanged: onRememberChanged,
                          onForgotPassword: onForgotPassword,
                          compact: compact,
                        ),
                        SizedBox(height: actionGap),
                        PrimaryButton(
                          label: l10n.signIn,
                          onPressed: onSignIn,
                          height: compact ? 52 : AppSizes.buttonHeight,
                        ),
                        SizedBox(height: actionGap),
                        LoginSignupPrompt(
                          onSignUp: onSignUp,
                          compact: compact,
                        ),
                        const SizedBox(height: AppSizes.xxxl),
                        const AuthDividerLabel(),
                        SizedBox(height: AppSizes.xl),
                        SocialSignInButton(
                          label: l10n.continueWithGoogle,
                          onPressed: onGoogleSignIn,
                          compact: compact,
                        ),
                      ],
                    ),
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
