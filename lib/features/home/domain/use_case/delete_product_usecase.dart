import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kalamkart_mobileapp/app/shared_pref/token_shared_prefs.dart';
import 'package:kalamkart_mobileapp/app/usecase/use_case.dart';
import 'package:kalamkart_mobileapp/core/error/failure.dart';
import 'package:kalamkart_mobileapp/features/home/domain/repository/product_repository.dart';

class DeleteProductParams extends Equatable {
  final String id;

  const DeleteProductParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteProductUsecase implements UsecaseWithParams<void, DeleteProductParams> {
  final IProductRepository _productRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  DeleteProductUsecase({
    required IProductRepository productRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _productRepository = productRepository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(DeleteProductParams params) async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (token) async => await _productRepository.deleteProduct(params.id, token),
    );
  }
}
