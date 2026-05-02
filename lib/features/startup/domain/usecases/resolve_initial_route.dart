import '../entities/startup_state.dart';
import 'check_first_run.dart';

class ResolveInitialRoute {
  const ResolveInitialRoute(this._checkFirstRun);

  final CheckFirstRun _checkFirstRun;

  Future<StartupDestination> call() async {
    final isFirstRun = await _checkFirstRun();
    return isFirstRun
        ? StartupDestination.onboarding
        : StartupDestination.login;
  }
}
