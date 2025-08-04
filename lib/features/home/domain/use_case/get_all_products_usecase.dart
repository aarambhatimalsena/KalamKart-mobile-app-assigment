import 'package:dartz/dartz.dart';
import 'package:kalamkart_mobileapp/app/usecase/use_case.dart';
import 'package:kalamkart_mobileapp/core/error/failure.dart';
import 'package:kalamkart_mobileapp/features/home/domain/entity/product_entity.dart';
import 'package:kalamkart_mobileapp/features/home/domain/repository/product_repository.dart';

class GetAllProductsUsecase implements UsecaseWithParams<List<ProductEntity>, void> {
  final IProductRepository _productRepository;

  GetAllProductsUsecase({required IProductRepository productRepository})
      : _productRepository = productRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(void params) {
    return _productRepository.getProducts();
  }
}
