import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalamkart_mobileapp/app/service_locator/service_locator.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view/login_screen.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/bottom_navigation/cart_screen.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/bottom_navigation/favorites_screen.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/bottom_navigation/my_orders_screen.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/bottom_navigation/profile_screen.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/homeSections/best_sellers_page.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/homeSections/deals_of_day_page.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/homeSections/featured_products_page.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/homeSections/product_view.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/homeSections/top_of_week_page.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/homeSections/trending_now_page.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/homeSections/all_products_page.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view_model/products_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const Color darkBlue = Color(0xFF0A1B2E);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  final bool _showUI = true;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.edit, "label": "Pens", "color": Colors.blue.shade700},
    {"icon": Icons.book, "label": "Notebooks", "color": Colors.amber.shade200},
    {"icon": Icons.brush, "label": "Art Supplies", "color": Colors.redAccent},
    {"icon": Icons.work, "label": "Office", "color": Colors.blueGrey},
    {"icon": Icons.create, "label": "Markers", "color": Colors.deepPurple},
    {
      "icon": Icons.architecture,
      "label": "Geometry Tools",
      "color": Colors.green,
    },
    {"icon": Icons.folder, "label": "Folders & Files", "color": Colors.orange},
    {"icon": Icons.widgets, "label": "Stationery Sets", "color": Colors.pink},
  ];

  final List<Map<String, dynamic>> dealsOfTheDay = [
    {
      "name": "Sketchbook A4",
      "price": "Npr 7.99",
      "originalPrice": "Npr 12.99",
      "image": "/placeholder.svg?height=120&width=150&text=Sketchbook",
    },
    {
      "name": "Geometry Set",
      "price": "Npr 4.25",
      "originalPrice": "Npr 8.99",
      "image": "/placeholder.svg?height=120&width=150&text=Geometry+Set",
    },
    {
      "name": "Fountain Pen",
      "price": "Npr 19.99",
      "originalPrice": "Npr 29.99",
      "image": "/placeholder.svg?height=120&width=150&text=Fountain+Pen",
    },
    {
      "name": "Paper Clips Set",
      "price": "Npr 1.99",
      "originalPrice": "Npr 3.99",
      "image": "/placeholder.svg?height=120&width=150&text=Paper+Clips",
    },
  ];

  final List<Map<String, dynamic>> featuredProducts = [
    {
      "name": "Gel Pens",
      "price": "Npr 8.99",
      "image": "assets/images/products/gel_pens.jpeg",
    },
    {
      "name": "Spiral Notebook",
      "price": "Npr 12.99",
      "image": "assets/images/products/spiral_notebook.jpeg",
    },
    {
      "name": "Marker Set",
      "price": "Npr 15.99",
      "image": "assets/images/products/marker_set.jpeg",
    },
    {
      "name": "Pencil Case",
      "price": "Npr 9.99",
      "image": "assets/images/products/pencil_case.jpeg",
    },
  ];

  final List<Map<String, dynamic>> topOfWeekProducts = [
    {
      "name": "Bullet Journal",
      "price": "Npr 10.99",
       "image": "assets/images/products/bullet_journal.jpeg",
    },
    {
      "name": "Fineliners",
      "price": "Npr 6.75",
       "image": "assets/images/products/fine_liner.jpeg",
    },
    {
      "name": "Washi Tape",
      "price": "Npr 4.99",
       "image": "assets/images/products/Washi_Tape.jpeg",
    },
    {
      "name": "Planner",
      "price": "Npr 18.99",
       "image": "assets/images/products/planner.jpeg",
    },
  ];

  final List<Map<String, dynamic>> trendingProducts = [
    {
      "name": "Highlighters Set",
      "price": "Npr 5.49",
      "image": "/placeholder.svg?height=120&width=150&text=Highlighters",
    },
    {
      "name": "Art Brush Set",
      "price": "Npr 15.99",
      "image": "/placeholder.svg?height=120&width=150&text=Art+Brushes",
    },
    {
      "name": "Colored Pencils",
      "price": "Npr 12.49",
      "image": "/placeholder.svg?height=120&width=150&text=Colored+Pencils",
    },
    {
      "name": "Sketchpad",
      "price": "Npr 8.99",
      "image": "/placeholder.svg?height=120&width=150&text=Sketchpad",
    },
  ];

  final List<Map<String, dynamic>> bestSellers = [
    {
      "name": "Sticky Notes Pack",
      "price": "Npr 3.99",
      "image": "/placeholder.svg?height=120&width=150&text=Sticky+Notes",
    },
    {
      "name": "Desk Organizer",
      "price": "Npr 11.49",
      "image": "/placeholder.svg?height=120&width=150&text=Desk+Organizer",
    },
    {
      "name": "Correction Tape",
      "price": "Npr 2.99",
      "image": "/placeholder.svg?height=120&width=150&text=Correction+Tape",
    },
    {
      "name": "Stapler",
      "price": "Npr 7.99",
      "image": "/placeholder.svg?height=120&width=150&text=Stapler",
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
      "/placeholder.svg?height=180&width=400&text=Banner+1",
      "/placeholder.svg?height=180&width=400&text=Banner+2",
      "/placeholder.svg?height=180&width=400&text=Banner+3",
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          enlargeCenterPage: true,
          viewportFraction: 0.95,
          enableInfiniteScroll: true,
        ),
        items:
            banners.map((banner) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber.shade400, Colors.orange.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Image.network(
                      banner,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade400,
                                Colors.orange.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Special Offers',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Up to 50% Off',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider(
                          create:
                              (context) =>
                                  ProductViewModel(getAllProductsUsecase: sl()),
                          child: const ProductView(),
                        ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: cat['color'],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cat['color'].withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(cat['icon'], color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 70,
                    child: Text(
                      cat['label'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontFamily: 'Roboto_Condensed-Regular',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildProductSection(
    String title,
    List<Map<String, dynamic>> products, {
    bool showDiscount = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Roboto_Condensed-Bold',
                  ),
                ),
                if (showDiscount) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'SALE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            GestureDetector(
              onTap: () {
                Widget targetPage;
                switch (title) {
                  case "Featured Products":
                    targetPage = const FeaturedProductsPage();
                    break;
                  case "Top of the Week":
                    targetPage = const TopOfWeekPage();
                    break;
                  case "Trending Now":
                    targetPage = const TrendingNowPage();
                    break;
                  case "Best Sellers":
                    targetPage = const BestSellersPage();
                    break;
                  case "Deals of the Day":
                    targetPage = const DealsOfDayPage();
                    break;
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("See All: Npr title")),
                    );
                    return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => targetPage),
                );
              },
              child: const Text(
                "See All",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 14,
                  fontFamily: 'Roboto_Condensed-Regular',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Product: Npr {product['name']}")),
                  );
                },
                child: Container(
                  width: 160,
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
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Container(
                              height: 130,
                              width: 160,
                              color: Colors.grey[100],
                              child: product['image'].toString().startsWith('assets/')
    ? Image.asset(
        product['image'],
        height: 130,
        width: 160,
        fit: BoxFit.cover,
      )
    : Image.network(
        product['image'],
        height: 130,
        width: 160,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(
                Icons.image,
                color: Colors.grey,
                size: 40,
              ),
            ),
          );
        },
      ),

                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Added Npr {product['name']} to favorites",
                                    ),
                                  ),
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
                          if (showDiscount && product['originalPrice'] != null)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'SALE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              const Spacer(),
                              Row(
                                children: [
                                  Text(
                                    product['price'],
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto_Condensed-Bold',
                                    ),
                                  ),
                                  if (showDiscount &&
                                      product['originalPrice'] != null) ...[
                                    const SizedBox(width: 4),
                                    Text(
                                      product['originalPrice'],
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
                              SizedBox(
                                width: double.infinity,
                                height: 32,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Added Npr {product['name']} to cart",
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: darkBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text(
                                    'Add to Cart',
                                    style: TextStyle(
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: darkBlue),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune, color: darkBlue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Filter options coming soon!")),
              );
            },
          ),
          hintText: 'Search for stationery...',
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Searching for: Npr value")));
          }
        },
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
                  fontSize: 28,
                  color: Colors.white,
                  fontFamily: 'Roboto_Condensed-Bold',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Discover premium stationery for every need",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontFamily: 'Roboto_Condensed-Regular',
                ),
              ),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildBannerSlider(),
              const SizedBox(height: 24),
              const Text(
                "Shop by Category",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Roboto_Condensed-Bold',
                ),
              ),
              const SizedBox(height: 12),
              _buildCategories(),
              _buildProductSection("Featured Products", featuredProducts),
              _buildProductSection("Top of the Week", topOfWeekProducts),
              _buildProductSection("Trending Now", trendingProducts),
              _buildProductSection("Best Sellers", bestSellers),
              _buildProductSection(
                "Deals of the Day",
                dealsOfTheDay,
                showDiscount: true,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToScreen(int index) {
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        ).then((_) {
          // Reload UI or reset state after coming back from favorites
          setState(() {});
        });
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
        break;
      case 3:
        // Navigate to Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        backgroundColor: darkBlue,
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [darkBlue, Color(0xFF1A2B3E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: darkBlue,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'KalamKart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Roboto_Condensed-Bold',
                      ),
                    ),
                    const Text(
                      'Premium Stationery Store',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: darkBlue),
                title: const Text(
                  "Home",
                  style: TextStyle(fontFamily: 'Roboto_Condensed-Regular'),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.category, color: darkBlue),
                title: const Text(
                  "Categories",
                  style: TextStyle(fontFamily: 'Roboto_Condensed-Regular'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllProductsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_offer, color: darkBlue),
                title: const Text(
                  "Offers",
                  style: TextStyle(fontFamily: 'Roboto_Condensed-Regular'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Offers coming soon!")),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.help, color: darkBlue),
                title: const Text(
                  "Help & Support",
                  style: TextStyle(fontFamily: 'Roboto_Condensed-Regular'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Help & Support coming soon!"),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    fontFamily: 'Roboto_Condensed-Regular',
                    color: Colors.red,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context); // close drawer

                  await secureStorage.deleteAll();

                  final all = await secureStorage.readAll();
                  print('🧹 Secure storage after delete: $all');

                  if (!mounted) return;

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
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
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
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
          actions: [
            IconButton(
              icon: const Icon(
                Icons.receipt_long_outlined,
                color: Colors.white,
              ),
              tooltip: "My Orders",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
                );
              },
            ),
          ],
        ),
        body:
            !_showUI
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                )
                : Container(color: darkBlue, child: _buildDashboardUI()),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: darkBlue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 8,
          onTap: (index) {
            setState(() => currentIndex = index);
            Future.delayed(const Duration(milliseconds: 100), () {
              if (!mounted) return;
              setState(() => currentIndex = 0);
              _navigateToScreen(index);
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
