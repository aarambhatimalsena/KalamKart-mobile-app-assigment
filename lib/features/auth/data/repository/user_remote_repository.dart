

import 'package:kalamkart_mobileapp/features/auth/data/data_source/user_data_source.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final IUserRemoteDataSource userDataSource;

  UserRemoteRepository({required this.userDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    final userModel = await userDataSource.login(email, password);
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> register(String name, String email, String password) async {
    final userModel = await userDataSource.register(name, email, password);
    return userModel.toEntity();
  }
}
