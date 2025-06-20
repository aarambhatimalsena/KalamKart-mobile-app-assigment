import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'bottom_navigation/favorites_screen.dart';
import 'bottom_navigation/cart_screen.dart';
import 'bottom_navigation/profile_screen.dart';

const Color darkBlue = Color(0xFF0A1B2E);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  final bool _showUI = true;

  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.edit, "label": "Pens", "color": Colors.blue.shade700},
    {"icon": Icons.book, "label": "Notebooks", "color": Colors.amber.shade200},
    {"icon": Icons.brush, "label": "Art Supplies", "color": Colors.redAccent},
    {"icon": Icons.work, "label": "Office", "color": Colors.blueGrey},
    {"icon": Icons.create, "label": "Markers", "color": Colors.deepPurple},
    {"icon": Icons.architecture, "label": "Geometry Tools", "color": Colors.green},
    {"icon": Icons.folder, "label": "Folders & Files", "color": Colors.orange},
    {"icon": Icons.widgets, "label": "Stationery Sets", "color": Colors.pink},
  ];

  final List<Map<String, dynamic>> featuredProducts = [
    {
      "name": "Gel Pens",
      "price": "\$8.99",
      "image": "assets/images/products/gel_pens.jpeg",
    },
    {
      "name": "Spiral Notebook",
      "price": "\$12.99",
      "image": "assets/images/products/spiral_notebook.jpeg",
    },
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: darkBlue,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Widget _buildBannerSlider() {
    final banners = [
      'assets/images/banner.png',
      'assets/images/banner2.png',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 1.0,
        ),
        items: banners.map((banner) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                banner,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: cat['color'],
                  radius: 24,
                  child: Icon(cat['icon'], color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  cat['label'],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'Roboto_Condensed-Italic',
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDashboardUI() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            children: [
              const SizedBox(height: 16),
              const Text(
                "Welcome to KalamKart!",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: 'Roboto_Condensed-Bold',
                ),
              ),
              const SizedBox(height: 16),
              _buildBannerSlider(),
              const SizedBox(height: 16),
              const Text(
                "Discover your favorite stationery items",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontFamily: 'Roboto_Condensed-Italic',
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: darkBlue),
                    hintText: 'Search',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Categories",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Roboto_Condensed-Bold',
                ),
              ),
              const SizedBox(height: 12),
              _buildCategories(),
              const SizedBox(height: 24),
              const Text(
                "Featured Products",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Roboto_Condensed-Bold',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final product = featuredProducts[index];
                    return Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                            child: Image.asset(
                              product['image'],
                              height: 120,
                              width: 150,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto_SemiCondensed-Regular',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              product['price'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontFamily: 'Roboto_SemiCondensed-Regular',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ✅ TEMPORARY DEBUG BUTTON
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/debug');
                },
                child: const Text("🔍 Open Hive Debug"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        backgroundColor: darkBlue,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: false,
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: darkBlue),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Roboto_Condensed-Bold',
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  "Logout",
                  style: TextStyle(fontFamily: 'Roboto_Condensed-Bold'),
                ),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: darkBlue,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Row(
            children: [
              Image.asset(
                'assets/images/KalamKart_logo.png',
                height: 38,
                gaplessPlayback: true,
              ),
              const SizedBox(width: 10),
              const Text(
                'KalamKart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Roboto_Condensed-Bold',
                ),
              ),
            ],
          ),
        ),
        body: !_showUI
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: darkBlue,
                child: _buildDashboardUI(),
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: darkBlue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() => currentIndex = index);
            Future.delayed(const Duration(milliseconds: 100), () {
              if (!mounted) return;
              setState(() => currentIndex = 0);
              if (index == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
              } else if (index == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
              } else if (index == 3) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              }
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
