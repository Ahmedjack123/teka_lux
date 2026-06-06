import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    this.emailVerified = false,
    this.phoneNumber,
    this.photoUrl,
  });

  final String uid;
  final String email;
  final String name;
  final bool emailVerified;
  final String? phoneNumber;
  final String? photoUrl;

  bool get hasPhoto => photoUrl != null && photoUrl!.trim().isNotEmpty;

  @override
  List<Object?> get props => [
        uid,
        email,
        name,
        emailVerified,
        phoneNumber,
        photoUrl,
      ];
}
