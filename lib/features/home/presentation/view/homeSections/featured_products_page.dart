import 'package:flutter/material.dart';

class FeaturedProductsPage extends StatefulWidget {
  const FeaturedProductsPage({super.key});

  @override
  State<FeaturedProductsPage> createState() => _FeaturedProductsPageState();
}

class _FeaturedProductsPageState extends State<FeaturedProductsPage> {
  String selectedFilter = 'All';
  String sortBy = 'Name';
  
  final List<String> filters = ['All', 'Pens', 'Notebooks', 'Art Supplies', 'Office'];
  final List<String> sortOptions = ['Name', 'Price: Low to High', 'Price: High to Low', 'Rating'];

  final List<Map<String, dynamic>> featuredProducts = [
    {
      "name": "Premium Gel Pens Set",
      "price": 8.99,
      "originalPrice": 12.99,
      "image": "assets/images/products/gel_pens.jpeg",
      "category": "Pens",
      "rating": 4.8,
      "reviews": 124,
      "description": "Smooth writing gel pens with vibrant colors",
      "inStock": true,
    },
    {
      "name": "Leather Bound Notebook",
      "price": 24.99,
      "originalPrice": 29.99,
      "image": "/placeholder.svg?height=200&width=200&text=Notebook",
      "category": "Notebooks",
      "rating": 4.9,
      "reviews": 89,
      "description": "Premium leather notebook with dotted pages",
      "inStock": true,
    },
    {
      "name": "Professional Marker Set",
      "price": 15.99,
      "originalPrice": 19.99,
      "image": "/placeholder.svg?height=200&width=200&text=Markers",
      "category": "Art Supplies",
      "rating": 4.7,
      "reviews": 156,
      "description": "Professional quality markers for artists",
      "inStock": false,
    },
    {
      "name": "Ergonomic Pencil Case",
      "price": 9.99,
      "originalPrice": 14.99,
      "image": "/placeholder.svg?height=200&width=200&text=Pencil+Case",
      "category": "Office",
      "rating": 4.6,
      "reviews": 78,
      "description": "Spacious pencil case with multiple compartments",
      "inStock": true,
    },
    {
      "name": "Fountain Pen Collection",
      "price": 45.99,
      "originalPrice": 59.99,
      "image": "/placeholder.svg?height=200&width=200&text=Fountain+Pen",
      "category": "Pens",
      "rating": 4.9,
      "reviews": 203,
      "description": "Elegant fountain pens with gold nibs",
      "inStock": true,
    },
    {
      "name": "Watercolor Paint Set",
      "price": 32.99,
      "originalPrice": 39.99,
      "image": "/placeholder.svg?height=200&width=200&text=Watercolor",
      "category": "Art Supplies",
      "rating": 4.8,
      "reviews": 167,
      "description": "Professional watercolor paints with brushes",
      "inStock": true,
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> filtered = featuredProducts;
    
    // Apply category filter
    if (selectedFilter != 'All') {
      filtered = filtered.where((product) => product['category'] == selectedFilter).toList();
    }
    
    // Apply sorting
    switch (sortBy) {
      case 'Price: Low to High':
        filtered.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => b['price'].compareTo(a['price']));
        break;
      case 'Rating':
        filtered.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      default:
        filtered.sort((a, b) => a['name'].compareTo(b['name']));
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1B2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Featured Products',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'Roboto_Condensed-Bold',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Search coming soon!")),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter and Sort Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2B3E),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Filter Dropdown
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A1B2E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        dropdownColor: const Color(0xFF1A2B3E),
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.filter_list, color: Colors.amber),
                        items: filters.map((filter) {
                          return DropdownMenuItem(
                            value: filter,
                            child: Text(filter),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFilter = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Sort Dropdown
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A1B2E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: sortBy,
                        dropdownColor: const Color(0xFF1A2B3E),
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.sort, color: Colors.amber),
                        items: sortOptions.map((sort) {
                          return DropdownMenuItem(
                            value: sort,
                            child: Text(sort, style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            sortBy = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final discount = ((product['originalPrice'] - product['price']) / product['originalPrice'] * 100).round();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: Colors.grey[100],
                child: product['image'].toString().startsWith('assets/')
    ? Image.asset(
        product['image'],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
            ),
          );
        },
      )
    : Image.network(
        product['image'],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
            ),
          );
        },
      ),
                ),
              ),
              // Discount Badge
              if (discount > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '-$discount%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // Stock Status
              if (!product['inStock'])
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Out of Stock',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // Favorite Button
              Positioned(
                bottom: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Added ${product['name']} to favorites")),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Product Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto_Condensed-Bold',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < product['rating'].floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 12,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '(${product['reviews']})',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${product['price'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto_Condensed-Bold',
                        ),
                      ),
                      if (discount > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '\$${product['originalPrice'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: product['inStock'] ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Added ${product['name']} to cart")),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: product['inStock'] 
                            ? const Color(0xFF0A1B2E) 
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        product['inStock'] ? 'Add to Cart' : 'Out of Stock',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
