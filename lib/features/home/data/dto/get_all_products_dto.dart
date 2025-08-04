import 'package:json_annotation/json_annotation.dart';
import 'package:kalamkart_mobileapp/features/home/data/model/product_api_model.dart';

part 'get_all_products_dto.g.dart';

@JsonSerializable()
class GetAllProductsDto {
  final bool success;
  final int count;
  final List<ProductApiModel> data;

  const GetAllProductsDto({
    required this.success,
    required this.count,
    required this.data,
  });

  // From JSON
  factory GetAllProductsDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllProductsDtoFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$GetAllProductsDtoToJson(this);
}
