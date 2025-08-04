import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalamkart_mobileapp/app/service_locator/service_locator.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/homeSections/product_view.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view_model/products_view_model.dart';

class AllProductsPage extends StatelessWidget {
  final String? category;

  // ✅ Add this new optional parameter for injecting a fake widget during tests
  final Widget Function(BuildContext context)? productViewBuilder;

  const AllProductsPage({
    super.key,
    this.category,
    this.productViewBuilder,
  });

  final List<String> categories = const [
    'All', 'Pens', 'Notebooks', 'Art Supplies', 'Office', 'Markers',
    'Geometry Tools', 'Folders & Files', 'Stationery Sets',
  ];

  @override
  Widget build(BuildContext context) {
    final isCategorySelection = category == null;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        title: Text(
          isCategorySelection ? 'Browse Categories' : '$category Products',
        ),
        backgroundColor: const Color(0xFF0A1B2E),
      ),
      body: isCategorySelection
          ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(cat),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllProductsPage(
                            category: cat,
                            productViewBuilder: productViewBuilder, // ✅ Pass along
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : BlocProvider(
              create: (_) => sl<ProductViewModel>(),
              child: productViewBuilder?.call(context) ?? ProductView(), // ✅ Use injected widget or fallback
            ),
    );
  }
}
  