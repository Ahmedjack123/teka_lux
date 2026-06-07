import '../../domain/entities/address.dart';
import '../../domain/entities/user_profile.dart';

enum ProfileSignOutStatus {
  idle,
  signingOut,
  signedOut,
  failure,
}

class ProfileState {
  const ProfileState({
    this.profile,
    this.addresses = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.signOutStatus = ProfileSignOutStatus.idle,
  });

  final UserProfile? profile;
  final List<Address> addresses;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final ProfileSignOutStatus signOutStatus;

  bool get isSigningOut => signOutStatus == ProfileSignOutStatus.signingOut;

  ProfileState copyWith({
    Object? profile = _unset,
    List<Address>? addresses,
    bool? isLoading,
    bool? isSaving,
    Object? errorMessage = _unset,
    ProfileSignOutStatus? signOutStatus,
  }) {
    return ProfileState(
      profile: profile == _unset ? this.profile : profile as UserProfile?,
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
      signOutStatus: signOutStatus ?? this.signOutStatus,
    );
  }

  static const Object _unset = Object();
}
