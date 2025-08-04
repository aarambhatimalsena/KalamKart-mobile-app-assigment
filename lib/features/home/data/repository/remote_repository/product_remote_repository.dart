import 'package:dartz/dartz.dart';
import 'package:kalamkart_mobileapp/core/error/failure.dart';
import 'package:kalamkart_mobileapp/features/home/data/data_source/product_data_source.dart';
import 'package:kalamkart_mobileapp/features/home/domain/entity/product_entity.dart';
import 'package:kalamkart_mobileapp/features/home/domain/repository/product_repository.dart';

class ProductRemoteRepository implements IProductRepository {
  final IProductDataSource _productRemoteDataSource;

  ProductRemoteRepository({required IProductDataSource productRemoteDataSource})
      : _productRemoteDataSource = productRemoteDataSource;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await _productRemoteDataSource.getProducts();
      return Right(products);
    } catch (e) {
      return Left(RemoteDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    try {
      final product = await _productRemoteDataSource.getProductById(id);
      return Right(product);
    } catch (e) {
      return Left(RemoteDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createProduct(ProductEntity product) async {
    try {
      await _productRemoteDataSource.createProduct(product);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(String id, ProductEntity product) async {
    try {
      await _productRemoteDataSource.updateProduct(id, product);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id, String? token) async {
    try {
      await _productRemoteDataSource.deleteProduct(id, token);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(e.toString()));
    }
  }
}
