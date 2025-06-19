import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/repository/user_repository.dart';

class UserGetCurrentUserUseCase {
  final IUserRepository _repository;

  UserGetCurrentUserUseCase(this._repository);

  Future<UserEntity> call() {
    return _repository.getCurrentUser();
  }
}
