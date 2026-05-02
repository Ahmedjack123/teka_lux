import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/auth_placeholder_view.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPlaceholderView(
      title: AppLocalizations.of(context).registerTitle,
    );
  }
}
