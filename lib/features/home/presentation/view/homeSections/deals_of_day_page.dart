import 'package:flutter/material.dart';
import 'dart:async';

class DealsOfDayPage extends StatefulWidget {
  const DealsOfDayPage({super.key});

  @override
  State<DealsOfDayPage> createState() => _DealsOfDayPageState();
}

class _DealsOfDayPageState extends State<DealsOfDayPage> with TickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _pulseController;
  Duration timeLeft = const Duration(hours: 23, minutes: 45, seconds: 30);
  
  String selectedFilter = 'All';
  String sortBy = 'Discount %';
  
  final List<String> filters = ['All', 'Office', 'Art', 'Writing', 'Tech'];
  final List<String> sortOptions = ['Discount %', 'Price: Low to High', 'Time Left', 'Popularity'];

  final List<Map<String, dynamic>> dealsProducts = [
    {
      "name": "Premium Sketchbook A4",
      "price": 7.99,
      "originalPrice": 15.99,
      "image": "/placeholder.svg?height=200&width=200&text=Sketchbook",
      "category": "Art",
      "rating": 4.8,
      "reviews": 234,
      "description": "High-quality paper sketchbook for artists",
      "inStock": true,
      "timeLeft": const Duration(hours: 2, minutes: 15),
      "claimed": 67,
      "totalDeals": 100,
      "isFlashDeal": true,
    },
    {
      "name": "Geometry Tool Set",
      "price": 4.25,
      "originalPrice": 12.99,
      "image": "/placeholder.svg?height=200&width=200&text=Geometry+Set",
      "category": "Office",
      "rating": 4.6,
      "reviews": 189,
      "description": "Complete geometry set with compass and ruler",
      "inStock": true,
      "timeLeft": const Duration(hours: 5, minutes: 30),
      "claimed": 23,
      "totalDeals": 50,
      "isFlashDeal": false,
    },
    {
      "name": "Digital Stylus Pro",
      "price": 29.99,
      "originalPrice": 59.99,
      "image": "/placeholder.svg?height=200&width=200&text=Digital+Stylus",
      "category": "Tech",
      "rating": 4.9,
      "reviews": 456,
      "description": "Precision stylus for digital drawing",
      "inStock": true,
      "timeLeft": const Duration(hours: 8, minutes: 45),
      "claimed": 89,
      "totalDeals": 150,
      "isFlashDeal": true,
    },
    {
      "name": "Fountain Pen Classic",
      "price": 19.99,
      "originalPrice": 39.99,
      "image": "/placeholder.svg?height=200&width=200&text=Fountain+Pen",
      "category": "Writing",
      "rating": 4.7,
      "reviews": 312,
      "description": "Elegant fountain pen with gold nib",
      "inStock": false,
      "timeLeft": const Duration(hours: 12, minutes: 20),
      "claimed": 45,
      "totalDeals": 45,
      "isFlashDeal": false,
    },
    {
      "name": "Watercolor Paint Set",
      "price": 16.99,
      "originalPrice": 34.99,
      "image": "/placeholder.svg?height=200&width=200&text=Watercolor",
      "category": "Art",
      "rating": 4.8,
      "reviews": 198,
      "description": "Professional watercolor paints with brushes",
      "inStock": true,
      "timeLeft": const Duration(hours: 18, minutes: 10),
      "claimed": 34,
      "totalDeals": 75,
      "isFlashDeal": true,
    },
    {
      "name": "Smart Notebook",
      "price": 24.99,
      "originalPrice": 49.99,
      "image": "/placeholder.svg?height=200&width=200&text=Smart+Notebook",
      "category": "Tech",
      "rating": 4.5,
      "reviews": 167,
      "description": "Reusable notebook with cloud sync",
      "inStock": true,
      "timeLeft": const Duration(hours: 20, minutes: 55),
      "claimed": 12,
      "totalDeals": 30,
      "isFlashDeal": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft.inSeconds > 0) {
          timeLeft = Duration(seconds: timeLeft.inSeconds - 1);
        } else {
          timeLeft = const Duration(hours: 24); // Reset for next day
        }
      });
    });
  }

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> filtered = dealsProducts;
    
    if (selectedFilter != 'All') {
      filtered = filtered.where((product) => product['category'] == selectedFilter).toList();
    }
    
    switch (sortBy) {
      case 'Price: Low to High':
        filtered.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Time Left':
        filtered.sort((a, b) => a['timeLeft'].inSeconds.compareTo(b['timeLeft'].inSeconds));
        break;
      case 'Popularity':
        filtered.sort((a, b) => b['reviews'].compareTo(a['reviews']));
        break;
      default:
        filtered.sort((a, b) {
          final discountA = ((a['originalPrice'] - a['price']) / a['originalPrice'] * 100);
          final discountB = ((b['originalPrice'] - b['price']) / b['originalPrice'] * 100);
          return discountB.compareTo(discountA);
        });
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
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.1),
                  child: const Icon(Icons.local_offer, color: Colors.red, size: 24),
                );
              },
            ),
            const SizedBox(width: 8),
            const Text(
              'Deals of the Day',
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
          // Countdown Timer Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade700, Colors.red.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  '⏰ Limited Time Offers!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Deals refresh in:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Countdown Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimeUnit(timeLeft.inHours.toString().padLeft(2, '0'), 'Hours'),
                    const Text(' : ', style: TextStyle(color: Colors.white, fontSize: 24)),
                    _buildTimeUnit((timeLeft.inMinutes % 60).toString().padLeft(2, '0'), 'Minutes'),
                    const Text(' : ', style: TextStyle(color: Colors.white, fontSize: 24)),
                    _buildTimeUnit((timeLeft.inSeconds % 60).toString().padLeft(2, '0'), 'Seconds'),
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
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedFilter,
                            dropdownColor: const Color(0xFF1A2B3E),
                            style: const TextStyle(color: Colors.white),
                            icon: const Icon(Icons.filter_list, color: Colors.white),
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
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: sortBy,
                            dropdownColor: const Color(0xFF1A2B3E),
                            style: const TextStyle(color: Colors.white),
                            icon: const Icon(Icons.sort, color: Colors.white),
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
                childAspectRatio: 0.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return _buildDealCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDealCard(Map<String, dynamic> product) {
    final discount = ((product['originalPrice'] - product['price']) / product['originalPrice'] * 100).round();
    final progress = product['claimed'] / product['totalDeals'];
    final isAlmostSoldOut = progress > 0.8;
    
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
        border: product['isFlashDeal'] 
            ? Border.all(color: Colors.red, width: 2)
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
              
              // Discount Badge
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
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // Flash Deal Badge
              if (product['isFlashDeal'])
                Positioned(
                  top: 8,
                  right: 8,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.flash_on,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            const Text(
                              'FLASH',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              
              // Time Left
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
                      const Icon(Icons.access_time, color: Colors.white, size: 10),
                      const SizedBox(width: 2),
                      Text(
                        '${product['timeLeft'].inHours}h ${product['timeLeft'].inMinutes % 60}m',
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
                  
                  const SizedBox(height: 8),
                  
                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Claimed: ${product['claimed']}/${product['totalDeals']}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          if (isAlmostSoldOut)
                            const Text(
                              'Almost Gone!',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isAlmostSoldOut ? Colors.red : Colors.green,
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
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto_Condensed-Bold',
                        ),
                      ),
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
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: product['inStock'] && progress < 1.0 ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Added ${product['name']} to cart")),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: product['inStock'] && progress < 1.0
                            ? Colors.red 
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        !product['inStock'] 
                            ? 'Out of Stock'
                            : progress >= 1.0 
                                ? 'Sold Out'
                                : 'Grab Deal',
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
