import '../utils/result.dart';

abstract class UseCase<Output, Params> {
  const UseCase();

  Future<Result<Output>> call(Params params);
}

final class NoParams {
  const NoParams();
}
