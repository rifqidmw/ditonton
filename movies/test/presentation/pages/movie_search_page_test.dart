import 'package:bloc_test/bloc_test.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:movies/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:movies/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:movies/presentation/pages/movie_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieSearchBloc extends MockBloc<MovieSearchEvent, MovieSearchState>
    implements MovieSearchBloc {}

void main() {
  late MockMovieSearchBloc mockBloc;

  final testMovies = [
    Movie(
      id: 1,
      title: 'Search Result 1',
      overview: 'Overview 1',
      posterPath: '/test1.jpg',
      voteAverage: 8.5,
      genreIds: const [28],
    ),
    Movie(
      id: 2,
      title: 'Search Result 2',
      overview: 'Overview 2',
      posterPath: '/test2.jpg',
      voteAverage: 7.5,
      genreIds: const [12],
    ),
  ];

  setUpAll(() {
    registerFallbackValue(OnMovieQueryChanged(''));
  });

  setUp(() {
    mockBloc = MockMovieSearchBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<MovieSearchBloc>(
        create: (_) => mockBloc,
        child: const MovieSearchPage(),
      ),
    );
  }

  testWidgets('should display AppBar with Search title', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieSearchState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Search'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('should display search text field', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieSearchState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search Result'), findsOneWidget);
  });

  testWidgets('should show initial prompt when state is empty', (tester) async {
    when(() => mockBloc.state).thenReturn(const MovieSearchState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Search for Movies'), findsOneWidget);
  });

  testWidgets('should show loading indicator when state is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const MovieSearchState(state: MovieRequestState.loading));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show results when state is loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieSearchState(
        state: MovieRequestState.loaded,
        searchResult: testMovies,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.text('Search Result 1'), findsOneWidget);
    expect(find.text('Search Result 2'), findsOneWidget);
  });

  testWidgets('should show error message when state is error', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const MovieSearchState(
        state: MovieRequestState.error,
        message: 'Failed to search',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Failed to search'), findsOneWidget);
  });

  testWidgets('should show no results when loaded with empty list', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const MovieSearchState(state: MovieRequestState.loaded, searchResult: []),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.text('No results found'), findsOneWidget);
  });

  testWidgets('TextField onChanged dispatches event (coverage)', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const MovieSearchState());

    await tester.pumpWidget(makeTestableWidget());
    await tester.enterText(find.byType(TextField), 'batman');
    await tester.pump();

    verify(
      () => mockBloc.add(any(that: isA<OnMovieQueryChanged>())),
    ).called(greaterThanOrEqualTo(1));
  });
}
