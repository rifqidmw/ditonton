import 'package:bloc_test/bloc_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_state.dart';
import 'package:tv_series/presentation/pages/tv_series_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesListBloc
    extends MockBloc<TVSeriesListEvent, TVSeriesListState>
    implements TVSeriesListBloc {}

void main() {
  late MockTvSeriesListBloc mockBloc;

  final testTvSeries = [
    TVSeries(
      id: 1,
      name: 'Test Series',
      overview: 'Overview 1',
      posterPath: '/test1.jpg',
      voteAverage: 8.5,
      genreIds: const [18],
    ),
    TVSeries(
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
      home: BlocProvider<TVSeriesListBloc>(
        create: (_) => mockBloc,
        child: const TVSeriesHomePage(),
      ),
    );
  }

  Widget makeRoutableWidget() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (_, __) => NoTransitionPage(
            child: BlocProvider<TVSeriesListBloc>(
              create: (_) => mockBloc,
              child: const TVSeriesHomePage(),
            ),
          ),
        ),
        GoRoute(
          path: '/tv-series/search',
          pageBuilder: (_, __) => const NoTransitionPage(child: SizedBox()),
        ),
        GoRoute(
          path: '/tv-series/popular',
          pageBuilder: (_, __) => const NoTransitionPage(child: SizedBox()),
        ),
        GoRoute(
          path: '/tv-series/top-rated',
          pageBuilder: (_, __) => const NoTransitionPage(child: SizedBox()),
        ),
        GoRoute(
          path: '/tv-series/:id',
          pageBuilder: (_, __) => const NoTransitionPage(child: SizedBox()),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('should display app title in AppBar', (tester) async {
    when(() => mockBloc.state).thenReturn(const TVSeriesListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Ditonton'), findsOneWidget);
  });

  testWidgets('should display search icon', (tester) async {
    when(() => mockBloc.state).thenReturn(const TVSeriesListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('should display section headings', (tester) async {
    when(() => mockBloc.state).thenReturn(const TVSeriesListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
  });

  testWidgets('should display "See More" buttons for Popular and Top Rated', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const TVSeriesListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('See More'), findsNWidgets(2));
  });

  testWidgets('should show loading when onTheAir state is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const TVSeriesListState(onTheAirState: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show loading when popular state is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const TVSeriesListState(popularState: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show loading when topRated state is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const TVSeriesListState(topRatedState: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show onTheAir tv series list when loaded', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TVSeriesListState(
        onTheAirState: RequestState.loaded,
        onTheAirTVSeries: testTvSeries,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(TVSeriesList), findsOneWidget);
  });

  testWidgets('should show popular tv series list when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(
      TVSeriesListState(
        popularState: RequestState.loaded,
        popularTVSeries: testTvSeries,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(TVSeriesList), findsOneWidget);
  });

  testWidgets('should show top rated tv series list when loaded', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TVSeriesListState(
        topRatedState: RequestState.loaded,
        topRatedTVSeries: testTvSeries,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(TVSeriesList), findsOneWidget);
  });

  testWidgets('should show error text when onTheAir state is error', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const TVSeriesListState(
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
      const TVSeriesListState(
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
      const TVSeriesListState(
        topRatedState: RequestState.error,
        topRatedMessage: 'Failed to load top rated',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Failed to load top rated'), findsOneWidget);
  });

  testWidgets('should show empty SizedBox when popular state is empty', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const TVSeriesListState(popularState: RequestState.empty));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('should show empty SizedBox when topRated state is empty', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const TVSeriesListState(topRatedState: RequestState.empty));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('TVSeriesList renders null-poster fallback', (tester) async {
    final nullPosterSeries = [
      TVSeries(
        id: 99,
        name: 'No Poster',
        overview: 'overview',
        posterPath: null,
        voteAverage: 5.0,
        genreIds: const [],
      ),
    ];
    when(() => mockBloc.state).thenReturn(
      TVSeriesListState(
        onTheAirState: RequestState.loaded,
        onTheAirTVSeries: nullPosterSeries,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
  });

  testWidgets('search icon onPressed (coverage)', (tester) async {
    when(() => mockBloc.state).thenReturn(const TVSeriesListState());

    await tester.pumpWidget(makeRoutableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // navigated to search, no crash
  });
}
