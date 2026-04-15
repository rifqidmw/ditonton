import 'package:bloc_test/bloc_test.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';
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
      title: 'Top Rated Movie 1',
      overview: 'Overview 1',
      posterPath: '/test1.jpg',
      voteAverage: 9.0,
      genreIds: const [28],
    ),
    Movie(
      id: 2,
      title: 'Top Rated Movie 2',
      overview: 'Overview 2',
      posterPath: '/test2.jpg',
      voteAverage: 8.8,
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
        child: const TopRatedMoviesPage(),
      ),
    );
  }

  testWidgets('should display AppBar with title', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Top Rated Movies'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('should show loading indicator when state is loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const MovieListState(topRatedState: MovieRequestState.loading),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show list when state is loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieListState(
        topRatedState: MovieRequestState.loaded,
        topRatedMovies: testMovies,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Top Rated Movie 1'), findsOneWidget);
    expect(find.text('Top Rated Movie 2'), findsOneWidget);
  });

  testWidgets('should show error message when state is error', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const MovieListState(
        topRatedState: MovieRequestState.error,
        topRatedMessage: 'Failed to load top rated',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Failed to load top rated'), findsOneWidget);
  });

  testWidgets('should show nothing when state is empty', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
  });
}
