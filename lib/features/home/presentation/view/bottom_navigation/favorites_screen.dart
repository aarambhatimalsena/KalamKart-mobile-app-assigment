import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kalamkart_mobileapp/main.dart';

class FavoriteItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final DateTime addedAt;
  final String wishlistItemId;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.addedAt,
    required this.wishlistItemId,
  });
}

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with RouteAware {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final Dio dio = Dio();
  List<FavoriteItem> favoriteItems = [];
  bool isLoading = true;
  Map<String, int> cartQuantities = {};
  Set<String> favoriteProductIds = {};

  @override
  void initState() {
    super.initState();
    _loadCartQuantities();
    _loadFavorites();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _loadFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<String?> _getToken() async {
    return await secureStorage.read(key: 'auth_token');
  }

  Future<void> _loadFavorites() async {
    setState(() => isLoading = true);
    try {
      final token = await _getToken();
      final response = await dio.get(
        'http://192.168.100.66:5000/api/wishlist',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final List<dynamic> data = response.data;
      final fetchedFavorites = data.where((item) => item['product'] != null).map((item) {
        final product = item['product'];
        return FavoriteItem(
          id: product['_id'],
          name: product['name'],
          description: '',
          price: (product['price'] as num).toDouble(),
          imageUrl: product['image'] ?? '',
          category: product['category'] ?? 'Unknown',
          addedAt: DateTime.parse(item['addedAt']),
          wishlistItemId: product['_id'],
        );
      }).toList();

      setState(() {
        favoriteItems = fetchedFavorites;
        favoriteProductIds = fetchedFavorites.map((item) => item.id).toSet();
        isLoading = false;
      });

      await secureStorage.write(
        key: 'favorite_ids',
        value: favoriteProductIds.join(','),
      );
    } catch (e) {
      print("Error fetching favorites: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load favorites"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _removeFromFavorites(String wishlistItemId) async {
    try {
      final token = await _getToken();
      final response = await dio.delete(
        'http://192.168.100.66:5000/api/wishlist/$wishlistItemId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete favorite');
      }

      setState(() {
        favoriteItems.removeWhere((item) => item.wishlistItemId == wishlistItemId);
        cartQuantities.remove(wishlistItemId);
        favoriteProductIds.remove(wishlistItemId);
        _saveCartQuantities();
      });

      await secureStorage.write(
        key: 'favorite_ids',
        value: favoriteProductIds.join(','),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites')),
      );
    } catch (e) {
      print("Error removing favorite: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to remove from favorites"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _showAddToCartDialog(String productId) async {
    int quantity = 1;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Cart'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter quantity:'),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (context, setState) => Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => setState(() {
                      if (quantity > 1) quantity--;
                    }),
                  ),
                  Text('$quantity'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() {
                      quantity++;
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _addToCart(productId, quantity);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart(String productId, int quantity) async {
    try {
      final token = await _getToken();
      final response = await dio.post(
        'http://192.168.100.66:5000/api/cart',
        data: jsonEncode({
          'productId': productId,
          'quantity': quantity,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      setState(() {
        cartQuantities[productId] = quantity;
        _saveCartQuantities();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to cart')),
      );
    } catch (e) {
      print("Error adding to cart: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add to cart"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _loadCartQuantities() async {
    final jsonString = await secureStorage.read(key: 'cart_quantities');
    if (jsonString != null) {
      final Map<String, dynamic> map = json.decode(jsonString);
      setState(() {
        cartQuantities = map.map((key, value) => MapEntry(key, value as int));
      });
    }
  }

  Future<void> _saveCartQuantities() async {
    final jsonString = json.encode(cartQuantities);
    await secureStorage.write(key: 'cart_quantities', value: jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1B2E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Favorites', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : favoriteItems.isEmpty
              ? const Center(
                  child: Text("No favorites found", style: TextStyle(color: Colors.white70, fontSize: 16)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    final item = favoriteItems[index];
                    final count = cartQuantities[item.id] ?? 0;
                    return Card(
                      color: const Color(0xFF1A2B3E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('Category: ${item.category}',
                                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text('Price: Npr ${item.price.toStringAsFixed(2)}',
                                      style: const TextStyle(color: Colors.amber, fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.favorite, color: Colors.red),
                                        onPressed: () => _removeFromFavorites(item.wishlistItemId),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.white70),
                                        onPressed: () => _removeFromFavorites(item.wishlistItemId),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () => _showAddToCartDialog(item.id),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                                        child: const Text('Add to Cart'),
                                      ),
                                      const SizedBox(width: 12),
                                      if (count > 0)
                                        Text('x$count', style: const TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
