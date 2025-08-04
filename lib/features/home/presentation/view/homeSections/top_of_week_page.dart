import 'package:flutter/material.dart';

class TopOfWeekPage extends StatefulWidget {
  const TopOfWeekPage({super.key});

  @override
  State<TopOfWeekPage> createState() => _TopOfWeekPageState();
}

class _TopOfWeekPageState extends State<TopOfWeekPage> {
  String selectedFilter = 'All';
  String sortBy = 'Popularity';
  
  final List<String> filters = ['All', 'Journals', 'Pens', 'Planning', 'Art'];
  final List<String> sortOptions = ['Popularity', 'Price: Low to High', 'Price: High to Low', 'Newest'];

  final List<Map<String, dynamic>> topProducts = [
    {
      "name": "Bullet Journal Pro",
      "price": 18.99,
      "originalPrice": 24.99,
       "image": "assets/images/products/bullet_journal.jpeg",
      "category": "Journals",
      "rating": 4.9,
      "reviews": 342,
      "description": "Premium dotted journal for bullet journaling",
      "inStock": true,
      "weeklyRank": 1,
      "trending": true,
    },
    {
      "name": "Fine Liner Set",
      "price": 12.75,
      "originalPrice": 16.99,
       "image": "assets/images/products/fine_liner.jpeg",
      "category": "Pens",
      "rating": 4.8,
      "reviews": 289,
      "description": "Precision fine liners in multiple colors",
      "inStock": true,
      "weeklyRank": 2,
      "trending": true,
    },
    {
      "name": "Weekly Planner Deluxe",
      "price": 22.99,
      "originalPrice": 29.99,
      "image": "assets/images/products/planner.jpeg",
      "category": "Planning",
      "rating": 4.7,
      "reviews": 198,
      "description": "Comprehensive weekly planning system",
      "inStock": true,
      "weeklyRank": 3,
      "trending": false,
    },
    {
      "name": "Sketch Pad Premium",
      "price": 15.99,
      "originalPrice": 19.99,
      "image": "/placeholder.svg?height=200&width=200&text=Sketch+Pad",
      "category": "Art",
      "rating": 4.8,
      "reviews": 156,
      "description": "High-quality paper for sketching",
      "inStock": false,
      "weeklyRank": 4,
      "trending": true,
    },
    {
      "name": "Calligraphy Pen Set",
      "price": 28.99,
      "originalPrice": 35.99,
      "image": "/placeholder.svg?height=200&width=200&text=Calligraphy",
      "category": "Pens",
      "rating": 4.9,
      "reviews": 234,
      "description": "Professional calligraphy pens with nibs",
      "inStock": true,
      "weeklyRank": 5,
      "trending": true,
    },
    {
      "name": "Travel Journal",
      "price": 16.99,
      "originalPrice": 21.99,
      "image": "/placeholder.svg?height=200&width=200&text=Travel+Journal",
      "category": "Journals",
      "rating": 4.6,
      "reviews": 167,
      "description": "Compact journal for travel memories",
      "inStock": true,
      "weeklyRank": 6,
      "trending": false,
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> filtered = topProducts;
    
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
      case 'Newest':
        filtered.sort((a, b) => a['weeklyRank'].compareTo(b['weeklyRank']));
        break;
      default:
        filtered.sort((a, b) => a['weeklyRank'].compareTo(b['weeklyRank']));
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
            const Icon(Icons.trending_up, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Top of the Week',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Roboto_Condensed-Bold',
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header Stats
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('🔥', 'Hot Items', '${topProducts.where((p) => p['trending']).length}'),
                    _buildStatCard('⭐', 'Avg Rating', '4.8'),
                    _buildStatCard('📈', 'Sales Up', '+25%'),
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
          
          // Products List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return _buildProductListItem(product, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String emoji, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1B2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductListItem(Map<String, dynamic> product, int index) {
    final discount = ((product['originalPrice'] - product['price']) / product['originalPrice'] * 100).round();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Rank Badge
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: product['weeklyRank'] <= 3 ? Colors.amber : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '#${product['weeklyRank']}',
                  style: TextStyle(
                    color: product['weeklyRank'] <= 3 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Product Image
Stack(
  children: [
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 80,
        height: 80,
        color: Colors.grey[100],
        child: Image.asset(
          product['image'],
          fit: BoxFit.cover,
        ),
      ),
    ),
    if (product['trending'])
      Positioned(
        top: 4,
        right: 4,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 12,
          ),
        ),
      ),
  ],
),

            const SizedBox(width: 12),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto_Condensed-Bold',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (product['trending'])
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'HOT',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Rating and Reviews
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < product['rating'].floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 14,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '${product['rating']} (${product['reviews']})',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Price and Actions
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${product['price'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto_Condensed-Bold',
                            ),
                          ),
                          if (discount > 0)
                            Text(
                              '\$${product['originalPrice'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      
                      // Action Buttons
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Added ${product['name']} to favorites")),
                              );
                            },
                            icon: const Icon(Icons.favorite_border, color: Colors.grey),
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                          const SizedBox(width: 4),
                          ElevatedButton(
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
