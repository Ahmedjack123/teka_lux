import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../core/utils/device_helper.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import 'forgot_password_card.dart';

class ForgotPasswordScaffold extends StatelessWidget {
  const ForgotPasswordScaffold({
    required this.onSubmit,
    required this.onBackToLogin,
    required this.emailController,
    required this.onEmailChanged,
    this.emailError,
    this.errorMessage,
    this.successMessage,
    this.isSubmitting = false,
    super.key,
  });

  final VoidCallback onSubmit;
  final VoidCallback onBackToLogin;
  final TextEditingController emailController;
  final ValueChanged<String> onEmailChanged;
  final String? emailError;
  final String? errorMessage;
  final String? successMessage;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = DeviceHelper.horizontalPadding(context);
    final palette = AppAuthPalette.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.brandShort,
          style: AppTextStyles.h2.copyWith(color: palette.text, fontSize: 34),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: palette.text),
          onPressed: onBackToLogin,
        ),
      ),
      // KEY FIX: Don't let scaffold resize — scroll view handles it
      resizeToAvoidBottomInset: false,
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
                    child: ForgotPasswordCard(
                      onSubmit: onSubmit,
                      onBackToLogin: onBackToLogin,
                      emailController: emailController,
                      onEmailChanged: onEmailChanged,
                      emailError: emailError,
                      errorMessage: errorMessage,
                      successMessage: successMessage,
                      isSubmitting: isSubmitting,
                      compact: DeviceHelper.sizeOf(context).height < 740,
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
