import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../widgets/forgot_password_scaffold.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScaffold(
      onSubmit: () {},
      onBackToLogin: () {
        context.goNamed(RouteNames.login);
      },
    );
  }
}
