import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_state.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesListBloc
    extends MockBloc<TvSeriesListEvent, TvSeriesListState>
    implements TvSeriesListBloc {}

void main() {
  late MockTvSeriesListBloc mockBloc;

  final testTvSeries = [
    TvSeries(
      id: 1,
      name: 'Test Series',
      overview: 'Overview 1',
      posterPath: '/test1.jpg',
      voteAverage: 8.5,
      genreIds: const [18],
    ),
    TvSeries(
      id: 2,
      name: 'Another Series',
      overview: 'Overview 2',
      posterPath: '/test2.jpg',
      voteAverage: 7.5,
      genreIds: const [10765],
    ),
  ];

  setUp(() {
    mockBloc = MockTvSeriesListBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<TvSeriesListBloc>(
        create: (_) => mockBloc,
        child: const TvSeriesHomePage(),
      ),
    );
  }

  testWidgets('should display app title in AppBar', (tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Ditonton'), findsOneWidget);
  });

  testWidgets('should display search icon', (tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('should display section headings', (tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
  });

  testWidgets('should display "See More" buttons for Popular and Top Rated', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('See More'), findsNWidgets(2));
  });

  testWidgets('should show loading when onTheAir state is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const TvSeriesListState(onTheAirState: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show loading when popular state is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const TvSeriesListState(popularState: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show loading when topRated state is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const TvSeriesListState(topRatedState: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show onTheAir tv series list when loaded', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvSeriesListState(
        onTheAirState: RequestState.loaded,
        onTheAirTvSeries: testTvSeries,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(TvSeriesList), findsOneWidget);
  });

  testWidgets('should show popular tv series list when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(
      TvSeriesListState(
        popularState: RequestState.loaded,
        popularTvSeries: testTvSeries,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(TvSeriesList), findsOneWidget);
  });

  testWidgets('should show top rated tv series list when loaded', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvSeriesListState(
        topRatedState: RequestState.loaded,
        topRatedTvSeries: testTvSeries,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(TvSeriesList), findsOneWidget);
  });

  testWidgets('should show error text when onTheAir state is error', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const TvSeriesListState(
        onTheAirState: RequestState.error,
        onTheAirMessage: 'Failed to load on the air',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Failed to load on the air'), findsOneWidget);
  });

  testWidgets('should show error text when popular state is error', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const TvSeriesListState(
        popularState: RequestState.error,
        popularMessage: 'Failed to load popular',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Failed to load popular'), findsOneWidget);
  });

  testWidgets('should show error text when topRated state is error', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const TvSeriesListState(
        topRatedState: RequestState.error,
        topRatedMessage: 'Failed to load top rated',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Failed to load top rated'), findsOneWidget);
  });
}
