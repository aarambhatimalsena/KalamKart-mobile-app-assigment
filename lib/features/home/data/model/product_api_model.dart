import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kalamkart_mobileapp/features/home/domain/entity/product_entity.dart';

part 'product_api_model.g.dart';

@JsonSerializable()
class ProductApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? productId;
  final String name;
  final String image;
  final String description;
  final String category;
  final double price;
  final int stock;
  final String? createdBy;
  final int numReviews;
  final double rating;

  const ProductApiModel({
    this.productId,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    this.createdBy,
    required this.numReviews,
    required this.rating,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductApiModelToJson(this);

  // From Entity
  factory ProductApiModel.fromEntity(ProductEntity entity) {
    return ProductApiModel(
      productId: entity.id,
      name: entity.name,
      image: entity.image,
      description: entity.description,
      category: entity.category,
      price: entity.price,
      stock: entity.stock,
      createdBy: entity.createdBy,
      numReviews: entity.numReviews,
      rating: entity.rating,
    );
  }

  // To Entity
  ProductEntity toEntity() {
    return ProductEntity(
      id: productId ?? '',
      name: name,
      image: image,
      description: description,
      category: category,
      price: price,
      stock: stock,
      createdBy: createdBy,
      numReviews: numReviews,
      rating: rating, reviews: [], 
      createdAt: DateTime.now(), 
      updatedAt: DateTime.now(),
    );
  }

  // List conversions
  static List<ProductEntity> toEntityList(List<ProductApiModel> apiList) {
    return apiList.map((model) => model.toEntity()).toList();
  }

  static List<ProductApiModel> fromEntityList(List<ProductEntity> entityList) {
    return entityList.map(ProductApiModel.fromEntity).toList();
  }

  @override
  List<Object?> get props => [
        productId,
        name,
        image,
        description,
        category,
        price,
        stock,
        createdBy,
        numReviews,
        rating,
      ];
}
