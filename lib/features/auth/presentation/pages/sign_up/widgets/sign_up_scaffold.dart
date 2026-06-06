import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../core/utils/device_helper.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../../../shared/widgets/buttons/primary_button.dart';
import 'auth_divider_label.dart';
import 'sign_up_form_fields.dart';
import 'sign_up_header.dart';
import 'sign_up_login_prompt.dart';
import 'sign_up_terms_agreement.dart';
import 'social_sign_in_button.dart';

class SignUpScaffold extends StatelessWidget {
  const SignUpScaffold({
    required this.nameController,
    required this.phoneNumberController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onCreateAccount,
    required this.onGoogleSignIn,
    required this.onSignIn,
    required this.onNameChanged,
    required this.onPhoneNumberChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onTermsChanged,
    required this.acceptedTerms,
    this.nameError,
    this.phoneNumberError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.termsError,
    this.errorMessage,
    this.isSubmitting = false,
    this.isGoogleSubmitting = false,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onCreateAccount;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onSignIn;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onPhoneNumberChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;
  final ValueChanged<bool> onTermsChanged;
  final bool acceptedTerms;
  final String? nameError;
  final String? phoneNumberError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? termsError;
  final String? errorMessage;
  final bool isSubmitting;
  final bool isGoogleSubmitting;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppAuthPalette.of(context);
    final horizontalPadding = DeviceHelper.horizontalPadding(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: palette.background,
          elevation: 0,
          centerTitle: true,
          title: Text(
            l10n.brandShort,
            style: AppTextStyles.h2.copyWith(
              color: palette.text,
              fontSize: 34,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: palette.text),
            onPressed: () => context.pop(),
          ),
        ),
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
                  AppSizes.sm,
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
                      child: _SignUpFormContent(
                        nameController: nameController,
                        phoneNumberController: phoneNumberController,
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
                        nameError: nameError,
                        phoneNumberError: phoneNumberError,
                        emailError: emailError,
                        passwordError: passwordError,
                        confirmPasswordError: confirmPasswordError,
                        termsError: termsError,
                        errorMessage: errorMessage,
                        isSubmitting: isSubmitting,
                        isGoogleSubmitting: isGoogleSubmitting,
                        acceptedTerms: acceptedTerms,
                        onNameChanged: onNameChanged,
                        onPhoneNumberChanged: onPhoneNumberChanged,
                        onEmailChanged: onEmailChanged,
                        onPasswordChanged: onPasswordChanged,
                        onConfirmPasswordChanged: onConfirmPasswordChanged,
                        onTermsChanged: onTermsChanged,
                        onCreateAccount: onCreateAccount,
                        onGoogleSignIn: onGoogleSignIn,
                        onSignIn: onSignIn,
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom padding that adapts to keyboard
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

/// Extracted widget to minimize rebuilds — only error states trigger rebuild
class _SignUpFormContent extends StatelessWidget {
  const _SignUpFormContent({
    required this.nameController,
    required this.phoneNumberController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onCreateAccount,
    required this.onGoogleSignIn,
    required this.onSignIn,
    required this.onNameChanged,
    required this.onPhoneNumberChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onTermsChanged,
    required this.acceptedTerms,
    this.nameError,
    this.phoneNumberError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.termsError,
    this.errorMessage,
    this.isSubmitting = false,
    this.isGoogleSubmitting = false,
  });

  final TextEditingController nameController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onCreateAccount;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onSignIn;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onPhoneNumberChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;
  final ValueChanged<bool> onTermsChanged;
  final bool acceptedTerms;
  final String? nameError;
  final String? phoneNumberError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? termsError;
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
        const SignUpHeader(compact: true),
        const SizedBox(height: AppSizes.lg),
        SignUpFormFields(
          nameController: nameController,
          phoneNumberController: phoneNumberController,
          emailController: emailController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
          nameError: nameError,
          phoneNumberError: phoneNumberError,
          emailError: emailError,
          passwordError: passwordError,
          confirmPasswordError: confirmPasswordError,
          onNameChanged: onNameChanged,
          onPhoneNumberChanged: onPhoneNumberChanged,
          onEmailChanged: onEmailChanged,
          onPasswordChanged: onPasswordChanged,
          onConfirmPasswordChanged: onConfirmPasswordChanged,
          enabled: !isSubmitting && !isGoogleSubmitting,
          compact: true,
        ),
        const SizedBox(height: AppSizes.md),
        SignUpTermsAgreement(
          accepted: acceptedTerms,
          onChanged: onTermsChanged,
          errorText: termsError,
          compact: true,
        ),
        const SizedBox(height: AppSizes.lg),
        PrimaryButton(
          label: l10n.createAccount,
          onPressed: onCreateAccount,
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
        const SizedBox(height: AppSizes.lg),
        const AuthDividerLabel(),
        const SizedBox(height: AppSizes.md),
        SocialSignInButton(
          label: l10n.continueWithGoogle,
          onPressed: onGoogleSignIn,
          isLoading: isGoogleSubmitting,
          compact: true,
        ),
        const SizedBox(height: AppSizes.lg),
        SignUpLoginPrompt(
          onSignIn: onSignIn,
          compact: true,
        ),
      ],
    );
  }
}

/// Isolated widget that listens to keyboard insets without rebuilding the form
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
