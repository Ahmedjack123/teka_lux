import 'package:firebase_auth/firebase_auth.dart';

import 'user_entity.dart';

final class UserModel {
  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.emailVerified,
    this.phoneNumber,
    this.photoUrl,
  });

  factory UserModel.fromFirebaseUser(User user) {
    final email = user.email ?? '';

    return UserModel(
      uid: user.uid,
      email: email,
      name: user.displayName?.trim().isNotEmpty == true
          ? user.displayName!.trim()
          : _nameFromEmail(email),
      emailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoURL,
    );
  }

  final String uid;
  final String email;
  final String name;
  final bool emailVerified;
  final String? phoneNumber;
  final String? photoUrl;

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
      'emailVerified': emailVerified,
      'photoUrl': photoUrl,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      name: name,
      emailVerified: emailVerified,
      phoneNumber: phoneNumber,
      photoUrl: photoUrl,
    );
  }

  static String _nameFromEmail(String email) {
    final fallback = email.split('@').first.trim();
    return fallback;
  }
}
