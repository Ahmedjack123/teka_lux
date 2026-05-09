import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../domain/entities/user.dart';

final class UserModel {
  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.emailVerified,
    this.phoneNumber,
    this.photoUrl,
  });

  factory UserModel.fromSupabaseUser(
    supabase.User user, {
    String? nameOverride,
    String? phoneNumberOverride,
  }) {
    final email = user.email ?? '';
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    final metadataName = metadata['full_name'] ?? metadata['name'];
    final metadataPhone = metadata['phone_number'];
    final metadataPhoto =
        metadata['avatar_url'] ?? metadata['picture'] ?? metadata['photo_url'];

    return UserModel(
      uid: user.id,
      email: email,
      name: _firstNonEmpty([nameOverride, metadataName, _nameFromEmail(email)]),
      emailVerified: user.emailConfirmedAt != null,
      phoneNumber: _firstNullableNonEmpty([phoneNumberOverride, metadataPhone]),
      photoUrl: _firstNullableNonEmpty([metadataPhoto]),
    );
  }

  factory UserModel.pendingEmailVerification({
    required String email,
    String? name,
    String? phoneNumber,
  }) {
    return UserModel(
      uid: email.trim().toLowerCase(),
      email: email.trim().toLowerCase(),
      name: name?.trim().isNotEmpty == true
          ? name!.trim()
          : _nameFromEmail(email),
      emailVerified: false,
      phoneNumber: phoneNumber,
    );
  }

  final String uid;
  final String email;
  final String name;
  final bool emailVerified;
  final String? phoneNumber;
  final String? photoUrl;

  Map<String, dynamic> toSupabaseProfile({
    String role = 'customer',
  }) {
    return <String, dynamic>{
      'id': uid,
      'email': email.trim().toLowerCase(),
      'full_name': name.trim(),
      if (phoneNumber?.trim().isNotEmpty ?? false)
        'phone_number': phoneNumber!.trim(),
      'role': role,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
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

  static String _firstNonEmpty(List<Object?> values) {
    for (final value in values) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }

    return '';
  }

  static String? _firstNullableNonEmpty(List<Object?> values) {
    for (final value in values) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }

    return null;
  }
}
