import 'package:dio/dio.dart';

import 'package:kalamkart_mobileapp/app/constants/api_endpoints.dart';
import 'package:kalamkart_mobileapp/core/network/api_service.dart';
import 'package:kalamkart_mobileapp/features/home/data/data_source/product_data_source.dart';
import 'package:kalamkart_mobileapp/features/home/data/model/product_api_model.dart';
import 'package:kalamkart_mobileapp/features/home/domain/entity/product_entity.dart';

class ProductRemoteDatasource implements IProductDataSource {
  final ApiService _apiService;

  ProductRemoteDatasource({required ApiService apiService}) : _apiService = apiService;

  @override
Future<List<ProductEntity>> getProducts() async {
  try {
    final response = await _apiService.dio.get(ApiEndpoints.allProducts);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      final products = data.map((e) => ProductApiModel.fromJson(e as Map<String, dynamic>).toEntity()).toList();
      return products;
    } else {
      throw Exception('Failed to fetch products: ${response.statusCode}');
    }
  } on DioException catch (e) {
    throw Exception('Failed to fetch products: $e');
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }
}

  @override
  Future<ProductEntity> getProductById(String id) async {
    try {
      // Note: productById is "/products/" - just append id directly, no extra slash
      final response = await _apiService.dio.get('${ApiEndpoints.productById}$id');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final productModel = ProductApiModel.fromJson(data);
        return productModel.toEntity();
      } else {
        throw Exception('Failed to fetch product: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch product: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> createProduct(ProductEntity product) async {
    try {
      final productModel = ProductApiModel.fromEntity(product);
      final response = await _apiService.dio.post(
        ApiEndpoints.adminAddProduct, // admin route for creating product
        data: productModel.toJson(),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create product: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create product: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> updateProduct(String id, ProductEntity product) async {
    try {
      final productModel = ProductApiModel.fromEntity(product);
      final response = await _apiService.dio.put(
        '${ApiEndpoints.adminUpdateProduct}$id', // admin update with id appended directly
        data: productModel.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update product: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id, String? token) async {
    try {
      final response = await _apiService.dio.delete(
        '${ApiEndpoints.adminDeleteProduct}$id', // admin delete with id appended directly
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete product: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
