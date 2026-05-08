import 'user.dart';

class AuthSession {
  const AuthSession({
    required this.user,
    required this.isEmailVerified,
  });

  final UserEntity user;
  final bool isEmailVerified;
}
