import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../core/utils/device_helper.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../../../shared/widgets/buttons/primary_button.dart';
import 'auth_divider_label.dart';
import 'login_form_fields.dart';
import 'login_header.dart';
import 'login_options_row.dart';
import 'login_signup_prompt.dart';
import 'social_sign_in_button.dart';

class LoginScaffold extends StatelessWidget {
  const LoginScaffold({
    required this.rememberMe,
    required this.emailController,
    required this.passwordController,
    required this.onRememberChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onForgotPassword,
    required this.onSignUp,
    required this.onSignIn,
    required this.onGoogleSignIn,
    this.emailError,
    this.passwordError,
    this.errorMessage,
    this.isSubmitting = false,
    this.isGoogleSubmitting = false,
    super.key,
  });

  final bool rememberMe;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueChanged<bool> onRememberChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;
  final VoidCallback onSignIn;
  final VoidCallback onGoogleSignIn;
  final String? emailError;
  final String? passwordError;
  final String? errorMessage;
  final bool isSubmitting;
  final bool isGoogleSubmitting;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final horizontalPadding = DeviceHelper.horizontalPadding(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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

              return AnimatedPadding(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.only(
                  bottom: bottomInset > 0 ? AppSizes.md : 0,
                ),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    compact ? AppSizes.md : AppSizes.lg,
                    horizontalPadding,
                    bottomInset > 0 ? AppSizes.xxxl : AppSizes.lg,
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
                            LoginFormFields(
                              emailController: emailController,
                              passwordController: passwordController,
                              emailError: emailError,
                              passwordError: passwordError,
                              onEmailChanged: onEmailChanged,
                              onPasswordChanged: onPasswordChanged,
                              enabled: !isSubmitting && !isGoogleSubmitting,
                              compact: compact,
                            ),
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
                              isLoading: isSubmitting,
                              height: compact ? 52 : AppSizes.buttonHeight,
                            ),
                            if (errorMessage != null) ...[
                              const SizedBox(height: AppSizes.md),
                              Text(
                                errorMessage!,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.error,
                                  height: 1.35,
                                ),
                              ),
                            ],
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
                              isLoading: isGoogleSubmitting,
                              compact: compact,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
