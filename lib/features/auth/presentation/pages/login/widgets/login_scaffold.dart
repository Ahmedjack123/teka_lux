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
    final palette = AppAuthPalette.of(context);
    final horizontalPadding = DeviceHelper.horizontalPadding(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // KEY FIX: Don't let scaffold resize — scroll view handles it
        resizeToAvoidBottomInset: false,
        backgroundColor: palette.background,
        body: SafeArea(
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  AppSizes.lg,
                  horizontalPadding,
                  AppSizes.xxl,
                ),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: DeviceHelper.value(
                          context: context,
                          phone: AppBreakpoints.phoneMaxContentWidth,
                          tablet: 560,
                          desktop: 600,
                        ),
                      ),
                      child: _LoginFormContent(
                        rememberMe: rememberMe,
                        emailController: emailController,
                        passwordController: passwordController,
                        emailError: emailError,
                        passwordError: passwordError,
                        errorMessage: errorMessage,
                        isSubmitting: isSubmitting,
                        isGoogleSubmitting: isGoogleSubmitting,
                        onRememberChanged: onRememberChanged,
                        onEmailChanged: onEmailChanged,
                        onPasswordChanged: onPasswordChanged,
                        onForgotPassword: onForgotPassword,
                        onSignUp: onSignUp,
                        onSignIn: onSignIn,
                        onGoogleSignIn: onGoogleSignIn,
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: _KeyboardAwareBottomPadding(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginFormContent extends StatelessWidget {
  const _LoginFormContent({
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
    final palette = AppAuthPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LoginHeader(compact: true),
        const SizedBox(height: AppSizes.xxl),
        LoginFormFields(
          emailController: emailController,
          passwordController: passwordController,
          emailError: emailError,
          passwordError: passwordError,
          onEmailChanged: onEmailChanged,
          onPasswordChanged: onPasswordChanged,
          onForgotPassword: onForgotPassword,
          enabled: !isSubmitting && !isGoogleSubmitting,
          compact: true,
        ),
        const SizedBox(height: AppSizes.md),
        LoginOptionsRow(
          rememberMe: rememberMe,
          onRememberChanged: onRememberChanged,
          compact: true,
        ),
        const SizedBox(height: AppSizes.lg),
        PrimaryButton(
          label: l10n.signIn,
          onPressed: onSignIn,
          isLoading: isSubmitting,
          height: 52,
          radius: 0,
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: AppSizes.md),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: palette.error,
              height: 1.35,
            ),
          ),
        ],
        const SizedBox(height: AppSizes.xxl),
        const AuthDividerLabel(),
        const SizedBox(height: AppSizes.md),
        SocialSignInButton(
          label: l10n.continueWithGoogle,
          onPressed: onGoogleSignIn,
          isLoading: isGoogleSubmitting,
          compact: true,
        ),
        const SizedBox(height: AppSizes.xxl),
        LoginSignupPrompt(
          onSignUp: onSignUp,
          compact: true,
        ),
      ],
    );
  }
}

class _KeyboardAwareBottomPadding extends StatelessWidget {
  const _KeyboardAwareBottomPadding();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return SizedBox(
      height: bottomInset > 0 ? bottomInset + AppSizes.lg : AppSizes.lg,
    );
  }
}
