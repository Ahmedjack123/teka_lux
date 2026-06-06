class UserProfile {
  const UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.photoUrl,
    this.emailVerified = false,
  });

  final String uid;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? photoUrl;
  final bool emailVerified;

  bool get hasPhoto => photoUrl != null && photoUrl!.trim().isNotEmpty;

  UserProfile copyWith({
    String? uid,
    String? email,
    String? name,
    String? phoneNumber,
    String? photoUrl,
    bool? emailVerified,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}
