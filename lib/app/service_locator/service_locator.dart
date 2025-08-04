import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kalamkart_mobileapp/core/network/api_service.dart';

import 'package:kalamkart_mobileapp/features/auth/data/data_source/user_data_source.dart';
import 'package:kalamkart_mobileapp/features/auth/data/repository/user_remote_repository.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/repository/user_repository.dart';

import 'package:kalamkart_mobileapp/features/auth/domain/use_case/use_register_usecase.dart';

import 'package:kalamkart_mobileapp/features/auth/domain/use_case/user_login_usecase.dart';

import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/login_viewmodel/login_viewmodel.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/signup_viewmodel/signup_viewmodel.dart';
import 'package:kalamkart_mobileapp/features/home/data/data_source/product_data_source.dart';
import 'package:kalamkart_mobileapp/features/home/data/data_source/remote_datasource/product_remote_datasource.dart';

import 'package:kalamkart_mobileapp/features/home/data/repository/remote_repository/product_remote_repository.dart';
import 'package:kalamkart_mobileapp/features/home/domain/repository/product_repository.dart';
import 'package:kalamkart_mobileapp/features/home/domain/use_case/get_all_products_usecase.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view_model/products_view_model.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // Core
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiService>(() => ApiService(sl<Dio>()));

  // Data Sources
  sl.registerLazySingleton<IProductDataSource>(
    () => ProductRemoteDatasource(apiService: sl<ApiService>()),
  );
  sl.registerLazySingleton<IUserRemoteDataSource>(
    () => UserRemoteDataSource(apiService: sl<ApiService>()),
  );

  // Repositories
  sl.registerLazySingleton<IProductRepository>(
    () => ProductRemoteRepository(productRemoteDataSource: sl<IProductDataSource>()),
  );
  sl.registerLazySingleton<IUserRepository>(
    () => UserRemoteRepository(userDataSource: sl<IUserRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton(() => UserLoginUseCase(sl()));
  sl.registerLazySingleton(() => UserRegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetAllProductsUsecase(productRepository: sl<IProductRepository>()));

  // ViewModels (BLoC)
  sl.registerFactory(() => LoginViewModel(loginUseCase: sl()));
  sl.registerFactory(() => SignupViewModel(registerUseCase: sl()));
  sl.registerFactory(() => ProductViewModel(getAllProductsUsecase: sl<GetAllProductsUsecase>()));
}
