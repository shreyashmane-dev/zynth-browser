import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zynth_browser/core/theme/app_theme.dart';
import 'package:zynth_browser/features/browser/browser_controller.dart';
import 'package:zynth_browser/features/browser/presentation/widgets/browser_app_bar.dart';
import 'package:zynth_browser/features/browser/presentation/widgets/browser_bottom_bar.dart';
import 'package:zynth_browser/features/browser/presentation/widgets/browser_home_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Browser UI Widget Tests', () {
    testWidgets('BrowserHomeView displays branding and search elements', (
      WidgetTester tester,
    ) async {
      final controller = BrowserController();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(body: BrowserHomeView(controller: controller)),
        ),
      );

      // Verify Brand elements
      expect(find.text('ZYNTH'), findsOneWidget);
      expect(find.text('Performance • Autonomy • Clarity'), findsOneWidget);
      expect(find.text('QUICK ACCESS'), findsOneWidget);

      // Verify quick shortcuts are visible
      expect(find.text('Zynth Search'), findsOneWidget);
      expect(find.text('Flutter Docs'), findsOneWidget);
      expect(find.text('GitHub'), findsOneWidget);
    });

    testWidgets('BrowserAppBar renders address field and provider selector', (
      WidgetTester tester,
    ) async {
      final controller = BrowserController();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(appBar: BrowserAppBar(controller: controller)),
        ),
      );

      // Verify text field exists
      expect(find.byType(TextField), findsOneWidget);

      // Verify provider dropdown icon exists
      expect(find.byIcon(Icons.arrow_drop_down_rounded), findsOneWidget);
    });

    testWidgets('BrowserBottomBar renders navigation controls', (
      WidgetTester tester,
    ) async {
      final controller = BrowserController();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            bottomNavigationBar: BrowserBottomBar(controller: controller),
          ),
        ),
      );

      // Verify bottom controls
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios_rounded), findsOneWidget);
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz_rounded), findsOneWidget);
    });
  });
}
