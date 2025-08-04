// 3. 📁 data/data_source/user_data_source.dart
import 'package:kalamkart_mobileapp/app/constants/api_endpoints.dart';
import 'package:kalamkart_mobileapp/core/network/api_service.dart';

import '../model/user_model.dart';

abstract class IUserRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
}

class UserRemoteDataSource implements IUserRemoteDataSource {
  final ApiService apiService;
  UserRemoteDataSource({required this.apiService});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiService.dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response.data); // ✅ FIXED
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final response = await apiService.dio.post(
      ApiEndpoints.register,
      data: {'name': name, 'email': email, 'password': password},
    );
    return UserModel.fromJson(response.data); // ✅ FIXED
  }
}
