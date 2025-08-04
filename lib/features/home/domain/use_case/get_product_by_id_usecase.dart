import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kalamkart_mobileapp/app/usecase/use_case.dart';
import 'package:kalamkart_mobileapp/core/error/failure.dart';
import 'package:kalamkart_mobileapp/features/home/domain/entity/product_entity.dart';
import 'package:kalamkart_mobileapp/features/home/domain/repository/product_repository.dart';

class GetProductByIdParams extends Equatable {
  final String id;

  const GetProductByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetProductByIdUsecase implements UsecaseWithParams<ProductEntity, GetProductByIdParams> {
  final IProductRepository _productRepository;

  GetProductByIdUsecase({required IProductRepository productRepository})
      : _productRepository = productRepository;

  @override
  Future<Either<Failure, ProductEntity>> call(GetProductByIdParams params) {
    return _productRepository.getProductById(params.id);
  }
}
