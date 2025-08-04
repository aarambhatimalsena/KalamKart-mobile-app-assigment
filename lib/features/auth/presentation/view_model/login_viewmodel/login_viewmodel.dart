import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/login_viewmodel/login_event.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/login_viewmodel/login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUseCase loginUseCase;

  LoginViewModel({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final user = await loginUseCase(event.email, event.password);
        emit(LoginSuccess(user: user, message: "Welcome ${user.username}"));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
