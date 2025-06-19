import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/repository/user_repository.dart';

class UserRegisterUseCase {
  final IUserRepository _repository;

  UserRegisterUseCase(this._repository);

  Future<void> call(UserEntity user) {
    return _repository.registerUser(user);
  }
}
