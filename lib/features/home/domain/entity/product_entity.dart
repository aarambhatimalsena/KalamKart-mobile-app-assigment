class ProductEntity {
  final String id;
  final String name;
  final String image;
  final String description;
  final String category;
  final double price;
  final int stock;
  final String? createdBy;
  final List<ReviewEntity> reviews;
  final int numReviews;
  final double rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    required this.createdBy,
    required this.reviews,
    required this.numReviews,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });
}

class ReviewEntity {
  final String id;
  final String userId;
  final String name;
  final int rating;
  final String comment;
  final DateTime createdAt;

  ReviewEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
