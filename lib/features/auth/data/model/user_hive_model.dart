import 'package:hive/hive.dart';
import 'package:kalamkart_mobileapp/app/constants/hive_table_constant.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';


part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  UserHiveModel({
    required this.username,
    required this.email,
    required this.password,
  });

  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      username: entity.username,
      email: entity.email,
      password: entity.password,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      username: username,
      email: email,
      password: password,
    );
  }
}
