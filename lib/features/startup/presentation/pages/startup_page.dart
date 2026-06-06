import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../injection.dart';
import '../../domain/entities/startup_state.dart';
import '../bloc/startup_cubit.dart';
import '../widgets/startup_redirect_view.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StartupCubit>()..resolve(),
      child: BlocListener<StartupCubit, StartupViewState>(
        listenWhen: (previous, current) {
          return previous.destination != current.destination &&
              current.status == StartupViewStatus.resolved;
        },
        listener: (context, state) {
          final routeName = switch (state.destination) {
            StartupDestination.onboarding => RouteNames.onboarding,
            StartupDestination.login => RouteNames.login,
            null => RouteNames.login,
          };
          context.goNamed(routeName);
        },
        child: const StartupRedirectView(),
      ),
    );
  }
}
