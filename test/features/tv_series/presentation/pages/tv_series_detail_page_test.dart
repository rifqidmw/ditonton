import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:tv_series/presentation/widgets/detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesDetailBloc
    extends MockBloc<TVSeriesDetailEvent, TVSeriesDetailState>
    implements TVSeriesDetailBloc {}

void main() {
  late MockTvSeriesDetailBloc mockBloc;

  const testTvSeriesDetail = TVSeriesDetail(
    id: 1,
    name: 'Test Series',
    overview: 'Test overview',
    voteAverage: 8.5,
    genres: [Genre(id: 18, name: 'Drama')],
    numberOfEpisodes: 50,
    numberOfSeasons: 2,
    seasons: [
      Season(id: 1, name: 'Season 1', episodeCount: 25, seasonNumber: 1),
    ],
    status: 'Returning Series',
  );

  final testRecommendations = [
    TVSeries(
      id: 2,
      name: 'Recommended Series',
      overview: 'Recommendation overview',
      posterPath: '/rec.jpg',
      voteAverage: 7.5,
      genreIds: const [18],
    ),
  ];

  setUp(() {
    mockBloc = MockTvSeriesDetailBloc();
    registerFallbackValue(const FetchTVSeriesDetail(1));
    registerFallbackValue(const LoadWatchlistStatus(1));
  });

  Widget makeTestableWidget(int id) {
    return MaterialApp(
      home: BlocProvider<TVSeriesDetailBloc>(
        create: (_) => mockBloc,
        child: TVSeriesDetailPage(id: id),
      ),
    );
  }

  void setLargeScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
  }

  testWidgets('should show loading indicator when detailState is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const TVSeriesDetailState(detailState: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget(1));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show error text when detailState is error', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const TVSeriesDetailState(
        detailState: RequestState.error,
        detailMessage: 'Failed to load detail',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(1));

    expect(find.text('Failed to load detail'), findsOneWidget);
  });

  testWidgets('should show detail content when detailState is loaded', (
    tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      TVSeriesDetailState(
        detailState: RequestState.loaded,
        tvSeriesDetail: testTvSeriesDetail,
        recommendations: testRecommendations,
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(1));
    await tester.pump();

    expect(find.byType(DetailContent), findsOneWidget);
    expect(find.text('Test Series'), findsOneWidget);
  });

  testWidgets('should show add icon when not in watchlist', (tester) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      TVSeriesDetailState(
        detailState: RequestState.loaded,
        tvSeriesDetail: testTvSeriesDetail,
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(1));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('should show check icon when already in watchlist', (
    tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      TVSeriesDetailState(
        detailState: RequestState.loaded,
        tvSeriesDetail: testTvSeriesDetail,
        isAddedToWatchlist: true,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(1));
    await tester.pump();

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('should show overview text in detail content', (tester) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      TVSeriesDetailState(
        detailState: RequestState.loaded,
        tvSeriesDetail: testTvSeriesDetail,
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(1));
    await tester.pump();

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Test overview'), findsOneWidget);
  });

  testWidgets('should dispatch AddToWatchlist when add button tapped', (
    tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      TVSeriesDetailState(
        detailState: RequestState.loaded,
        tvSeriesDetail: testTvSeriesDetail,
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(1));
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 200));

    verify(() => mockBloc.add(AddToWatchlist(testTvSeriesDetail))).called(1);
  });

  testWidgets('should dispatch RemoveFromWatchlist when remove button tapped', (
    tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      TVSeriesDetailState(
        detailState: RequestState.loaded,
        tvSeriesDetail: testTvSeriesDetail,
        isAddedToWatchlist: true,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(1));
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 200));

    verify(
      () => mockBloc.add(RemoveFromWatchlist(testTvSeriesDetail)),
    ).called(1);
  });

  testWidgets('should show snackbar when watchlistMessage changes', (
    tester,
  ) async {
    setLargeScreen(tester);
    whenListen(
      mockBloc,
      Stream.fromIterable([
        const TVSeriesDetailState(
          detailState: RequestState.loaded,
          tvSeriesDetail: testTvSeriesDetail,
          isAddedToWatchlist: false,
          watchlistMessage: '',
        ),
        const TVSeriesDetailState(
          detailState: RequestState.loaded,
          tvSeriesDetail: testTvSeriesDetail,
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ]),
      initialState: const TVSeriesDetailState(
        detailState: RequestState.loaded,
        tvSeriesDetail: testTvSeriesDetail,
        isAddedToWatchlist: false,
        watchlistMessage: '',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
}
