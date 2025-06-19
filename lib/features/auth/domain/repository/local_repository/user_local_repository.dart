import 'package:kalamkart_mobileapp/features/auth/data/data_source/user_data_source.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final IUserDataSource _userDataSource;

  UserLocalRepository({required IUserDataSource userDataSource})
      : _userDataSource = userDataSource;

  @override
  Future<String> loginUser(String email, String password) {
    return _userDataSource.loginUser(email, password);
  }

  @override
  Future<void> registerUser(UserEntity user) {
    return _userDataSource.registerUser(user);
  }

  @override
  Future<UserEntity> getCurrentUser() {
    return _userDataSource.getCurrentUser();
  }

  @override
  Future<String> uploadProfilePicture(String filePath) {
    return _userDataSource.uploadProfilePicture(filePath);
  }
}
