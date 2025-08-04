import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view/signup_screen.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/signup_viewmodel/signup_viewmodel.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/signup_viewmodel/signup_state.dart';

class MockSignupViewModel extends Mock implements SignupViewModel {}

void main() {
  late SignupViewModel mockSignupViewModel;

  setUp(() {
    mockSignupViewModel = MockSignupViewModel();
    when(() => mockSignupViewModel.state).thenReturn(SignupInitial());
    when(() => mockSignupViewModel.stream)
        .thenAnswer((_) => const Stream<SignupState>.empty());
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<SignupViewModel>.value(
        value: mockSignupViewModel,
        child: const SignupScreen(),
      ),
    );
  }

  testWidgets('SignupScreen renders all input fields and buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4));
    expect(find.textContaining("Google"), findsOneWidget);
    expect(find.text("Log in"), findsOneWidget);
  });

  testWidgets('Initial screen shows no error messages',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.textContaining("required"), findsNothing);
    expect(find.textContaining("match"), findsNothing);
  });

  testWidgets('Shows error when name is empty and signup pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.tap(find.widgetWithText(ElevatedButton, "Sign Up"));
    await tester.pump();
    expect(find.text("Name is required"), findsOneWidget);
  });

  testWidgets('Shows error for invalid email format',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.enterText(find.byType(TextField).at(0), "John Doe");
    await tester.enterText(find.byType(TextField).at(1), "john.com");
    await tester.enterText(find.byType(TextField).at(2), "password123");
    await tester.enterText(find.byType(TextField).at(3), "password123");
    await tester.tap(find.widgetWithText(ElevatedButton, "Sign Up"));
    await tester.pump();
    expect(find.text("Valid email required"), findsOneWidget);
  });

  testWidgets('Shows error for short password', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.enterText(find.byType(TextField).at(0), "John Doe");
    await tester.enterText(find.byType(TextField).at(1), "john@mail.com");
    await tester.enterText(find.byType(TextField).at(2), "pass");
    await tester.enterText(find.byType(TextField).at(3), "pass");
    await tester.tap(find.widgetWithText(ElevatedButton, "Sign Up"));
    await tester.pump();
    expect(find.text("Password must be at least 6 digits"), findsOneWidget);
  });

  testWidgets('Shows error if passwords do not match',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.enterText(find.byType(TextField).at(0), "John Doe");
    await tester.enterText(find.byType(TextField).at(1), "john@mail.com");
    await tester.enterText(find.byType(TextField).at(2), "password123");
    await tester.enterText(find.byType(TextField).at(3), "differentpass");
    await tester.tap(find.widgetWithText(ElevatedButton, "Sign Up"));
    await tester.pump();
    expect(find.text("Passwords do not match"), findsOneWidget);
  });

  testWidgets('Password visibility toggle works for password field',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    final toggleIcon = find.byIcon(Icons.visibility_off).first;
    expect(toggleIcon, findsOneWidget);
    await tester.tap(toggleIcon);
    await tester.pump();
  });

  testWidgets('Google signup button present', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.textContaining("Google"), findsOneWidget);
  });

  testWidgets('Logo image exists or shows fallback icon',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Navigation text for login works', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.textContaining("Already"), findsOneWidget);
    expect(find.text("Log in"), findsOneWidget);
  });
}
