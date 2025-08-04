import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/homeSections/all_products_page.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view_model/products_view_model.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view_model/product_state.dart';

class MockProductViewModel extends Mock implements ProductViewModel {}

void main() {
  late MockProductViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockProductViewModel();

    // ✅ FIX: Register the fallback value for ProductState, not a nonexistent ProductInitial
    registerFallbackValue(ProductState.initial());

    // ✅ Provide fake state and stream
    when(() => mockViewModel.state).thenReturn(ProductState.initial());
    when(() => mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildTestableWidget({String? category}) {
    return MaterialApp(
      home: BlocProvider<ProductViewModel>.value(
        value: mockViewModel,
        child: AllProductsPage(
          category: category,
          productViewBuilder: (context) => const Text('FAKE PRODUCT VIEW'),
        ),
      ),
    );
  }

  group('AllProductsPage Bloc-Based Fake Tests', () {
    testWidgets('shows Browse Categories title', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.text('Browse Categories'), findsOneWidget);
    });

    testWidgets('shows 9 categories with ListTile', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(ListTile), findsNWidgets(9));
    });

    testWidgets('has arrow icon for each category tile', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byIcon(Icons.arrow_forward_ios), findsNWidgets(9));
    });

    testWidgets('navigates to fake product view on category tap', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.tap(find.text('Pens'));
      await tester.pumpAndSettle();
      expect(find.text('Pens Products'), findsOneWidget);
      expect(find.text('FAKE PRODUCT VIEW'), findsOneWidget);
    });

    testWidgets('renders app bar in category selection', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('has expected categories visible', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.text('Office'), findsOneWidget);
      expect(find.text('Markers'), findsOneWidget);
    });

    testWidgets('title font style exists on category tile', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final text = tester.widget<Text>(find.text('Notebooks'));
      expect(text.style?.fontSize, isNotNull);
    });

    testWidgets('category tap triggers navigation with AppBar update', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.tap(find.text('Stationery Sets'));
      await tester.pumpAndSettle();
      expect(find.text('Stationery Sets Products'), findsOneWidget);
    });

    testWidgets('category tap test for Geometry Tools', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.tap(find.text('Geometry Tools'));
      await tester.pumpAndSettle();
      expect(find.text('Geometry Tools Products'), findsOneWidget);
    });

    testWidgets('renders without crash on small screen', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(320, 480);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(buildTestableWidget());
      expect(tester.takeException(), isNull);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('category navigation works multiple times', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.tap(find.text('Art Supplies'));
      await tester.pumpAndSettle();
      expect(find.text('Art Supplies Products'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Folders & Files'));
      await tester.pumpAndSettle();
      expect(find.text('Folders & Files Products'), findsOneWidget);
    });

    testWidgets('does not render product view when category is null', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.text('FAKE PRODUCT VIEW'), findsNothing);
    });

    testWidgets('fake bloc state does not crash when empty', (tester) async {
      when(() => mockViewModel.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockViewModel.state).thenReturn(ProductState.initial());
      await tester.pumpWidget(buildTestableWidget(category: 'Test'));
      expect(find.text('FAKE PRODUCT VIEW'), findsOneWidget);
    });

    testWidgets('background is dark navy', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF0A1B2E));
    });

    testWidgets('all tests pass without Dio/API calls', (tester) async {
      await tester.pumpWidget(buildTestableWidget(category: 'Fake'));
      expect(find.text('FAKE PRODUCT VIEW'), findsOneWidget);
    });


        testWidgets('renders MaterialApp correctly', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('ListView is used for category display', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders all category names correctly', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final categories = [
        'All', 'Pens', 'Notebooks', 'Art Supplies', 'Office',
        'Markers', 'Geometry Tools', 'Folders & Files', 'Stationery Sets'
      ];
      for (final cat in categories) {
        expect(find.text(cat), findsOneWidget);
      }
    });

    testWidgets('AppBar title matches passed category', (tester) async {
      await tester.pumpWidget(buildTestableWidget(category: 'Markers'));
      expect(find.text('Markers Products'), findsOneWidget);
    });

    testWidgets('Card widget wraps each ListTile', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(Card), findsNWidgets(9));
    });

    testWidgets('ListTile has correct trailing icon', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final tile = tester.widget<ListTile>(find.text('Pens'));
      expect(tile.trailing, isA<Icon>());
    });

    testWidgets('ListTile has onTap callback', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final tile = tester.widget<ListTile>(find.text('Notebooks'));
      expect(tile.onTap, isNotNull);
    });

    testWidgets('AppBar background color is correct', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, const Color(0xFF0A1B2E));
    });

    testWidgets('Rebuilding widget doesn’t crash', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpWidget(buildTestableWidget());
      expect(tester.takeException(), isNull);
    });

    testWidgets('scrolling category list works', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.drag(find.byType(ListView), const Offset(0, -100));
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsNWidgets(9)); // Still present
    });

  });
}
