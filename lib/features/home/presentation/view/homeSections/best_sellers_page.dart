import 'package:flutter/material.dart';

class BestSellersPage extends StatefulWidget {
  const BestSellersPage({super.key});

  @override
  State<BestSellersPage> createState() => _BestSellersPageState();
}

class _BestSellersPageState extends State<BestSellersPage> {
  String selectedPeriod = 'This Month';
  String selectedFilter = 'All';
  String sortBy = 'Sales Volume';
  
  final List<String> periods = ['This Week', 'This Month', 'This Year', 'All Time'];
  final List<String> filters = ['All', 'Office', 'Writing', 'Art', 'Organization'];
  final List<String> sortOptions = ['Sales Volume', 'Revenue', 'Rating', 'Price'];

  final List<Map<String, dynamic>> bestSellers = [
    {
      "name": "Premium Sticky Notes",
      "price": 4.99,
      "originalPrice": 6.99,
      "image": "/placeholder.svg?height=200&width=200&text=Sticky+Notes",
      "category": "Office",
      "rating": 4.8,
      "reviews": 1247,
      "description": "High-quality sticky notes in multiple colors",
      "inStock": true,
      "salesRank": 1,
      "unitsSold": 15420,
      "revenue": 76998.0,
      "badge": "🏆",
    },
    {
      "name": "Executive Desk Organizer",
      "price": 18.49,
      "originalPrice": 24.99,
      "image": "/placeholder.svg?height=200&width=200&text=Desk+Organizer",
      "category": "Organization",
      "rating": 4.9,
      "reviews": 892,
      "description": "Premium wooden desk organizer with compartments",
      "inStock": true,
      "salesRank": 2,
      "unitsSold": 8934,
      "revenue": 165139.0,
      "badge": "🥈",
    },
    {
      "name": "Ballpoint Pen Set",
      "price": 12.99,
      "originalPrice": 16.99,
      "image": "/placeholder.svg?height=200&width=200&text=Ballpoint+Pens",
      "category": "Writing",
      "rating": 4.7,
      "reviews": 2156,
      "description": "Smooth writing ballpoint pens, pack of 12",
      "inStock": true,
      "salesRank": 3,
      "unitsSold": 12678,
      "revenue": 164687.0,
      "badge": "🥉",
    },
    {
      "name": "Artist Sketchbook",
      "price": 8.99,
      "originalPrice": 12.99,
      "image": "/placeholder.svg?height=200&width=200&text=Sketchbook",
      "category": "Art",
      "rating": 4.6,
      "reviews": 567,
      "description": "High-quality paper sketchbook for artists",
      "inStock": true,
      "salesRank": 4,
      "unitsSold": 7234,
      "revenue": 65053.0,
      "badge": "⭐",
    },
    {
      "name": "Paper Clips Mega Pack",
      "price": 3.99,
      "originalPrice": 5.99,
      "image": "/placeholder.svg?height=200&width=200&text=Paper+Clips",
      "category": "Office",
      "rating": 4.5,
      "reviews": 1834,
      "description": "500 premium paper clips in assorted sizes",
      "inStock": true,
      "salesRank": 5,
      "unitsSold": 18567,
      "revenue": 74092.0,
      "badge": "📎",
    },
    {
      "name": "Correction Tape Pro",
      "price": 2.99,
      "originalPrice": 4.99,
      "image": "/placeholder.svg?height=200&width=200&text=Correction+Tape",
      "category": "Office",
      "rating": 4.4,
      "reviews": 923,
      "description": "Smooth application correction tape",
      "inStock": false,
      "salesRank": 6,
      "unitsSold": 9876,
      "revenue": 29531.0,
      "badge": "✏️",
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> filtered = bestSellers;
    
    if (selectedFilter != 'All') {
      filtered = filtered.where((product) => product['category'] == selectedFilter).toList();
    }
    
    switch (sortBy) {
      case 'Revenue':
        filtered.sort((a, b) => b['revenue'].compareTo(a['revenue']));
        break;
      case 'Rating':
        filtered.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      case 'Price':
        filtered.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      default:
        filtered.sort((a, b) => b['unitsSold'].compareTo(a['unitsSold']));
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
            const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Best Sellers',
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
          // Header with Period Selector and Stats
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
                // Period Selector
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1B2E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: periods.map((period) {
                      final isSelected = selectedPeriod == period;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPeriod = period;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.amber : Colors.transparent,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: Text(
                                period,
                                style: TextStyle(
                                  color: isSelected ? Colors.black : Colors.white70,
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('💰', 'Total Revenue', '\$${(bestSellers.fold(0.0, (sum, item) => sum + item['revenue']) / 1000).toStringAsFixed(1)}K'),
                    _buildStatCard('📦', 'Units Sold', '${(bestSellers.fold<num>(0, (sum, item) => sum + item['unitsSold']) / 1000).toStringAsFixed(1)}K'),
                    _buildStatCard('⭐', 'Avg Rating', (bestSellers.fold(0.0, (sum, item) => sum + item['rating']) / bestSellers.length).toStringAsFixed(1)),
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
          
          // Products List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return _buildBestSellerCard(product, index);
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

  Widget _buildBestSellerCard(Map<String, dynamic> product, int index) {
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
        border: product['salesRank'] <= 3 
            ? Border.all(color: Colors.amber, width: 2)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank and Badge
            Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getRankColor(product['salesRank']),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '#${product['salesRank']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product['badge'],
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey[100],
                child: Image.network(
                  product['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.grey, size: 30),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto_Condensed-Bold',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Sales Stats
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${(product['unitsSold'] / 1000).toStringAsFixed(1)}K sold',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '\$${(product['revenue'] / 1000).toStringAsFixed(1)}K',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Rating
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

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.orange[700]!;
      default:
        return Colors.blue[600]!;
    }
  }
}
