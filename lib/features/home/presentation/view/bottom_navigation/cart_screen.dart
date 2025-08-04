import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/bottom_navigation/order_details_screen.dart';

class CartItem {
  final String cartItemId;
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.cartItemId,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final Dio dio = Dio();
  List<CartItem> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<String?> _getToken() async {
    return await secureStorage.read(key: 'auth_token');
  }

  Future<void> _loadCartItems() async {
    setState(() => isLoading = true);
    try {
      final token = await _getToken();
      final response = await dio.get(
        'http://192.168.100.66:5000/api/cart',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List items = response.data['items'];
      final List<CartItem> loaded =
          items.map((item) {
            final product = item['product'];
            return CartItem(
              cartItemId: item['_id'],
              id: product['_id'],
              name: product['name'],
              price: (product['price'] as num).toDouble(),
              imageUrl: product['image'] ?? '',
              quantity: item['quantity'],
            );
          }).toList();

      setState(() {
        cartItems = loaded;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading cart: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateQuantity(String productId, int newQuantity) async {
    final token = await _getToken();
    try {
      await dio.put(
        'http://192.168.100.66:5000/api/cart',
        data: jsonEncode({'productId': productId, 'quantity': newQuantity}),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      await _loadCartItems();
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }

  Future<void> _removeItem(String cartItemId) async {
    final token = await _getToken();
    try {
      await dio.delete(
        'http://192.168.100.66:5000/api/cart/$cartItemId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      await _loadCartItems();
    } catch (e) {
      print("Error removing item: $e");
    }
  }

  Future<void> _clearCart() async {
    final token = await _getToken();
    try {
      await dio.delete(
        'http://192.168.100.66:5000/api/cart/clear',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      setState(() {
        cartItems.clear();
      });
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }

  double get total =>
      cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: const Color(0xFF0A1B2E),
        foregroundColor: Colors.white,
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: "Clear Cart",
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text("Clear Cart"),
                        content: const Text(
                          "Are you sure you want to remove all items from the cart?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Clear"),
                          ),
                        ],
                      ),
                );
                if (confirm == true) await _clearCart();
              },
            ),
        ],
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              )
              : cartItems.isEmpty
              ? const Center(
                child: Text(
                  "Cart is empty",
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          color: const Color(0xFF1A2B3E),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Image.network(
                              item.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              item.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Price: NPR ${item.price}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          item.quantity > 1
                                              ? () => _updateQuantity(
                                                item.id,
                                                item.quantity - 1,
                                              )
                                              : null,
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle,
                                        color: Colors.green,
                                      ),
                                      onPressed:
                                          () => _updateQuantity(
                                            item.id,
                                            item.quantity + 1,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.white70,
                              ),
                              onPressed: () => _removeItem(item.cartItemId),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.teal.shade900,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'NPR ${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade700,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            // icon: const Icon(Icons.payment),
                            label: const Text("Place Order"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          OrderDetailsScreen(total: total),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
