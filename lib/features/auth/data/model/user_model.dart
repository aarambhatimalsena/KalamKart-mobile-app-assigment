

import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';

class UserModel {
  final String? id;
  final String username;
  final String email;
  final String? role;
  final String? profileImage;
  final String? token;
  final String? isFavorite;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    this.role,
    this.profileImage,
    this.token,
    this.isFavorite,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['_id'],
        username: json['name'],
        email: json['email'],
        role: json['role'],
        profileImage: json['profileImage'],
        token: json['token'], // 🟢 this is key
        isFavorite: json['isFavorite'],
      );

  UserEntity toEntity() => UserEntity(
        id: id,
        username: username,
        email: email,
        role: role,
        profileImage: profileImage,
        token: token, 
        isFavorite: isFavorite,
      );
}
