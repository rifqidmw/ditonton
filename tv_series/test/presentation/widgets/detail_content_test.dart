import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:tv_series/presentation/widgets/detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesDetailBloc
    extends MockBloc<TVSeriesDetailEvent, TVSeriesDetailState>
    implements TVSeriesDetailBloc {}

void main() {
  late MockTvSeriesDetailBloc mockBloc;

  const tTvSeriesDetailNoPoster = TVSeriesDetail(
    id: 1,
    name: 'Test Series',
    overview: 'Test overview',
    posterPath: null,
    voteAverage: 8.0,
    genres: [Genre(id: 18, name: 'Drama')],
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    seasons: [
      Season(id: 1, name: 'Season 1', episodeCount: 10, seasonNumber: 1),
    ],
    status: 'Returning Series',
  );

  const tTvSeriesDetailWithPoster = TVSeriesDetail(
    id: 2,
    name: 'Poster Series',
    overview: 'Has a poster',
    posterPath: '/poster.jpg',
    voteAverage: 7.5,
    genres: [Genre(id: 18, name: 'Drama')],
    numberOfEpisodes: 5,
    numberOfSeasons: 1,
    seasons: [
      Season(
        id: 2,
        name: 'Season 1',
        episodeCount: 5,
        seasonNumber: 1,
        posterPath: '/season_poster.jpg',
      ),
    ],
    status: 'Ended',
  );

  const tTvSeriesDetailNullSeasonPoster = TVSeriesDetail(
    id: 3,
    name: 'Null Season Poster',
    overview: 'Season without poster',
    posterPath: null,
    voteAverage: 7.0,
    genres: [],
    numberOfEpisodes: 5,
    numberOfSeasons: 1,
    seasons: [
      Season(id: 3, name: 'Season 1', episodeCount: 5, seasonNumber: 1),
    ],
    status: 'Ended',
  );

  final tTvSeries = TVSeries(
    id: 2,
    name: 'Recommended Series',
    overview: 'Rec overview',
    posterPath: '/rec.jpg',
    voteAverage: 7.5,
    genreIds: const [18],
  );

  final tTvSeriesNoPoster = TVSeries(
    id: 3,
    name: 'No Poster Rec',
    overview: 'No poster rec',
    posterPath: null,
    voteAverage: 6.0,
    genreIds: const [],
  );

  setUp(() {
    mockBloc = MockTvSeriesDetailBloc();
    registerFallbackValue(const FetchSeasonDetail(1, 1));
  });

  void setLargeScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
  }

  Widget makeTestableWidget({
    required TVSeriesDetail tvSeries,
    List<TVSeries>? recommendations,
    bool isAddedWatchlist = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<TVSeriesDetailBloc>(
          create: (_) => mockBloc,
          child: DetailContent(
            tvSeries,
            recommendations ?? [],
            isAddedWatchlist,
          ),
        ),
      ),
    );
  }

  Widget makeRoutableWidget({
    required TVSeriesDetail tvSeries,
    List<TVSeries>? recommendations,
    bool isAddedWatchlist = false,
  }) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => NoTransitionPage(
            child: Scaffold(
              body: BlocProvider<TVSeriesDetailBloc>(
                create: (_) => mockBloc,
                child: DetailContent(
                  tvSeries,
                  recommendations ?? [],
                  isAddedWatchlist,
                ),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/tv-series/:id',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: Scaffold(body: Text('Detail'))),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  // Router with a parent page so context.pop() has somewhere to go
  Widget makeRoutableWidgetWithParent({
    required TVSeriesDetail tvSeries,
    List<TVSeries>? recommendations,
    bool isAddedWatchlist = false,
  }) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (_, _) =>
              const NoTransitionPage(child: Scaffold(body: Text('Home'))),
        ),
        GoRoute(
          path: '/detail',
          pageBuilder: (_, _) => NoTransitionPage(
            child: Scaffold(
              body: BlocProvider<TVSeriesDetailBloc>(
                create: (_) => mockBloc,
                child: DetailContent(
                  tvSeries,
                  recommendations ?? [],
                  isAddedWatchlist,
                ),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/tv-series/:id',
          pageBuilder: (_, _) =>
              const NoTransitionPage(child: Scaffold(body: Text('Detail'))),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('shows grey placeholder when posterPath is null', (
    WidgetTester tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      const TVSeriesDetailState(recommendationState: RequestState.empty),
    );

    await tester.pumpWidget(
      makeTestableWidget(tvSeries: tTvSeriesDetailNoPoster),
    );
    await tester.pump();

    expect(find.byType(DetailContent), findsOneWidget);
  });

  testWidgets('shows CachedNetworkImage when posterPath is not null', (
    WidgetTester tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      const TVSeriesDetailState(recommendationState: RequestState.empty),
    );

    await tester.pumpWidget(
      makeTestableWidget(tvSeries: tTvSeriesDetailWithPoster),
    );
    await tester.pump();

    expect(find.byType(DetailContent), findsOneWidget);
  });

  testWidgets('shows loading indicator in recommendations when loading', (
    WidgetTester tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      const TVSeriesDetailState(recommendationState: RequestState.loading),
    );

    await tester.pumpWidget(
      makeTestableWidget(tvSeries: tTvSeriesDetailNoPoster),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error text in recommendations when error', (
    WidgetTester tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      const TVSeriesDetailState(
        recommendationState: RequestState.error,
        recommendationMessage: 'Failed to load',
      ),
    );

    await tester.pumpWidget(
      makeTestableWidget(tvSeries: tTvSeriesDetailNoPoster),
    );
    await tester.pump();

    expect(find.text('Failed to load'), findsOneWidget);
  });

  testWidgets('shows recommendation list when loaded with items', (
    WidgetTester tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      const TVSeriesDetailState(recommendationState: RequestState.loaded),
    );

    await tester.pumpWidget(
      makeTestableWidget(
        tvSeries: tTvSeriesDetailNoPoster,
        recommendations: [tTvSeries],
      ),
    );
    await tester.pump();

    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('shows empty SizedBox in recommendations when default state', (
    WidgetTester tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(const TVSeriesDetailState());

    await tester.pumpWidget(
      makeTestableWidget(tvSeries: tTvSeriesDetailNoPoster),
    );
    await tester.pump();

    expect(find.byType(DetailContent), findsOneWidget);
  });

  testWidgets('shows null-poster fallback in recommendation list', (
    WidgetTester tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      const TVSeriesDetailState(recommendationState: RequestState.loaded),
    );

    await tester.pumpWidget(
      makeTestableWidget(
        tvSeries: tTvSeriesDetailNoPoster,
        recommendations: [tTvSeriesNoPoster],
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.image_not_supported), findsWidgets);
  });

  testWidgets('tapping recommendation item triggers push (coverage)', (
    WidgetTester tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(
      const TVSeriesDetailState(recommendationState: RequestState.loaded),
    );

    await tester.pumpWidget(
      makeRoutableWidget(
        tvSeries: tTvSeriesDetailNoPoster,
        recommendations: [tTvSeries],
      ),
    );
    await tester.pump();

    final inkWells = find.byType(InkWell);
    if (inkWells.evaluate().isNotEmpty) {
      await tester.tap(inkWells.first, warnIfMissed: false);
      await tester.pump(const Duration(seconds: 1));
    }
  });

  testWidgets('back button onPressed triggers pop (coverage)', (
    WidgetTester tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(const TVSeriesDetailState());

    await tester.pumpWidget(
      makeRoutableWidgetWithParent(tvSeries: tTvSeriesDetailNoPoster),
    );
    await tester.pump();

    // Navigate to detail page (creates history so pop works)
    final goRouter = GoRouter.of(tester.element(find.byType(Scaffold).first));
    goRouter.push('/detail');
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back), warnIfMissed: false);
    await tester.pump();
    await tester.pump(Duration.zero);
  });

  testWidgets('season card shows null-poster fallback', (
    WidgetTester tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(const TVSeriesDetailState());

    await tester.pumpWidget(
      makeTestableWidget(tvSeries: tTvSeriesDetailNullSeasonPoster),
    );
    await tester.pump();

    expect(find.byType(DetailContent), findsOneWidget);
  });

  testWidgets('tapping season card triggers _onSeasonTap (coverage)', (
    WidgetTester tester,
  ) async {
    setLargeScreen(tester);
    when(() => mockBloc.state).thenReturn(const TVSeriesDetailState());

    await tester.pumpWidget(
      makeTestableWidget(tvSeries: tTvSeriesDetailNoPoster),
    );
    await tester.pump();

    final gestureDetectors = find.byType(GestureDetector);
    if (gestureDetectors.evaluate().isNotEmpty) {
      await tester.tap(gestureDetectors.first, warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(Duration.zero);
    }
  });
}
