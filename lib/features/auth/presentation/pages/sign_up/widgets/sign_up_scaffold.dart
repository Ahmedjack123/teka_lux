import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../core/utils/device_helper.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../../../shared/widgets/buttons/primary_button.dart';
import 'auth_divider_label.dart';
import 'sign_up_form_fields.dart';
import 'sign_up_header.dart';
import 'sign_up_login_prompt.dart';
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
    this.nameError,
    this.phoneNumberError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
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
  final String? nameError;
  final String? phoneNumberError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.authBackground,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 760;
              final topSpacing = compact ? AppSizes.md : AppSizes.xl;
              final headerGap = compact ? AppSizes.lg : AppSizes.xl;
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: topSpacing),
                          SignUpHeader(compact: compact),
                          SizedBox(height: headerGap),
                          SignUpFormFields(
                            nameController: nameController,
                            phoneNumberController: phoneNumberController,
                            emailController: emailController,
                            passwordController: passwordController,
                            confirmPasswordController:
                                confirmPasswordController,
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
                            compact: compact,
                          ),
                          SizedBox(height: actionGap),
                          PrimaryButton(
                            label: l10n.createAccount,
                            onPressed: onCreateAccount,
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
                          const AuthDividerLabel(),
                          SizedBox(height: compact ? AppSizes.md : AppSizes.lg),
                          SocialSignInButton(
                            label: l10n.continueWithGoogle,
                            onPressed: onGoogleSignIn,
                            isLoading: isGoogleSubmitting,
                            compact: compact,
                          ),
                          SizedBox(height: actionGap),
                          SignUpLoginPrompt(
                            onSignIn: onSignIn,
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
      ),
    );
  }
}
