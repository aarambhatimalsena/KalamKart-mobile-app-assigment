import 'package:get_it/get_it.dart';
import 'package:kalamkart_mobileapp/core/network/hive_service.dart';
import 'package:kalamkart_mobileapp/features/auth/data/data_source/local_datasource/user_hive_data_source.dart';
import 'package:kalamkart_mobileapp/features/auth/data/data_source/user_data_source.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/repository/local_repository/user_local_repository.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/repository/user_repository.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/login_viewmodel/login_viewmodel.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/signup_viewmodel/signup_viewmodel.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => HiveService());

  // Data Source
  sl.registerLazySingleton<IUserDataSource>(() => UserHiveDataSource(hiveService: sl()));

  // Repository
  sl.registerLazySingleton<IUserRepository>(() => UserLocalRepository(userDataSource: sl()));

  // Use Cases
  sl.registerLazySingleton(() => UserLoginUseCase(sl()));
  sl.registerLazySingleton(() => UserRegisterUseCase(sl()));

  // ViewModels (Blocs)
  sl.registerFactory(() => LoginViewModel(loginUseCase: sl()));
  sl.registerFactory(() => SignupViewModel(registerUseCase: sl()));
 

}
