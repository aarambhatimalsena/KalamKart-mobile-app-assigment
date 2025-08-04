import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kalamkart_mobileapp/app/usecase/use_case.dart';
import 'package:kalamkart_mobileapp/core/error/failure.dart';
import 'package:kalamkart_mobileapp/features/home/domain/entity/product_entity.dart';
import 'package:kalamkart_mobileapp/features/home/domain/repository/product_repository.dart';

class UpdateProductParams extends Equatable {
  final String id;
  final String name;
  final String image;
  final String description;
  final String category;
  final double price;
  final int stock;

  const UpdateProductParams({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
  });

  @override
  List<Object?> get props => [id, name, image, description, category, price, stock];
}

class UpdateProductUsecase implements UsecaseWithParams<void, UpdateProductParams> {
  final IProductRepository _productRepository;

  UpdateProductUsecase({required IProductRepository productRepository})
      : _productRepository = productRepository;

  @override
  Future<Either<Failure, void>> call(UpdateProductParams params) {
    final product = ProductEntity(
      id: params.id,
      name: params.name,
      image: params.image,
      description: params.description,
      category: params.category,
      price: params.price,
      stock: params.stock,
      createdBy: null,
      reviews: [],
      numReviews: 0,
      rating: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return _productRepository.updateProduct(params.id, product);
  }
}
