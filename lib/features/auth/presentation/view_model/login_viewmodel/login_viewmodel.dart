
import 'package:bloc/bloc.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/use_case/user_login_usecase.dart';

import 'login_event.dart';
import 'login_state.dart';


class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUseCase loginUseCase;

  LoginViewModel({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final result = await loginUseCase(event.email, event.password);
        emit(LoginSuccess(result));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
