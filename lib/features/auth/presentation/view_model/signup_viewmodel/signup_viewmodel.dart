// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:kalamkart_mobileapp/features/auth/domain/use_case/use_register_usecase.dart';
// import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/signup_viewmodel/signup_event.dart';
// import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/signup_viewmodel/signup_state.dart';

// class SignupViewModel extends Bloc<SignupEvent, SignupState> {
//   final UserRegisterUseCase registerUseCase;

//   SignupViewModel({required this.registerUseCase}) : super(SignupInitial()) {
//     on<SignupSubmitted>((event, emit) async {
//       emit(SignupLoading());
//       try {
//         await registerUseCase(
//           event.user.username,
//           event.user.email,
//           event.user.password ?? '',
//         );
//         emit(SignupSuccess());
//       } catch (e) {
//         emit(SignupFailure(e.toString()));
//       }
//     });
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/use_case/use_register_usecase.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/signup_viewmodel/signup_event.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/signup_viewmodel/signup_state.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  final UserRegisterUseCase registerUseCase;

  SignupViewModel({required this.registerUseCase}) : super(SignupInitial()) {
    on<SignupSubmitted>((event, emit) async {
      emit(SignupLoading());
      try {
        // Call the use case with user data
        await registerUseCase(
          event.user.username,
          event.user.email,
          event.user.password ?? '',
        );

        // Emit success — UI will handle navigation
        emit(SignupSuccess());
      } catch (e) {
        emit(SignupFailure(e.toString()));
      }
    });
  }
}
