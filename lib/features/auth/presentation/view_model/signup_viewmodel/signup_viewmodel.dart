import 'package:bloc/bloc.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/use_case/user_register_usecase.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  final UserRegisterUseCase registerUseCase;

  SignupViewModel({required this.registerUseCase}) : super(SignupInitial()) {
    on<SignupSubmitted>((event, emit) async {
      emit(SignupLoading());
      try {
        await registerUseCase(event.user);
        emit(SignupSuccess());
      } catch (e) {
        emit(SignupFailure(e.toString()));
      }
    });
  }
}
