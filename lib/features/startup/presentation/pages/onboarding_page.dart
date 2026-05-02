import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_scaffold.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await ref.read(onboardingControllerProvider.notifier).complete();
    if (!mounted) {
      return;
    }

    final completionState = ref.read(onboardingControllerProvider);
    if (completionState.hasError) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.onboardingSaveError)),
      );
      return;
    }

    context.goNamed(RouteNames.login);
  }

  void _goToNextPage(int slideCount) {
    if (_currentIndex >= slideCount - 1) {
      _completeOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final slides = ref.watch(onboardingSlidesProvider);
    final completionState = ref.watch(onboardingControllerProvider);
    final isSaving = completionState.isLoading;

    return OnboardingScaffold(
      slides: slides,
      pageController: _pageController,
      currentIndex: _currentIndex,
      isSaving: isSaving,
      onPageChanged: (index) {
        setState(() => _currentIndex = index);
      },
      onNext: () => _goToNextPage(slides.length),
      onSkip: _completeOnboarding,
    );
  }
}
