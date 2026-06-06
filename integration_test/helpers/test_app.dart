import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:teka_luxe/app.dart';
import 'package:teka_luxe/core/network/network_info.dart';
import 'package:teka_luxe/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:teka_luxe/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:teka_luxe/features/auth/domain/repositories/auth_repository.dart';
import 'package:teka_luxe/features/auth/domain/usecases/check_email_verified.dart';
import 'package:teka_luxe/features/auth/domain/usecases/forgot_password.dart';
import 'package:teka_luxe/features/auth/domain/usecases/get_current_user.dart';
import 'package:teka_luxe/features/auth/domain/usecases/login.dart';
import 'package:teka_luxe/features/auth/domain/usecases/logout.dart';
import 'package:teka_luxe/features/auth/domain/usecases/register.dart';
import 'package:teka_luxe/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:teka_luxe/features/auth/domain/usecases/verify_email.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/register/register_cubit.dart';
import 'package:teka_luxe/features/auth/presentation/bloc/verify_email_cubit.dart';
import 'package:teka_luxe/features/home/presentation/bloc/home_cubit.dart';
import 'package:teka_luxe/features/startup/data/datasources/startup_local_datasource.dart';
import 'package:teka_luxe/features/startup/data/repositories/startup_repository_impl.dart';
import 'package:teka_luxe/features/startup/domain/repositories/startup_repository.dart';
import 'package:teka_luxe/features/startup/domain/usecases/check_first_run.dart';
import 'package:teka_luxe/features/startup/domain/usecases/complete_onboarding.dart';
import 'package:teka_luxe/features/startup/domain/usecases/resolve_initial_route.dart';
import 'package:teka_luxe/features/startup/presentation/bloc/onboarding_cubit.dart';
import 'package:teka_luxe/features/startup/presentation/bloc/startup_cubit.dart';
import 'package:teka_luxe/injection.dart';
import 'package:teka_luxe/shared/services/local_storage_service.dart';

import '../mocks/mock_auth_remote_datasource.dart';

/// A fake [NetworkInfo] that always reports connected.
class _AlwaysConnectedNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;

  @override
  Stream<bool> get onConnectivityChanged =>
      Stream<bool>.periodic(const Duration(seconds: 5), (_) => true);
}

/// Bootstraps the app for integration testing with a mocked auth layer.
///
/// Call this instead of [main] in integration tests. It bypasses
/// Firebase / Supabase initialization and wires a [MockAuthRemoteDatasource]
/// into GetIt so the full UI stack runs against in-memory auth.
///
/// Returns the [MockAuthRemoteDatasource] so tests can inspect / control state.
Future<MockAuthRemoteDatasource> bootstrapTestApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  final mockDatasource = MockAuthRemoteDatasource();

  // ── Clear any prior registrations ──
  await sl.reset();

  // ── Core / External ──
  final preferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(preferences),
  );

  sl.registerLazySingleton<NetworkInfo>(() => _AlwaysConnectedNetworkInfo());

  // ── Auth Data Layer (mocked) ──
  sl.registerLazySingleton<AuthRemoteDatasource>(() => mockDatasource);

  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // ── Auth Domain Layer ──
  sl.registerFactory(() => LoginUseCase(sl()));
  sl.registerFactory(() => RegisterUseCase(sl()));
  sl.registerFactory(() => SignInWithGoogleUseCase(sl()));
  sl.registerFactory(() => ResetPasswordUseCase(sl()));
  sl.registerFactory(() => VerifyEmailUseCase(sl()));
  sl.registerFactory(() => CheckEmailVerifiedUseCase(sl()));
  sl.registerFactory(() => SignOutUseCase(sl()));
  sl.registerFactory(() => GetCurrentUserUseCase(sl()));

  // ── Auth Presentation Layer ──
  sl.registerLazySingleton(() => AuthSessionCubit(sl())..start());

  sl.registerFactory(
    () => LoginCubit(
      localStorage: sl(),
      login: sl(),
      signInWithGoogle: sl(),
    ),
  );

  sl.registerFactory(
    () => RegisterCubit(
      register: sl(),
      signInWithGoogle: sl(),
    ),
  );

  sl.registerFactory(() => ForgotPasswordCubit(sl()));

  sl.registerFactory(
    () => VerifyEmailCubit(
      verifyEmail: sl(),
      checkEmailVerified: sl(),
      signOut: sl(),
      authSessionCubit: sl(),
    ),
  );

  // ── Startup ──
  sl.registerLazySingleton<StartupRepository>(
    () => StartupRepositoryImpl(StartupLocalDatasource(sl())),
  );

  sl.registerFactory(() => CheckFirstRun(sl()));
  sl.registerFactory(() => CompleteOnboarding(sl()));
  sl.registerFactory(() => ResolveInitialRoute(sl()));

  sl.registerFactory(() => StartupCubit(sl()));
  sl.registerFactory(() => OnboardingCubit(sl()));

  // ── Home ──
  sl.registerFactory(
    () => HomeCubit(
      signOut: sl(),
      authSessionCubit: sl(),
    ),
  );

  return mockDatasource;
}

/// Runs the app with the mocked dependencies already registered.
/// Call [bootstrapTestApp] first.
void runTestApp() {
  runApp(const MyApp());
}
