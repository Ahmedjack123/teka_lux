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
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppSizes.lg,
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
                        SizedBox(height: DeviceHelper.authTopSpacing(context)),
                        const LoginHeader(),
                        const SizedBox(height: 68),
                        const LoginFormFields(),
                        const SizedBox(height: AppSizes.lg),
                        LoginOptionsRow(
                          rememberMe: rememberMe,
                          onRememberChanged: onRememberChanged,
                          onForgotPassword: onForgotPassword,
                        ),
                        const SizedBox(height: AppSizes.xl),
                        PrimaryButton(
                          label: l10n.signIn,
                          onPressed: onSignIn,
                        ),
                        const SizedBox(height: AppSizes.xl),
                        LoginSignupPrompt(onSignUp: onSignUp),
                        const Spacer(),
                        const AuthDividerLabel(),
                        const SizedBox(height: AppSizes.lg),
                        SocialSignInButton(
                          label: l10n.continueWithGoogle,
                          onPressed: onGoogleSignIn,
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
