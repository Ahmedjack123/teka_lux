import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../injection.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/onboarding_slide_model.dart';
import '../bloc/onboarding_cubit.dart';
import '../widgets/onboarding_scaffold.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
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
    final completed = await context.read<OnboardingCubit>().complete();
    if (!mounted) {
      return;
    }

    if (!completed) {
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
    const slides = OnboardingSlideModel.defaults;

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return OnboardingScaffold(
          slides: slides,
          pageController: _pageController,
          currentIndex: _currentIndex,
          isSaving: state.isSaving,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          onNext: () => _goToNextPage(slides.length),
          onSkip: _completeOnboarding,
        );
      },
    );
  }
}
