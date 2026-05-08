import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/router/route_names.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _AuthRouteRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return AppRouter.build(
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateChangesProvider);
      final location = state.matchedLocation;

      if (authState is! AsyncData<UserEntity?>) {
        return null;
      }

      final user = authState.value;

      if (location == RouteNames.homePath && user == null) {
        return RouteNames.loginPath;
      }

      if (location == RouteNames.homePath && user?.emailVerified == false) {
        return RouteNames.verifyEmailPath;
      }

      return null;
    },
  );
});

final class _AuthRouteRefreshNotifier extends ChangeNotifier {
  _AuthRouteRefreshNotifier(Ref ref) {
    _subscription = ref.listen<AsyncValue<UserEntity?>>(
      authStateChangesProvider,
      (previous, next) => notifyListeners(),
      fireImmediately: true,
    );
  }

  late final ProviderSubscription<AsyncValue<UserEntity?>> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
