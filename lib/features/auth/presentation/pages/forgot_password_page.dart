import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/auth_placeholder_view.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPlaceholderView(
      title: AppLocalizations.of(context).forgotPasswordTitle,
    );
  }
}
