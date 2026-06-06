import 'package:flutter_test/flutter_test.dart';
import 'package:teka_luxe/core/errors/auth_error_code.dart';
import 'package:teka_luxe/core/errors/failures.dart';
import 'package:teka_luxe/core/utils/result.dart';

void main() {
  group('Result<T>', () {
    const testData = 'success data';
    const failure = AuthFailure(errorCode: AuthErrorCode.unknown);

    group('Success', () {
      test('should hold data', () {
        const result = Result<String>.success(testData);
        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
        expect(result.dataOrNull, equals(testData));
        expect(result.failureOrNull, isNull);
      });

      test('fold should call onSuccess', () {
        const result = Result<String>.success(testData);
        final value = result.fold(
          (f) => 'failure',
          (d) => d,
        );
        expect(value, equals(testData));
      });
    });

    group('FailureResult', () {
      test('should hold failure', () {
        const result = Result<String>.failure(failure);
        expect(result.isSuccess, isFalse);
        expect(result.isFailure, isTrue);
        expect(result.dataOrNull, isNull);
        expect(result.failureOrNull, equals(failure));
      });

      test('fold should call onFailure', () {
        const result = Result<String>.failure(failure);
        final value = result.fold(
          (f) => 'failure',
          (d) => 'success',
        );
        expect(value, equals('failure'));
      });
    });

    group('null safety', () {
      test('Success with null data should work', () {
        const result = Result<String?>.success(null);
        expect(result.dataOrNull, isNull);
        expect(result.isSuccess, isTrue);
      });

      test('chained operations should work correctly', () {
        const success = Result<int>.success(42);
        final mapped = success.fold(
          (f) => 0,
          (d) => d * 2,
        );
        expect(mapped, equals(84));
      });
    });
  });
}
