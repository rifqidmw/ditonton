import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/features/movies/domain/entities/movie.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:ditonton/features/movies/presentation/pages/movie_home_page.dart';
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
}
