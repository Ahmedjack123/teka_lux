import '../../../../core/errors/auth_error_code.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

final class ProfileRepositoryImpl implements IProfileRepository {
  const ProfileRepositoryImpl(this._remoteDatasource);

  final ProfileRemoteDatasource _remoteDatasource;

  @override
  Future<Result<UserProfile?>> getProfile() {
    return _guard(() async {
      final data = await _remoteDatasource.getProfile();
      if (data == null) return null;
      return _mapToUserProfile(data);
    });
  }

  @override
  Future<Result<void>> updateProfile({
    required String name,
    String? phoneNumber,
    String? photoUrl,
  }) {
    return _guard(() async {
      final data = await _remoteDatasource.getProfile();
      final uid = data?['id'] as String?;
      if (uid == null) {
        throw const AuthException(
          errorCode: AuthErrorCode.userNotFound,
          firebaseCode: 'user-not-found',
        );
      }

      final payload = <String, dynamic>{
        'full_name': name.trim(),
      };

      if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
        payload['phone_number'] = phoneNumber.trim();
      }

      if (photoUrl != null && photoUrl.trim().isNotEmpty) {
        payload['photo_url'] = photoUrl.trim();
      }

      await _remoteDatasource.updateProfile(uid, payload);
    });
  }

  @override
  Future<Result<List<Address>>> getAddresses() {
    return _guard(() async {
      final data = await _remoteDatasource.getProfile();
      final uid = data?['id'] as String?;
      if (uid == null) return <Address>[];

      final rows = await _remoteDatasource.getAddresses(uid);
      return rows.map(_mapToAddress).toList();
    });
  }

  @override
  Future<Result<void>> saveAddress(Address address) {
    return _guard(() async {
      final data = await _remoteDatasource.getProfile();
      final uid = data?['id'] as String?;
      if (uid == null) {
        throw const AuthException(
          errorCode: AuthErrorCode.userNotFound,
          firebaseCode: 'user-not-found',
        );
      }

      await _remoteDatasource.saveAddress(uid, {
        'id': address.id,
        'label': address.label,
        'street': address.street,
        'city': address.city,
        'state': address.state,
        'country': address.country,
        'postal_code': address.postalCode,
        'is_default': address.isDefault,
      });
    });
  }

  @override
  Future<Result<void>> deleteAddress(String id) {
    return _guard(() => _remoteDatasource.deleteAddress(id));
  }

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Result<T>.success(await action());
    } on AuthException catch (exception) {
      return Result<T>.failure(exception.toFailure());
    } catch (exception, stackTrace) {
      return Result<T>.failure(
        AuthFailure(
          errorCode: AuthErrorCode.unknown,
          debugMessage: exception.toString(),
          cause: exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  UserProfile _mapToUserProfile(Map<String, dynamic> data) {
    return UserProfile(
      uid: data['id'] as String? ?? '',
      email: data['email'] as String? ?? '',
      name: data['full_name'] as String? ?? '',
      phoneNumber: data['phone_number'] as String?,
      photoUrl: data['photo_url'] as String?,
      emailVerified: data['email_verified'] as bool? ?? false,
    );
  }

  Address _mapToAddress(Map<String, dynamic> data) {
    return Address(
      id: data['id'] as String? ?? '',
      label: data['label'] as String? ?? '',
      street: data['street'] as String? ?? '',
      city: data['city'] as String? ?? '',
      state: data['state'] as String?,
      country: data['country'] as String? ?? '',
      postalCode: data['postal_code'] as String?,
      isDefault: data['is_default'] as bool? ?? false,
    );
  }
}
