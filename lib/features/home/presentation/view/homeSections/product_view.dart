import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/product_detail_page.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view_model/product_state.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view_model/products_view_model.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view_model/product_event.dart';
import 'package:dio/dio.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  Set<String> favoriteProductIds = {};

  String? selectedCategory;
  String? selectedSort;
  TextEditingController searchController = TextEditingController();

  final List<String> categories = ['All', 'Pens', 'Notebooks', 'Art', 'Office'];
  final List<String> sortOptions = ['Price: Low to High', 'Price: High to Low', 'Rating'];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    context.read<ProductViewModel>().add(LoadProductsEvent());
  }

  Future<void> _loadFavorites() async {
    final favorites = await secureStorage.read(key: 'favorite_ids');
    if (favorites != null) {
      setState(() {
        favoriteProductIds = Set<String>.from(favorites.split(','));
      });
    }
  }

  Future<void> _toggleFavorite(String productId, String productName) async {
    final userId = await secureStorage.read(key: 'user_id');
    if (userId == null) return;

    final alreadyFav = favoriteProductIds.contains(productId);
    try {
      final dio = Dio();
      await dio.post(
        'http://192.168.100.66:5000/api/wishlist',
        data: jsonEncode({'productIds': [productId]}),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await secureStorage.read(key: 'auth_token')}',
          },
        ),
      );

      setState(() {
        if (alreadyFav) {
          favoriteProductIds.remove(productId);
        } else {
          favoriteProductIds.add(productId);
        }
      });

      await secureStorage.write(
        key: 'favorite_ids',
        value: favoriteProductIds.join(','),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            alreadyFav
                ? 'Removed $productName from favorites'
                : 'Added $productName to favorites',
          ),
          backgroundColor: alreadyFav ? Colors.grey : Colors.green,
        ),
      );
    } catch (e) {
      print("Error adding to favorites: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update favorites')),
      );
    }
  }

  String _validateImageUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return 'https://placehold.co/150';
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1000) return 4; // Larger tablets or web
    if (screenWidth >= 600) return 3; // Tablets
    return 2; // Mobile
  }

  double _calculateImageHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 ? 120 : 80;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: const Color(0xFF0A1B2E),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Products',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        hint: const Text("Filter by Category"),
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => selectedCategory = value),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedSort,
                        isExpanded: true,
                        hint: const Text("Sort by"),
                        items: sortOptions.map((sort) {
                          return DropdownMenuItem(
                            value: sort,
                            child: Text(sort),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => selectedSort = value),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductViewModel, ProductState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
                  return Center(
                    child: Text(
                      'Error: ${state.errorMessage!}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                List products = state.products;

                // Apply filters
                final query = searchController.text.toLowerCase();
                products = products.where((product) {
                  final matchesCategory = (selectedCategory == null || selectedCategory == 'All') ||
                      product.category.toLowerCase() == selectedCategory!.toLowerCase();
                  final matchesSearch = product.name.toLowerCase().contains(query);
                  return matchesCategory && matchesSearch;
                }).toList();

                if (selectedSort != null) {
                  if (selectedSort == 'Price: Low to High') {
                    products.sort((a, b) => a.price.compareTo(b.price));
                  } else if (selectedSort == 'Price: High to Low') {
                    products.sort((a, b) => b.price.compareTo(a.price));
                  } else if (selectedSort == 'Rating') {
                    products.sort((a, b) => b.rating.compareTo(a.rating));
                  }
                }

                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products found.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = _calculateCrossAxisCount(context);
                    final imgHeight = _calculateImageHeight(context);

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final isFav = favoriteProductIds.contains(product.id);

                        return Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    _validateImageUrl(product.image),
                                    height: imgHeight,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image, size: 80),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text('Npr ${product.price.toStringAsFixed(2)}'),
                                Text(
                                  product.stock > 0 ? 'Stock: ${product.stock}' : 'Out of stock',
                                  style: TextStyle(
                                    color: product.stock > 0 ? Colors.green : Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                                Text('Category: ${product.category}', style: const TextStyle(fontSize: 12)),
                                Text('${product.numReviews} Reviews | Rating: ${product.rating}', style: const TextStyle(fontSize: 12)),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isFav ? Icons.favorite : Icons.favorite_border,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      onPressed: () => _toggleFavorite(product.id, product.name),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailPage(product: product),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        minimumSize: const Size(80, 30),
                                      ),
                                      child: const Text(
                                        'See Details',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}