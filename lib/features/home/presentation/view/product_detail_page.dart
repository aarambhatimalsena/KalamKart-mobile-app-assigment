import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:kalamkart_mobileapp/features/home/domain/entity/product_entity.dart';
import 'package:kalamkart_mobileapp/app/constants/api_endpoints.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<dynamic> reviews = [];
  bool isLoadingReviews = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    final dio = Dio();
    final secureStorage = const FlutterSecureStorage();

    try {
      setState(() {
        isLoadingReviews = true;
      });

      final token = await secureStorage.read(key: 'auth_token');
      print('🔍 Fetching reviews for product: ${widget.product.id}');
      print('🔍 Token available: ${token != null ? 'Yes' : 'No'}');
      
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.productReviews}${widget.product.id}',
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : {},
          sendTimeout: ApiEndpoints.connectionTimeout,
          receiveTimeout: ApiEndpoints.receiveTimeout,
        ),
      );

      print('🔍 Response status: ${response.statusCode}');
      print('🔍 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> allReviews = response.data;

        setState(() {
          reviews = allReviews;
          isLoadingReviews = false;
        });
        
        print('🔍 Reviews fetched: ${reviews.length}');
      }
    } catch (e) {
      print('❌ Error fetching reviews: $e');
      if (e is DioException) {
        print('❌ DioException status: ${e.response?.statusCode}');
        print('❌ DioException data: ${e.response?.data}');
      }
      setState(() {
        isLoadingReviews = false;
      });
    }
  }

  String _validateImageUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return 'https://placehold.co/150';
  }

  Future<void> _showQuantityDialog(
    BuildContext context,
    String productId,
  ) async {
    int quantity = 1;
    final secureStorage = const FlutterSecureStorage();
    final dio = Dio();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Quantity'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      quantity--;
                      (context as Element).markNeedsBuild();
                    }
                  },
                ),
                Text('$quantity'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    quantity++;
                    (context as Element).markNeedsBuild();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final token = await secureStorage.read(key: 'auth_token');
                  if (token == null) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please login to add items to cart')),
                    );
                    return;
                  }

                  try {
                    await dio.post(
                      '${ApiEndpoints.baseUrl}${ApiEndpoints.cart}',
                      data: jsonEncode({
                        'productId': productId,
                        'quantity': quantity,
                      }),
                      options: Options(
                        headers: {
                          'Authorization': 'Bearer $token',
                          'Content-Type': 'application/json',
                        },
                        sendTimeout: ApiEndpoints.connectionTimeout,
                        receiveTimeout: ApiEndpoints.receiveTimeout,
                      ),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added $quantity x ${widget.product.name} to cart',
                        ),
                      ),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    String errorMessage = 'Failed to add to cart';
                    if (e is DioException) {
                      try {
                        final responseData = e.response?.data;
                        if (responseData is Map && responseData['message'] != null) {
                          errorMessage = responseData['message'];
                        }
                      } catch (_) {
                        // fallback
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  }
                },
                child: const Text('Add to Cart'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: const Color(0xFF0A1B2E),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                _validateImageUrl(widget.product.image),
                height: 200,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${widget.product.rating}'),
                const SizedBox(width: 10),
                Text('(${widget.product.numReviews} reviews)'),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Category: ${widget.product.category}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.stock > 0
                  ? 'In Stock: ${widget.product.stock}'
                  : 'Out of Stock',
              style: TextStyle(
                color: widget.product.stock > 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'NPR ${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const Divider(height: 30),
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(widget.product.description),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A1B2E),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                    onPressed:
                        widget.product.stock > 0
                            ? () =>
                                _showQuantityDialog(context, widget.product.id)
                            : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        () => _showReviewDialog(context, widget.product.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.rate_review),
                    label: const Text('Review'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(),
            const Text(
              'Customer Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (isLoadingReviews)
              const Center(child: CircularProgressIndicator())
            else if (reviews.isEmpty)
              const Text('No reviews yet.')
            else
              Column(
                children:
                    reviews.map((review) => _buildReviewCard(review)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, String productId) {
    final commentController = TextEditingController();
    int selectedRating = 5;
    final dio = Dio();
    final secureStorage = const FlutterSecureStorage();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Review'),
            content: StatefulBuilder(
              builder:
                  (context, setState) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: 'Write your review...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('Rating: '),
                          DropdownButton<int>(
                            value: selectedRating,
                            items:
                                [1, 2, 3, 4, 5]
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text('$e Stars'),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => selectedRating = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final token = await secureStorage.read(key: 'auth_token');
                  if (token == null) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('You must be logged in to add a review.')),
                    );
                    return;
                  }

                  if (commentController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please write a review comment.')),
                    );
                    return;
                  }

                  try {
                    final response = await dio.post(
                      '${ApiEndpoints.baseUrl}${ApiEndpoints.productReviews}$productId',
                      data: jsonEncode({
                        'rating': selectedRating,
                        'comment': commentController.text.trim(),
                      }),
                      options: Options(
                        headers: {
                          'Authorization': 'Bearer $token',
                          'Content-Type': 'application/json',
                        },
                        sendTimeout: ApiEndpoints.connectionTimeout,
                        receiveTimeout: ApiEndpoints.receiveTimeout,
                      ),
                    );

                    Navigator.pop(context);
                    await _fetchReviews(); // Refresh reviews
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Review submitted successfully!')),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    String errorMessage = 'Failed to submit review';

                    if (e is DioException) {
                      try {
                        final responseData = e.response?.data;
                        if (responseData is Map && responseData['message'] != null) {
                          errorMessage = responseData['message'];
                        }
                      } catch (_) {
                        // fallback
                      }
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
    );
  }

  Widget _buildReviewCard(dynamic review) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text('${review['name']} - ${review['rating']}★'),
        subtitle: Text(review['comment'] ?? ''),
        trailing: Text(
          review['createdAt'] != null
              ? review['createdAt'].toString().split('T').first
              : '',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
