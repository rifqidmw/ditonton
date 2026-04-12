import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/features/movies/domain/entities/movie.dart';
import 'package:ditonton/features/movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/features/movies/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';
import 'package:ditonton/features/movies/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:ditonton/features/movies/presentation/pages/watchlist_movie_page.dart';
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
}
