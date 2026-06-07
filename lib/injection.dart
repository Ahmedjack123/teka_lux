import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/check_email_verified.dart';
import 'features/auth/domain/usecases/forgot_password.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/register.dart';
import 'features/auth/domain/usecases/sign_in_with_google.dart';
import 'features/auth/domain/usecases/verify_email.dart';
import 'features/auth/presentation/bloc/auth_session_cubit.dart';
import 'features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'features/auth/presentation/bloc/login/login_cubit.dart';
import 'features/auth/presentation/bloc/register/register_cubit.dart';
import 'features/auth/presentation/bloc/verify_email_cubit.dart';
import 'features/home/presentation/bloc/home_cubit.dart';
import 'features/orders/data/datasources/orders_remote_datasource.dart';
import 'features/orders/data/repositories/orders_repository_impl.dart';
import 'features/orders/domain/repositories/orders_repository.dart';
import 'features/orders/domain/usecases/get_order_detail.dart';
import 'features/orders/domain/usecases/get_order_history.dart';
import 'features/orders/domain/usecases/place_order.dart';
import 'features/orders/presentation/bloc/orders_cubit.dart';
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/delete_address.dart';
import 'features/profile/domain/usecases/get_addresses.dart';
import 'features/profile/domain/usecases/get_profile.dart';
import 'features/profile/domain/usecases/save_address.dart';
import 'features/profile/domain/usecases/update_profile.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';
import 'features/search/domain/usecases/search_products.dart';
import 'features/search/presentation/bloc/search_cubit.dart';
import 'features/startup/data/datasources/startup_local_datasource.dart';
import 'features/startup/data/repositories/startup_repository_impl.dart';
import 'features/startup/domain/repositories/startup_repository.dart';
import 'features/startup/domain/usecases/check_first_run.dart';
import 'features/startup/domain/usecases/complete_onboarding.dart';
import 'features/startup/domain/usecases/resolve_initial_route.dart';
import 'features/startup/presentation/bloc/onboarding_cubit.dart';
import 'features/startup/presentation/bloc/startup_cubit.dart';
import 'shared/services/local_storage_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Core / External ──
  final preferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(preferences),
  );

  sl.registerLazySingleton<NetworkInfo>(
    () => ConnectivityNetworkInfo(Connectivity()),
  );

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);

  final supabaseClient =
      SupabaseConfig.isConfigured ? Supabase.instance.client : null;

  // ── Auth Data Layer ──
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => FirebaseAuthRemoteDatasource(
      firebaseAuth: sl(),
      supabaseClient: supabaseClient,
      networkInfo: sl(),
      googleSignIn: sl(),
    ),
  );

  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // ── Auth Domain Layer (Use Cases) ──
  sl.registerFactory(() => LoginUseCase(sl()));
  sl.registerFactory(() => RegisterUseCase(sl()));
  sl.registerFactory(() => SignInWithGoogleUseCase(sl()));
  sl.registerFactory(() => ResetPasswordUseCase(sl()));
  sl.registerFactory(() => VerifyEmailUseCase(sl()));
  sl.registerFactory(() => CheckEmailVerifiedUseCase(sl()));
  sl.registerFactory(() => SignOutUseCase(sl()));
  sl.registerFactory(() => GetCurrentUserUseCase(sl()));

  // ── Auth Presentation Layer ──
  sl.registerLazySingleton(
    () => AuthSessionCubit(sl())..start(),
  );

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

  // ── Profile ──
  sl.registerLazySingleton<ProfileRemoteDatasource>(
    () => SupabaseProfileRemoteDatasource(
      supabaseClient: supabaseClient,
      firebaseAuth: sl(),
    ),
  );
  sl.registerLazySingleton<IProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerFactory(() => GetProfileUseCase(sl()));
  sl.registerFactory(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(() => GetAddressesUseCase(sl()));
  sl.registerFactory(() => SaveAddressUseCase(sl()));
  sl.registerFactory(() => DeleteAddressUseCase(sl()));
  sl.registerFactory(
    () => ProfileCubit(
      getProfile: sl(),
      updateProfile: sl(),
      getAddresses: sl(),
      saveAddress: sl(),
      deleteAddress: sl(),
      signOut: sl(),
      authSessionCubit: sl(),
    ),
  );

  // ── Orders ──
  sl.registerLazySingleton<OrdersRemoteDatasource>(
    () => SupabaseOrdersRemoteDatasource(
      supabaseClient: supabaseClient!,
      firebaseAuth: sl(),
    ),
  );
  sl.registerLazySingleton<IOrdersRepository>(
    () => OrdersRepositoryImpl(sl()),
  );
  sl.registerFactory(() => GetOrderHistoryUseCase(sl()));
  sl.registerFactory(() => GetOrderDetailUseCase(sl()));
  sl.registerFactory(() => PlaceOrderUseCase(sl()));
  sl.registerFactory(
    () => OrdersCubit(
      getOrderHistory: sl(),
      getOrderDetail: sl(),
      placeOrder: sl(),
    ),
  );

  // ── Search ──
  sl.registerFactory(() => SearchProductsUseCase());
  sl.registerFactory(
    () => SearchCubit(
      searchProducts: sl(),
      localStorage: sl(),
    ),
  );
}
