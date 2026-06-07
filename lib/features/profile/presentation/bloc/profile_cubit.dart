import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/usecases/logout.dart';
import '../../../auth/presentation/bloc/auth_session_cubit.dart';
import '../../domain/entities/address.dart';
import '../../domain/usecases/delete_address.dart';
import '../../domain/usecases/get_addresses.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/save_address.dart';
import '../../domain/usecases/update_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required GetProfileUseCase getProfile,
    required UpdateProfileUseCase updateProfile,
    required GetAddressesUseCase getAddresses,
    required SaveAddressUseCase saveAddress,
    required DeleteAddressUseCase deleteAddress,
    required SignOutUseCase signOut,
    required AuthSessionCubit authSessionCubit,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        _getAddresses = getAddresses,
        _saveAddress = saveAddress,
        _deleteAddress = deleteAddress,
        _signOut = signOut,
        _authSessionCubit = authSessionCubit,
        super(const ProfileState());

  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;
  final GetAddressesUseCase _getAddresses;
  final SaveAddressUseCase _saveAddress;
  final DeleteAddressUseCase _deleteAddress;
  final SignOutUseCase _signOut;
  final AuthSessionCubit _authSessionCubit;

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getProfile(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: _failureMessage(failure, 'Failed to load profile'),
      )),
      (profile) => emit(state.copyWith(
        isLoading: false,
        profile: profile,
      )),
    );
  }

  Future<void> updateProfile({
    required String name,
    String? phoneNumber,
  }) async {
    emit(state.copyWith(isSaving: true, errorMessage: null));

    final result = await _updateProfile(
      UpdateProfileParams(name: name, phoneNumber: phoneNumber),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        errorMessage: _failureMessage(failure, 'Failed to update profile'),
      )),
      (_) => emit(state.copyWith(isSaving: false)),
    );
  }

  Future<void> loadAddresses() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getAddresses(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: _failureMessage(failure, 'Failed to load addresses'),
      )),
      (addresses) => emit(state.copyWith(
        isLoading: false,
        addresses: addresses,
      )),
    );
  }

  Future<void> addAddress(Address address) async {
    emit(state.copyWith(isSaving: true, errorMessage: null));

    final result = await _saveAddress(address);

    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        errorMessage: _failureMessage(failure, 'Failed to save address'),
      )),
      (_) => emit(state.copyWith(isSaving: false)),
    );

    await loadAddresses();
  }

  Future<void> removeAddress(String id) async {
    emit(state.copyWith(isSaving: true, errorMessage: null));

    final result = await _deleteAddress(id);

    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        errorMessage: _failureMessage(failure, 'Failed to delete address'),
      )),
      (_) => emit(state.copyWith(isSaving: false)),
    );

    await loadAddresses();
  }

  Future<void> signOut() async {
    if (state.isSigningOut) {
      return;
    }

    emit(state.copyWith(signOutStatus: ProfileSignOutStatus.signingOut));

    final result = await _signOut(const NoParams());

    await result.fold((_) async {
      emit(state.copyWith(signOutStatus: ProfileSignOutStatus.failure));
    }, (_) async {
      await _authSessionCubit.refresh();
      emit(state.copyWith(signOutStatus: ProfileSignOutStatus.signedOut));
    });
  }

  String _failureMessage(Failure failure, String fallback) {
    if (failure is AuthFailure) {
      return failure.debugMessage ?? fallback;
    }
    return fallback;
  }
}
