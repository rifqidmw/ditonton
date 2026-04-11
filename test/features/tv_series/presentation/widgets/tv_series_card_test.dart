import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testTvSeries = TvSeries(
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

  testWidgets('should display tv series name', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(TvSeriesCard(tvSeries: testTvSeries)),
    );

    expect(find.text('Test Series'), findsOneWidget);
  });

  testWidgets('should display tv series overview', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(TvSeriesCard(tvSeries: testTvSeries)),
    );

    expect(find.text('A great overview of this series.'), findsOneWidget);
  });

  testWidgets('should call custom onTap when provided', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      makeTestableWidget(
        TvSeriesCard(tvSeries: testTvSeries, onTap: () => tapped = true),
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
      makeTestableWidget(TvSeriesCard(tvSeries: testTvSeries)),
    );

    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('should show placeholder when posterPath is null', (
    tester,
  ) async {
    final seriesWithNoPoster = TvSeries(
      id: 2,
      name: 'No Poster',
      overview: 'No poster overview',
      posterPath: null,
      voteAverage: 5.0,
      genreIds: const [],
    );

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesCard(tvSeries: seriesWithNoPoster)),
    );

    expect(find.byType(Container), findsWidgets);
  });
}
