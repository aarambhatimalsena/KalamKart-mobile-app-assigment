
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/homeSections/all_products_page.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/homeSections/product_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view_model/products_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kalamkart_mobileapp/app/service_locator/service_locator.dart' as di;

class MockProductViewModel extends Mock implements ProductViewModel {}

void main() {
  setUpAll(() async {
    await di.init(); // make sure service locator is initialized
  });

  group('AllProductsPage Tests - Category Selection View', () {
    testWidgets('displays app bar with "Browse Categories"', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AllProductsPage()));
      expect(find.text('Browse Categories'), findsOneWidget);
    });

    testWidgets('renders list of categories', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AllProductsPage()));
      expect(find.byType(ListTile), findsNWidgets(9));
      expect(find.text('Pens'), findsOneWidget);
      expect(find.text('Art Supplies'), findsOneWidget);
    });

    testWidgets('navigates to category page on tap', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AllProductsPage()));
      await tester.tap(find.text('Notebooks'));
      await tester.pumpAndSettle();
      expect(find.text('Notebooks Products'), findsOneWidget);
    });

    testWidgets('category card has arrow icon', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AllProductsPage()));
      expect(find.byIcon(Icons.arrow_forward_ios), findsWidgets);
    });

  
  });

  group('AllProductsPage Tests - Category Products View', () {
   

    testWidgets('renders ProductView when category is passed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductViewModel>(
            create: (_) => MockProductViewModel(),
            child: const AllProductsPage(category: 'Office'),
          ),
        ),
      );
      expect(find.byType(ProductView), findsOneWidget);
    });

    testWidgets('background color is dark navy', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AllProductsPage()));
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF0A1B2E));
    });

    testWidgets('AppBar is rendered properly', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AllProductsPage()));
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
