import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';

abstract class IUserDataSource {
  Future<String> loginUser(String email, String password);
  Future<void> registerUser(UserEntity user);
  Future<UserEntity> getCurrentUser();
  Future<String> uploadProfilePicture(String filePath);
}
