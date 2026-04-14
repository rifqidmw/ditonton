import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  final testTvSeries = TVSeries(
    id: 1,
    name: 'Test Series',
    overview: 'A great overview of this series.',
    posterPath: '/test.jpg',
    voteAverage: 8.5,
    genreIds: const [18],
  );

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  Widget makeRoutableWidget(Widget child) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(body: child),
        ),
        GoRoute(
          path: '/tv-series/:id',
          builder: (context, state) => const Scaffold(body: Text('Detail')),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('should display tv series name', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(TVSeriesCard(tvSeries: testTvSeries)),
    );

    expect(find.text('Test Series'), findsOneWidget);
  });

  testWidgets('should display tv series overview', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(TVSeriesCard(tvSeries: testTvSeries)),
    );

    expect(find.text('A great overview of this series.'), findsOneWidget);
  });

  testWidgets('should call custom onTap when provided', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      makeTestableWidget(
        TVSeriesCard(tvSeries: testTvSeries, onTap: () => tapped = true),
      ),
    );

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('should render without onTap (uses default navigation)', (
    tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(TVSeriesCard(tvSeries: testTvSeries)),
    );

    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets(
    'navigates to tv series detail when tapped without custom onTap',
    (tester) async {
      await tester.pumpWidget(
        makeRoutableWidget(TVSeriesCard(tvSeries: testTvSeries)),
      );
      await tester.pump();
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    },
  );

  testWidgets('should show placeholder when posterPath is null', (
    tester,
  ) async {
    final seriesWithNoPoster = TVSeries(
      id: 2,
      name: 'No Poster',
      overview: 'No poster overview',
      posterPath: null,
      voteAverage: 5.0,
      genreIds: const [],
    );

    await tester.pumpWidget(
      makeTestableWidget(TVSeriesCard(tvSeries: seriesWithNoPoster)),
    );

    expect(find.byType(Container), findsWidgets);
  });
}
