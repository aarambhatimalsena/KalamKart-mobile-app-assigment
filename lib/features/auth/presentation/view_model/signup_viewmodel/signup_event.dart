import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';



abstract class SignupEvent {}
class SignupSubmitted extends SignupEvent {
  final UserEntity user;
  SignupSubmitted(this.user);
}