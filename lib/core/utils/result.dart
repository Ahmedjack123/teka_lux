import '../errors/failures.dart';

sealed class Result<T> {
  const Result._();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = FailureResult<T>;

  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess);

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  T? get dataOrNull => fold((_) => null, (data) => data);
  Failure? get failureOrNull => fold((failure) => failure, (_) => null);
}

final class Success<T> extends Result<T> {
  const Success(this.data) : super._();

  final T data;

  @override
  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    return onSuccess(data);
  }
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure) : super._();

  final Failure failure;

  @override
  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    return onFailure(failure);
  }
}
