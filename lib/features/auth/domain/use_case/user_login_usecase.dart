

import 'package:kalamkart_mobileapp/features/auth/domain/repository/user_repository.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';


class UserLoginUseCase {
  final IUserRepository repository;
  UserLoginUseCase(this.repository);

  Future<UserEntity> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
