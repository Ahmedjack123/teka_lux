import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import 'widgets/verify_email_scaffold.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({
    this.emailJustSent = false,
    super.key,
  });

  final bool emailJustSent;

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage>
    with WidgetsBindingObserver {
  static const int _resendCooldownSeconds = 60;

  Timer? _verificationTimer;
  Timer? _cooldownTimer;
  bool _isChecking = false;
  bool _isResending = false;
  bool _isVerified = false;
  int _resendSecondsRemaining = 0;
  String? _message;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.emailJustSent) {
      _resendSecondsRemaining = _resendCooldownSeconds;
      _startResendCooldown();
    }
    _verificationTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkVerification(),
    );
    Future.microtask(_checkVerification);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _verificationTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkVerification();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return VerifyEmailScaffold(
      isResending: _isResending,
      isVerified: _isVerified,
      resendSecondsRemaining: _resendSecondsRemaining,
      message: _message,
      errorMessage: _errorMessage,
      onResend: () => _resendEmail(l10n),
      onBackToLogin: _backToLogin,
      onNextToHome: _nextToHome,
    );
  }

  Future<void> _checkVerification() async {
    if (_isChecking || _isVerified || !mounted) {
      return;
    }

    _isChecking = true;

    final l10n = AppLocalizations.of(context);
    final result = await ref.read(checkEmailVerifiedUseCaseProvider)(
      const NoParams(),
    );

    if (!mounted) {
      return;
    }

    result.fold((failure) {
      setState(() {
        _isChecking = false;
        _errorMessage = failure.localizedMessage(l10n);
      });
    }, (verified) {
      if (verified) {
        _showSuccessAndContinue();
        return;
      }

      setState(() => _isChecking = false);
    });
  }

  Future<void> _resendEmail(AppLocalizations l10n) async {
    if (_isResending || _isVerified || _resendSecondsRemaining > 0) {
      return;
    }

    setState(() {
      _isResending = true;
      _message = null;
      _errorMessage = null;
    });

    final result = await ref.read(verifyEmailUseCaseProvider)(const NoParams());

    if (!mounted) {
      return;
    }

    result.fold((failure) {
      setState(() {
        _isResending = false;
        _errorMessage = failure.localizedMessage(l10n);
      });
    }, (_) {
      setState(() {
        _isResending = false;
        _message = l10n.emailVerificationSent;
        _resendSecondsRemaining = _resendCooldownSeconds;
      });
      _startResendCooldown();
    });
  }

  Future<void> _backToLogin() async {
    await ref.read(signOutUseCaseProvider)(const NoParams());

    if (!mounted) {
      return;
    }

    context.goNamed(RouteNames.login);
  }

  void _showSuccessAndContinue() {
    if (_isVerified || !mounted) {
      return;
    }

    _verificationTimer?.cancel();
    _cooldownTimer?.cancel();
    ref.invalidate(authStateChangesProvider);

    setState(() {
      _isChecking = false;
      _isVerified = true;
      _message = null;
      _errorMessage = null;
      _resendSecondsRemaining = 0;
    });
  }

  void _nextToHome() {
    context.goNamed(RouteNames.home);
  }

  void _startResendCooldown() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_resendSecondsRemaining <= 1) {
        timer.cancel();
        setState(() => _resendSecondsRemaining = 0);
        return;
      }

      setState(() => _resendSecondsRemaining--);
    });
  }
}
