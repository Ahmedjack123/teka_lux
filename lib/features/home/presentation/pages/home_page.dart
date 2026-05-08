import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theming/theming.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/device_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    if (_isSigningOut) {
      return;
    }

    setState(() => _isSigningOut = true);

    final result = await ref.read(signOutUseCaseProvider)(const NoParams());

    if (!mounted) {
      return;
    }

    result.fold(
      (_) => setState(() => _isSigningOut = false),
      (_) => context.goNamed(RouteNames.login),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                    isLoading: _isSigningOut,
                    onPressed: _signOut,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
