import 'package:rice_delivery/core/entities/user_entity.dart';

class AuthResultEntity {
  const AuthResultEntity._({
    required this.isSuccess,
    this.user,
    this.token,
    this.error,
  });

  factory AuthResultEntity.success({UserEntity? user, String? token}) =>
      AuthResultEntity._(isSuccess: true, user: user, token: token);

  factory AuthResultEntity.failure(String error) =>
      AuthResultEntity._(isSuccess: false, error: error);

  final bool isSuccess;
  final UserEntity? user;
  final String? token;
  final String? error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResultEntity &&
        other.isSuccess == isSuccess &&
        other.user == user &&
        other.token == token &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(isSuccess, user, token, error);
  }
}
