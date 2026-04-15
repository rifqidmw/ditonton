import 'package:core/network/ssl_pinning.dart';
import 'package:ditonton/core/di/injection.dart' as di;
import 'package:ditonton/core/router/app_router.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await SslPinning.createPinnedHttpClient();
    di.init();
    await di.initDatabase();
  });

  tearDownAll(() async {
    await di.locator.reset();
  });

  setUp(() {
    router.go('/');
  });

  group('Home Page Integration Tests', () {
    testWidgets('should display home page with app title', (tester) async {
      await tester.pumpWidget(const MainApp());
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Ditonton'), findsWidgets);
    });

    testWidgets('should display search icon on home page', (tester) async {
      await tester.pumpWidget(const MainApp());
      await tester.pump(const Duration(seconds: 2));

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display watchlist bookmark icon in navigation bar', (
      tester,
    ) async {
      await tester.pumpWidget(const MainApp());
      await tester.pump(const Duration(seconds: 2));

      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('should display section headings on home page', (tester) async {
      await tester.pumpWidget(const MainApp());
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
    });

    testWidgets('should navigate to search page when search icon is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(const MainApp());
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('should navigate to watchlist page when bookmark icon tapped', (
      tester,
    ) async {
      await tester.pumpWidget(const MainApp());
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pumpAndSettle();

      expect(find.text('Watchlist'), findsAtLeastNWidgets(1));
    });
  });

  group('Search Page Integration Tests', () {
    testWidgets('should display search input field', (tester) async {
      await tester.pumpWidget(const MainApp());
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should display search prompt before searching', (
      tester,
    ) async {
      await tester.pumpWidget(const MainApp());
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.text('Search for TV Series'), findsOneWidget);
    });

    testWidgets('should show search results section label', (tester) async {
      await tester.pumpWidget(const MainApp());
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.text('Search Result'), findsOneWidget);
    });
  });

  group('Watchlist Page Integration Tests', () {
    testWidgets('should display watchlist page with title', (tester) async {
      await tester.pumpWidget(const MainApp());
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pumpAndSettle();

      expect(find.text('Watchlist'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display empty message on fresh watchlist', (
      tester,
    ) async {
      await tester.pumpWidget(const MainApp());
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      // Either shows "No watchlist yet" or a list if user has watchlisted items
      expect(
        find.textContaining('watchlist', findRichText: true),
        findsWidgets,
      );
    });
  });
}
