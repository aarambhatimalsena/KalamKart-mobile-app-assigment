// domain/repository/user_repository.dart
import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';

abstract class IUserRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String name, String email, String password);
}
