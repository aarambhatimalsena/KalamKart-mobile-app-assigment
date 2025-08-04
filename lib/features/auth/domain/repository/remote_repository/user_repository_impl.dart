



import 'package:kalamkart_mobileapp/features/auth/data/data_source/user_data_source.dart';
import 'package:kalamkart_mobileapp/features/auth/data/repository/user_repository.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';

class UserRepositoryImpl implements IUserRepository {
  final IUserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> register(String name, String email, String password) async {
    final userModel = await remoteDataSource.register(name, email, password);
    return userModel.toEntity();
  }
  
  @override
  Future<UserEntity> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
  
  @override
  Future<String> loginUser(String email, String password) {
    // TODO: implement loginUser
    throw UnimplementedError();
  }
  
  @override
  Future<void> registerUser(UserEntity user) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
  
  @override
  Future<String> uploadProfilePicture(String filePath) {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }
}