import 'package:flutter/material.dart';

class TrendingNowPage extends StatefulWidget {
  const TrendingNowPage({super.key});

  @override
  State<TrendingNowPage> createState() => _TrendingNowPageState();
}

class _TrendingNowPageState extends State<TrendingNowPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  String selectedFilter = 'All';
  String sortBy = 'Trending Score';
  
  final List<String> filters = ['All', 'Art', 'Writing', 'Organization', 'Digital'];
  final List<String> sortOptions = ['Trending Score', 'Price: Low to High', 'Price: High to Low', 'Most Recent'];

  final List<Map<String, dynamic>> trendingProducts = [
    {
      "name": "Digital Highlighter Set",
      "price": 8.49,
      "originalPrice": 12.99,
      "image": "/placeholder.svg?height=200&width=200&text=Digital+Highlighters",
      "category": "Digital",
      "rating": 4.9,
      "reviews": 456,
      "description": "Smart highlighters that sync with apps",
      "inStock": true,
      "trendingScore": 98,
      "growthRate": "+45%",
      "isNew": true,
    },
    {
      "name": "Eco-Friendly Art Brushes",
      "price": 24.99,
      "originalPrice": 32.99,
      "image": "/placeholder.svg?height=200&width=200&text=Eco+Brushes",
      "category": "Art",
      "rating": 4.8,
      "reviews": 289,
      "description": "Sustainable art brushes made from bamboo",
      "inStock": true,
      "trendingScore": 95,
      "growthRate": "+38%",
      "isNew": false,
    },
    {
      "name": "Smart Notebook Pro",
      "price": 35.99,
      "originalPrice": 45.99,
      "image": "/placeholder.svg?height=200&width=200&text=Smart+Notebook",
      "category": "Digital",
      "rating": 4.7,
      "reviews": 234,
      "description": "Reusable notebook with cloud sync",
      "inStock": true,
      "trendingScore": 92,
      "growthRate": "+52%",
      "isNew": true,
    },
    {
      "name": "Minimalist Pen Collection",
      "price": 18.99,
      "originalPrice": 24.99,
      "image": "/placeholder.svg?height=200&width=200&text=Minimalist+Pens",
      "category": "Writing",
      "rating": 4.6,
      "reviews": 178,
      "description": "Clean design pens for modern writers",
      "inStock": false,
      "trendingScore": 89,
      "growthRate": "+29%",
      "isNew": false,
    },
    {
      "name": "Modular Desk Organizer",
      "price": 42.99,
      "originalPrice": 55.99,
      "image": "/placeholder.svg?height=200&width=200&text=Desk+Organizer",
      "category": "Organization",
      "rating": 4.8,
      "reviews": 312,
      "description": "Customizable desk organization system",
      "inStock": true,
      "trendingScore": 87,
      "growthRate": "+33%",
      "isNew": false,
    },
    {
      "name": "Watercolor Pencils Pro",
      "price": 28.99,
      "originalPrice": 36.99,
      "image": "/placeholder.svg?height=200&width=200&text=Watercolor+Pencils",
      "category": "Art",
      "rating": 4.9,
      "reviews": 198,
      "description": "Professional watercolor pencils set",
      "inStock": true,
      "trendingScore": 85,
      "growthRate": "+41%",
      "isNew": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> filtered = trendingProducts;
    
    if (selectedFilter != 'All') {
      filtered = filtered.where((product) => product['category'] == selectedFilter).toList();
    }
    
    switch (sortBy) {
      case 'Price: Low to High':
        filtered.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => b['price'].compareTo(a['price']));
        break;
      case 'Most Recent':
        filtered.sort((a, b) => (b['isNew'] ? 1 : 0).compareTo(a['isNew'] ? 1 : 0));
        break;
      default:
        filtered.sort((a, b) => b['trendingScore'].compareTo(a['trendingScore']));
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
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animationController.value * 2 * 3.14159,
                  child: const Icon(Icons.trending_up, color: Colors.amber, size: 24),
                );
              },
            ),
            const SizedBox(width: 8),
            const Text(
              'Trending Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Roboto_Condensed-Bold',
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'LIVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Trending Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1A2B3E),
                  const Color(0xFF0A1B2E),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Live Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTrendingStat('🔥', 'Hot Items', '${trendingProducts.where((p) => p['trendingScore'] > 90).length}'),
                    _buildTrendingStat('📈', 'Avg Growth', '+38%'),
                    _buildTrendingStat('⚡', 'Live Views', '2.4K'),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Filter Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1B2E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.withOpacity(0.3)),
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
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1B2E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.withOpacity(0.3)),
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
              ],
            ),
          ),
          
          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return _buildTrendingProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingStat(String emoji, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1B2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingProductCard(Map<String, dynamic> product) {
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
        border: product['trendingScore'] > 90 
            ? Border.all(color: Colors.amber, width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Image.network(
                    product['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image, color: Colors.grey, size: 40),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Trending Score Badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getTrendingColor(product['trendingScore']),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${product['trendingScore']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // New Badge
              if (product['isNew'])
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              
              // Growth Rate
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up, color: Colors.green, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        product['growthRate'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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

  Color _getTrendingColor(int score) {
    if (score >= 95) return Colors.red;
    if (score >= 90) return Colors.orange;
    if (score >= 85) return Colors.amber;
    return Colors.grey;
  }
}
