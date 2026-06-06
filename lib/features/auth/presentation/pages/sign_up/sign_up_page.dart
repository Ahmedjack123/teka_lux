import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';
import '../../../../../injection.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../bloc/register/register_cubit.dart';
import '../../bloc/register/register_state.dart';
import 'widgets/sign_up_scaffold.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  // Local field values — only sync to cubit on submit
  String _name = '';
  String _phoneNumber = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onNameChanged(String value) => _name = value;
  void _onPhoneChanged(String value) => _phoneNumber = value;
  void _onEmailChanged(String value) => _email = value;
  void _onPasswordChanged(String value) => _password = value;
  void _onConfirmChanged(String value) => _confirmPassword = value;

  void _syncFieldsToCubit(AppLocalizations l10n) {
    final cubit = context.read<RegisterCubit>();
    cubit.nameChanged(_name, l10n);
    cubit.phoneNumberChanged(_phoneNumber, l10n);
    cubit.emailChanged(_email, l10n);
    cubit.passwordChanged(_password, l10n);
    cubit.confirmPasswordChanged(_confirmPassword, l10n);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (prev, curr) =>
          prev.isSubmitting != curr.isSubmitting ||
          prev.isGoogleSubmitting != curr.isGoogleSubmitting ||
          prev.errorMessage != curr.errorMessage ||
          (curr.hasSubmitted && prev.hasSubmitted != curr.hasSubmitted),
      listener: (context, state) {
        // Navigate on success
        if (!state.isSubmitting && state.errorMessage == null && state.hasSubmitted) {
          // Check if we should navigate (submit returned true)
        }
      },
      child: BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (prev, curr) =>
            prev.isSubmitting != curr.isSubmitting ||
            prev.isGoogleSubmitting != curr.isGoogleSubmitting ||
            prev.errorMessage != curr.errorMessage ||
            prev.nameError != curr.nameError ||
            prev.phoneNumberError != curr.phoneNumberError ||
            prev.emailError != curr.emailError ||
            prev.passwordError != curr.passwordError ||
            prev.confirmPasswordError != curr.confirmPasswordError ||
            prev.termsError != curr.termsError ||
            prev.acceptedTerms != curr.acceptedTerms ||
            prev.hasSubmitted != curr.hasSubmitted,
        builder: (context, state) {
          return SignUpScaffold(
            nameController: _nameController,
            phoneNumberController: _phoneNumberController,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            nameError: state.nameError,
            phoneNumberError: state.phoneNumberError,
            emailError: state.emailError,
            passwordError: state.passwordError,
            confirmPasswordError: state.confirmPasswordError,
            errorMessage: state.errorMessage,
            isSubmitting: state.isSubmitting,
            isGoogleSubmitting: state.isGoogleSubmitting,
            acceptedTerms: state.acceptedTerms,
            termsError: state.termsError,
            onNameChanged: _onNameChanged,
            onPhoneNumberChanged: _onPhoneChanged,
            onEmailChanged: _onEmailChanged,
            onPasswordChanged: _onPasswordChanged,
            onConfirmPasswordChanged: _onConfirmChanged,
            onTermsChanged: (value) {
              context.read<RegisterCubit>().termsChanged(value, l10n);
            },
            onCreateAccount: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              _syncFieldsToCubit(l10n);
              final cubit = context.read<RegisterCubit>();
              final completed = await cubit.submit(l10n);
              if (!context.mounted || !completed) return;
              context.goNamed(RouteNames.verifyEmail, extra: true);
            },
            onGoogleSignIn: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final completed =
                  await context.read<RegisterCubit>().signInWithGoogle(l10n);
              if (!context.mounted || !completed) return;
              context.goNamed(RouteNames.profile);
            },
            onSignIn: () {
              FocusManager.instance.primaryFocus?.unfocus();
              context.goNamed(RouteNames.login);
            },
          );
        },
      ),
    );
  }
}
