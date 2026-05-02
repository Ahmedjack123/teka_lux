import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/storage_provider.dart';
import '../../data/datasources/startup_local_datasource.dart';
import '../../data/repositories/startup_repository_impl.dart';
import '../../domain/entities/startup_state.dart';
import '../../domain/repositories/startup_repository.dart';
import '../../domain/usecases/check_first_run.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/resolve_initial_route.dart';

final startupLocalDatasourceProvider =
    FutureProvider<StartupLocalDatasource>((ref) async {
  final storage = await ref.watch(localStorageServiceProvider.future);
  return StartupLocalDatasource(storage);
});

final startupRepositoryProvider =
    FutureProvider<StartupRepository>((ref) async {
  final datasource = await ref.watch(startupLocalDatasourceProvider.future);
  return StartupRepositoryImpl(datasource);
});

final startupDestinationProvider = FutureProvider<StartupDestination>((
  ref,
) async {
  final repository = await ref.watch(startupRepositoryProvider.future);
  return ResolveInitialRoute(CheckFirstRun(repository))();
});

final completeOnboardingUsecaseProvider =
    FutureProvider<CompleteOnboarding>((ref) async {
  final repository = await ref.watch(startupRepositoryProvider.future);
  return CompleteOnboarding(repository);
});
