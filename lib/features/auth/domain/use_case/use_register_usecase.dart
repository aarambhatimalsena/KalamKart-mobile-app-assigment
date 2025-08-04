



import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/repository/user_repository.dart';



class UserRegisterUseCase {
  final IUserRepository repository;
  UserRegisterUseCase(this.repository);

  Future<UserEntity> call(String name, String email, String password) async {
    return await repository.register(name, email, password);
  }
}
