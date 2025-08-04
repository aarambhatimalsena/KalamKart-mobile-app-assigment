import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kalamkart_mobileapp/app/constants/api_endpoints.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final Dio dio = Dio();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  List<dynamic> orders = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final token = await secureStorage.read(key: 'auth_token');
      
      if (token == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'Please login to view your orders';
        });
        return;
      }

      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.myOrders}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          sendTimeout: ApiEndpoints.connectionTimeout,
          receiveTimeout: ApiEndpoints.receiveTimeout,
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Backend returns orders directly, not wrapped in 'orders' field
          orders = response.data is List ? response.data : [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load orders';
        });
      }
    } catch (e) {
      print("Failed to fetch orders: $e");
      String errorMsg = 'Failed to load orders';
      
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          errorMsg = 'Please login to view your orders';
        } else if (e.response?.statusCode == 404) {
          errorMsg = 'No orders found';
        } else {
          try {
            final responseData = e.response?.data;
            if (responseData is Map && responseData['message'] != null) {
              errorMsg = responseData['message'];
            }
          } catch (_) {
            // fallback
          }
        }
      }
      
      setState(() {
        isLoading = false;
        errorMessage = errorMsg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1B2E),
        foregroundColor: Colors.white,
        title: const Text("My Orders"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchOrders,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchOrders,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 64,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No orders found.",
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Start shopping to see your orders here!",
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchOrders,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          final items = order['items'] as List<dynamic>? ?? [];

                          return Card(
                            color: const Color(0xFF1A2B3E),
                            margin: const EdgeInsets.only(bottom: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order #${order['_id']?.toString().substring(0, 6) ?? 'N/A'}...',
                                        style: const TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(order['status'] ?? 'pending'),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${order['status'] ?? 'pending'}'.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Total: NPR ${order['totalAmount']?.toStringAsFixed(2) ?? '0.00'}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                                  ),
                                  Text(
                                    'Payment: ${order['paymentMethod'] ?? 'N/A'}',
                                    style: const TextStyle(color: Colors.white60),
                                  ),
                                  if (order['createdAt'] != null)
                                    Text(
                                      'Date: ${_formatDate(order['createdAt'])}',
                                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                                    ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Items:',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  ...items.map((item) {
                                    final product = item['product'] ?? {};
                                    final imageUrl = product['image'] ?? '';

                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: imageUrl.isNotEmpty
                                            ? Image.network(
                                                imageUrl,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder: (ctx, error, stack) => Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[800],
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: const Icon(Icons.image_not_supported, color: Colors.white54),
                                                ),
                                              )
                                            : Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[800],
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Icon(Icons.image, size: 24, color: Colors.white54),
                                              ),
                                      ),
                                      title: Text(
                                        product['name'] ?? 'Unknown Product',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        'Quantity: ${item['quantity']} | NPR ${item['price']?.toStringAsFixed(2) ?? '0.00'}',
                                        style: const TextStyle(color: Colors.white70),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(dynamic date) {
    try {
      if (date is String) {
        return date.split('T').first;
      }
      return date.toString().split('T').first;
    } catch (e) {
      return 'N/A';
    }
  }
}
