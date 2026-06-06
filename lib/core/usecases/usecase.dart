import '../utils/result.dart';

abstract class UseCase<T, P> {
  const UseCase();

  Future<Result<T>> call(P params);
}

final class NoParams {
  const NoParams();
}
