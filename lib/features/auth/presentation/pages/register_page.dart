import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../widgets/register_scaffold.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterScaffold(
      onCreateAccount: () {},
      onGoogleSignIn: () {},
      onSignIn: () {
        context.goNamed(RouteNames.login);
      },
    );
  }
}
