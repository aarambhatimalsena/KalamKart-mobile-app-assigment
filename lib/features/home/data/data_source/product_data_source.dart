import 'package:kalamkart_mobileapp/features/home/domain/entity/product_entity.dart';

abstract interface class IProductDataSource {
  Future<List<ProductEntity>> getProducts();
  Future<ProductEntity> getProductById(String id);
  Future<void> createProduct(ProductEntity product);
  Future<void> updateProduct(String id, ProductEntity product);
  Future<void> deleteProduct(String id, String? token);
}
