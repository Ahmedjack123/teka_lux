import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theming/theming.dart';
import '../../../../core/utils/device_helper.dart';
import '../../../../injection.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../bloc/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocConsumer<HomeCubit, HomeState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == HomeStatus.signedOut) {
          context.goNamed(RouteNames.login);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.authBackground,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DeviceHelper.horizontalPadding(context),
                  vertical: AppSizes.xl,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: DeviceHelper.value(
                      context: context,
                      phone: AppBreakpoints.phoneMaxContentWidth,
                      tablet: 560,
                      desktop: 600,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.homePlaceholderTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.textStrong,
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        l10n.homePlaceholderSubtitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textBody,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xl),
                      SecondaryButton(
                        label: l10n.logout,
                        icon: Icons.logout_rounded,
                        isLoading: state.isSigningOut,
                        onPressed: context.read<HomeCubit>().signOut,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
