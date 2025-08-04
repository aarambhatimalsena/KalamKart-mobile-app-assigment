
// product_view_model.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalamkart_mobileapp/features/home/domain/use_case/get_all_products_usecase.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view_model/product_event.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view_model/product_state.dart';

class ProductViewModel extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUsecase _getAllProductsUsecase;

  ProductViewModel({
    required GetAllProductsUsecase getAllProductsUsecase,
  })  : _getAllProductsUsecase = getAllProductsUsecase,
        super(ProductState.initial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<AddReviewEvent>(_onAddReview);
    add(LoadProductsEvent());
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getAllProductsUsecase(null);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (products) => emit(state.copyWith(isLoading: false, products: products)),
    );
  }

  Future<void> _onAddReview(
    AddReviewEvent event,
    Emitter<ProductState> emit,
  ) async {
    add(LoadProductsEvent());
  }
}
