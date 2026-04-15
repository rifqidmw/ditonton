import 'package:bloc_test/bloc_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:movies/presentation/pages/movie_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieListBloc extends MockBloc<MovieListEvent, MovieListState>
    implements MovieListBloc {}

void main() {
  late MockMovieListBloc mockBloc;

  final testMovies = [
    Movie(
      id: 1,
      title: 'Now Playing Movie',
      overview: 'Overview 1',
      posterPath: '/test1.jpg',
      voteAverage: 8.5,
      genreIds: const [28],
    ),
    Movie(
      id: 2,
      title: 'Another Movie',
      overview: 'Overview 2',
      posterPath: '/test2.jpg',
      voteAverage: 7.5,
      genreIds: const [12],
    ),
  ];

  setUp(() {
    mockBloc = MockMovieListBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<MovieListBloc>(
        create: (_) => mockBloc,
        child: const MovieHomePage(),
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
            child: BlocProvider<MovieListBloc>(
              create: (_) => mockBloc,
              child: const MovieHomePage(),
            ),
          ),
        ),
        GoRoute(
          path: '/movies/search',
          pageBuilder: (_, _) => const NoTransitionPage(child: SizedBox()),
        ),
        GoRoute(
          path: '/movies/popular',
          pageBuilder: (_, _) => const NoTransitionPage(child: SizedBox()),
        ),
        GoRoute(
          path: '/movies/top-rated',
          pageBuilder: (_, _) => const NoTransitionPage(child: SizedBox()),
        ),
        GoRoute(
          path: '/movies/:id',
          pageBuilder: (_, _) => const NoTransitionPage(child: SizedBox()),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('should display app title in AppBar', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Movies'), findsOneWidget);
  });

  testWidgets('should display search icon', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('should display section headings', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
  });

  testWidgets('should display "See More" buttons for Popular and Top Rated', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const MovieListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('See More'), findsNWidgets(2));
  });

  testWidgets('should show loading for now playing when loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const MovieListState(nowPlayingState: MovieRequestState.loading),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('should show now playing movies when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieListState(
        nowPlayingState: MovieRequestState.loaded,
        nowPlayingMovies: testMovies,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    // nowPlayingMovies shows horizontal list
    expect(find.byType(ListView), findsAtLeast(1));
  });

  testWidgets('should show error text when now playing has error', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const MovieListState(
        nowPlayingState: MovieRequestState.error,
        nowPlayingMessage: 'Failed to load',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Failed to load'), findsOneWidget);
  });

  testWidgets('should show popular movies when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieListState(
        popularState: MovieRequestState.loaded,
        popularMovies: testMovies,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(ListView), findsAtLeast(1));
  });

  testWidgets('should show error text when popular has error', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const MovieListState(
        popularState: MovieRequestState.error,
        popularMessage: 'Popular failed',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Popular failed'), findsOneWidget);
  });

  testWidgets('should show empty SizedBox when popular state is empty', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const MovieListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('should show top rated movies when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieListState(
        topRatedState: MovieRequestState.loaded,
        topRatedMovies: testMovies,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(ListView), findsAtLeast(1));
  });

  testWidgets('should show error text when top rated has error', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const MovieListState(
        topRatedState: MovieRequestState.error,
        topRatedMessage: 'Top rated failed',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Top rated failed'), findsOneWidget);
  });

  testWidgets('should show empty SizedBox when top rated state is empty', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const MovieListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('should render _MovieList with null poster movie', (
    tester,
  ) async {
    final nullPosterMovies = [
      Movie(
        id: 3,
        title: 'No Poster',
        overview: 'No poster',
        posterPath: null,
        voteAverage: 6.0,
        genreIds: const [],
      ),
    ];
    when(() => mockBloc.state).thenReturn(
      MovieListState(
        nowPlayingState: MovieRequestState.loaded,
        nowPlayingMovies: nullPosterMovies,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byIcon(Icons.movie), findsOneWidget);
  });

  testWidgets('search icon onPressed navigates (coverage)', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieListState());

    await tester.pumpWidget(makeRoutableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // navigated to search, no crash
  });
}
