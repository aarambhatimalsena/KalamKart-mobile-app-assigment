import 'package:kalamkart_mobileapp/features/auth/domain/repository/user_repository.dart';

class UserProfileUploadUseCase {
  final IUserRepository _repository;

  UserProfileUploadUseCase(this._repository);

  Future<String> call(String filePath) {
    return _repository.uploadProfilePicture(filePath);
  }
}
