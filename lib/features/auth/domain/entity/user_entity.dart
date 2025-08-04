
class UserEntity {
  final String? id;
  final String username;
  final String email;
  final String? password;
  final String? role;
  final String? profileImage;
  final String? token;
  final String? isFavorite;

  UserEntity({
    this.id,
    required this.username,
    required this.email,
    this.password,
    this.role,
    this.profileImage,
    this.token,
    this.isFavorite,
  });
}
