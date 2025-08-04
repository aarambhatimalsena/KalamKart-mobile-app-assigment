// product_state.dart
import 'package:equatable/equatable.dart';
import 'package:kalamkart_mobileapp/features/home/domain/entity/product_entity.dart';

class ProductState extends Equatable {
  final bool isLoading;
  final List<ProductEntity> products;
  final String? errorMessage;

  const ProductState({
    required this.isLoading,
    required this.products,
    this.errorMessage,
  });

  factory ProductState.initial() => const ProductState(isLoading: false, products: [], errorMessage: '');

  ProductState copyWith({
    bool? isLoading,
    List<ProductEntity>? products,
    String? errorMessage,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, products, errorMessage];
}
