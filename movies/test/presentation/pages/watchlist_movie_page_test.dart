import 'package:bloc_test/bloc_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:movies/presentation/pages/watchlist_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

void main() {
  late MockWatchlistMovieBloc mockBloc;

  final testMovies = [
    Movie(
      id: 1,
      title: 'Watchlist Movie 1',
      overview: 'Overview 1',
      posterPath: '/test1.jpg',
      voteAverage: 8.5,
      genreIds: const [28],
    ),
    Movie(
      id: 2,
      title: 'Watchlist Movie 2',
      overview: 'Overview 2',
      posterPath: '/test2.jpg',
      voteAverage: 7.5,
      genreIds: const [12],
    ),
  ];

  setUp(() {
    mockBloc = MockWatchlistMovieBloc();
  });

  // WatchlistMoviePage has no Scaffold, so we wrap it
  Widget makeTestableWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<WatchlistMovieBloc>(
          create: (_) => mockBloc,
          child: const WatchlistMoviePage(),
        ),
      ),
    );
  }

  Widget makeRoutableWidget() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (_, _) => NoTransitionPage(
            child: Scaffold(
              body: BlocProvider<WatchlistMovieBloc>(
                create: (_) => mockBloc,
                child: const WatchlistMoviePage(),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/movies/:id',
          pageBuilder: (_, _) => const NoTransitionPage(child: SizedBox()),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('should show loading indicator when state is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const WatchlistMovieState(state: MovieRequestState.loading));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show watchlist items when state is loaded', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistMovieState(
        state: MovieRequestState.loaded,
        watchlistMovies: testMovies,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Watchlist Movie 1'), findsOneWidget);
    expect(find.text('Watchlist Movie 2'), findsOneWidget);
  });

  testWidgets('should show "No watchlist yet" when watchlist is empty', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const WatchlistMovieState(
        state: MovieRequestState.loaded,
        watchlistMovies: [],
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.text('No watchlist yet'), findsOneWidget);
  });

  testWidgets('should show error message when state is error', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const WatchlistMovieState(
        state: MovieRequestState.error,
        message: 'Failed to load watchlist',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Failed to load watchlist'), findsOneWidget);
  });

  testWidgets('should show nothing when state is empty', (tester) async {
    when(() => mockBloc.state).thenReturn(const WatchlistMovieState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('pull-to-refresh triggers _onRefresh (coverage)', (tester) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistMovieState(
        state: MovieRequestState.loaded,
        watchlistMovies: testMovies,
      ),
    );

    await tester.pumpWidget(makeRoutableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Drag down to trigger refresh
    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200)); // snap animation
    await tester.pump(
      const Duration(milliseconds: 600),
    ); // Future.delayed(500ms)
    await tester.pump(const Duration(milliseconds: 400)); // dismiss animation
  });

  testWidgets('tapping watchlist item executes onTap (coverage)', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistMovieState(
        state: MovieRequestState.loaded,
        watchlistMovies: testMovies,
      ),
    );

    await tester.pumpWidget(makeRoutableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Tap MovieCard by finding it through the movie title text
    final movieTitle = find.text('Watchlist Movie 1');
    expect(movieTitle, findsOneWidget);
    await tester.tap(movieTitle, warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  });
}
