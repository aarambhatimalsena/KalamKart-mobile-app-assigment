// lib/features/auth/data/data_source/local_datasource/user_hive_data_source.dart

import 'package:kalamkart_mobileapp/core/network/hive_service.dart';
import 'package:kalamkart_mobileapp/features/auth/data/data_source/user_data_source.dart';
import 'package:kalamkart_mobileapp/features/auth/data/model/user_hive_model.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';

class UserHiveDataSource implements IUserDataSource {
  final HiveService _hiveService;

  UserHiveDataSource({required HiveService hiveService}) 
      : _hiveService = hiveService;

  @override
  Future<String> loginUser(String email, String password) async {
    final userData = await _hiveService.login(email, password);
    if (userData != null && userData.password == password) {
      return "Login successful";
    } else {
      throw Exception("Invalid email or password");
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    final userModel = UserHiveModel.fromEntity(user);
    await _hiveService.register(userModel);
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final users = await _hiveService.getAllUsers();
    if (users.isNotEmpty) {
      return users.first.toEntity();
    } else {
      throw Exception("No user found");
    }
  }

  @override
  Future<String> uploadProfilePicture(String filePath) async {
    // Optional if you want to upload to remote later
    throw UnimplementedError("Upload not implemented");
  }
}
