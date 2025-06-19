import 'package:kalamkart_mobileapp/features/auth/domain/repository/user_repository.dart';

class UserLoginUseCase {
  final IUserRepository _repository;

  UserLoginUseCase(this._repository);

  Future<String> call(String email, String password) {
    return _repository.loginUser(email, password);
  }
}
