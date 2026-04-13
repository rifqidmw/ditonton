import 'package:bloc_test/bloc_test.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:movies/presentation/pages/popular_movies_page.dart';
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
      title: 'Popular Movie 1',
      overview: 'Overview 1',
      posterPath: '/test1.jpg',
      voteAverage: 8.5,
      genreIds: const [28],
    ),
    Movie(
      id: 2,
      title: 'Popular Movie 2',
      overview: 'Overview 2',
      posterPath: '/test2.jpg',
      voteAverage: 7.0,
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
        child: const PopularMoviesPage(),
      ),
    );
  }

  testWidgets('should display AppBar with title', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Popular Movies'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('should show loading indicator when state is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const MovieListState(popularState: MovieRequestState.loading));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show list when state is loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieListState(
        popularState: MovieRequestState.loaded,
        popularMovies: testMovies,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Popular Movie 1'), findsOneWidget);
    expect(find.text('Popular Movie 2'), findsOneWidget);
  });

  testWidgets('should show error message when state is error', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const MovieListState(
        popularState: MovieRequestState.error,
        popularMessage: 'Failed to load popular',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Failed to load popular'), findsOneWidget);
  });

  testWidgets('should show nothing when state is empty', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
  });
}
