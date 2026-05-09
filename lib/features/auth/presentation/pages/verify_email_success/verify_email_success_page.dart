import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';
import 'widgets/verify_email_success_scaffold.dart';

class VerifyEmailSuccessPage extends StatelessWidget {
  const VerifyEmailSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return VerifyEmailSuccessScaffold(
      onNext: () => context.goNamed(RouteNames.home),
    );
  }
}
