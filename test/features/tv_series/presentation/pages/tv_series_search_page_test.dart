import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_search/tv_series_search_event.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_search/tv_series_search_state.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesSearchBloc
    extends MockBloc<TvSeriesSearchEvent, TvSeriesSearchState>
    implements TvSeriesSearchBloc {}

void main() {
  late MockTvSeriesSearchBloc mockBloc;

  final testTvSeries = [
    TvSeries(
      id: 1,
      name: 'Search Result 1',
      overview: 'Overview 1',
      posterPath: '/test1.jpg',
      voteAverage: 8.5,
      genreIds: const [18],
    ),
    TvSeries(
      id: 2,
      name: 'Search Result 2',
      overview: 'Overview 2',
      posterPath: '/test2.jpg',
      voteAverage: 7.5,
      genreIds: const [10765],
    ),
  ];

  setUp(() {
    mockBloc = MockTvSeriesSearchBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<TvSeriesSearchBloc>(
        create: (_) => mockBloc,
        child: const TvSeriesSearchPage(),
      ),
    );
  }

  testWidgets('should display AppBar with Search title', (tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesSearchState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Search'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('should display search text field', (tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesSearchState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search Result'), findsOneWidget);
  });

  testWidgets('should show initial prompt when state is empty', (tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesSearchState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Search for TV Series'), findsOneWidget);
  });

  testWidgets('should show loading indicator when state is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const TvSeriesSearchState(state: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show search results when state is loaded', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvSeriesSearchState(
        state: RequestState.loaded,
        searchResult: testTvSeries,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Search Result 1'), findsOneWidget);
    expect(find.text('Search Result 2'), findsOneWidget);
  });

  testWidgets('should show "No results found" when results are empty', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const TvSeriesSearchState(state: RequestState.loaded, searchResult: []),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('No results found'), findsOneWidget);
  });

  testWidgets('should show error message when state is error', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const TvSeriesSearchState(
        state: RequestState.error,
        message: 'Failed to search',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Failed to search'), findsOneWidget);
  });

  testWidgets('should dispatch OnQueryChanged when text is entered', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesSearchState());

    await tester.pumpWidget(makeTestableWidget());

    await tester.enterText(find.byType(TextField), 'breaking bad');
    await tester.pump();

    verify(() => mockBloc.add(const OnQueryChanged('breaking bad'))).called(1);
  });
}
