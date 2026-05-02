import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../domain/entities/startup_state.dart';
import '../providers/startup_provider.dart';
import '../widgets/startup_redirect_view.dart';

class StartupPage extends ConsumerWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destination = ref.watch(startupDestinationProvider);

    destination.whenData((value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }

        final routeName = switch (value) {
          StartupDestination.onboarding => RouteNames.onboarding,
          StartupDestination.login => RouteNames.login,
        };
        context.goNamed(routeName);
      });
    });

    return const StartupRedirectView();
  }
}
