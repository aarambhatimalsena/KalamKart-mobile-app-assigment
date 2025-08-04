// 📄 login_state.dart
import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user;
  final String message;

  LoginSuccess({required this.user, required this.message});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}
