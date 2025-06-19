import 'package:hive/hive.dart';
import 'package:kalamkart_mobileapp/features/auth/data/model/user_hive_model.dart';

class HiveService {
  static const String _userBoxName = 'userBox';

  /// Register a new user into Hive
  Future<void> register(UserHiveModel user) async {
    final box = await Hive.openBox<UserHiveModel>(_userBoxName);
    await box.add(user);
  }

  /// Login: Match user by email and password
  Future<UserHiveModel?> login(String email, String password) async {
    final box = await Hive.openBox<UserHiveModel>(_userBoxName);
    final users = box.values.toList();

    for (final user in users) {
      if (user.email == email && user.password == password) {
        return user;
      }
    }

    return null;
  }

  /// Get all users
  Future<List<UserHiveModel>> getAllUsers() async {
    final box = await Hive.openBox<UserHiveModel>(_userBoxName);
    return box.values.toList();
  }

  /// Clear all user data (for logout or dev purposes)
  Future<void> clearBox() async {
    final box = await Hive.openBox<UserHiveModel>(_userBoxName);
    await box.clear();
  }

  /// Delete a specific user at index (optional)
  Future<void> deleteUserAt(int index) async {
    final box = await Hive.openBox<UserHiveModel>(_userBoxName);
    await box.deleteAt(index);
  }
}
