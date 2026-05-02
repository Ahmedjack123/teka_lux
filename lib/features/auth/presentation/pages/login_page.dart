import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../widgets/login_scaffold.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return LoginScaffold(
      rememberMe: _rememberMe,
      onRememberChanged: (value) {
        setState(() => _rememberMe = value);
      },
      onForgotPassword: () {
        context.pushNamed(RouteNames.forgotPassword);
      },
      onSignUp: () {
        context.pushNamed(RouteNames.register);
      },
      onSignIn: () {},
      onGoogleSignIn: () {},
    );
  }
}
