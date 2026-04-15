import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/widgets/movie_card.dart';

void main() {
  const tMovie = Movie(
    id: 1,
    title: 'Test Movie',
    overview: 'A great overview.',
    posterPath: '/test.jpg',
    voteAverage: 8.0,
    genreIds: [],
  );

  const tMovieNoPoster = Movie(
    id: 2,
    title: 'No Poster Movie',
    overview: 'No poster overview.',
    posterPath: null,
    voteAverage: 7.0,
    genreIds: [],
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
          path: '/movies/:id',
          builder: (context, state) => const Scaffold(body: Text('Detail')),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('renders movie title', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(movie: tMovie)));
    expect(find.text('Test Movie'), findsOneWidget);
  });

  testWidgets('renders movie overview', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(movie: tMovie)));
    expect(find.text('A great overview.'), findsOneWidget);
  });

  testWidgets('shows placeholder when posterPath is null', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(MovieCard(movie: tMovieNoPoster)),
    );
    expect(find.byIcon(Icons.movie), findsOneWidget);
  });

  testWidgets('calls custom onTap when provided', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      makeTestableWidget(MovieCard(movie: tMovie, onTap: () => tapped = true)),
    );
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('renders GestureDetector without custom onTap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(movie: tMovie)));
    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('navigates to movie detail when tapped without custom onTap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeRoutableWidget(MovieCard(movie: tMovie)));
    await tester.pump();
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });
}
