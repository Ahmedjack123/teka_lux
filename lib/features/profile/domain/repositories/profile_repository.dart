import '../../../../core/utils/result.dart';
import '../entities/address.dart';
import '../entities/user_profile.dart';

abstract interface class IProfileRepository {
  Future<Result<UserProfile?>> getProfile();
  Future<Result<void>> updateProfile({
    required String name,
    String? phoneNumber,
    String? photoUrl,
  });
  Future<Result<List<Address>>> getAddresses();
  Future<Result<void>> saveAddress(Address address);
  Future<Result<void>> deleteAddress(String id);
}
