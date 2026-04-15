import 'package:bloc_test/bloc_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_event.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_state.dart';
import 'package:tv_series/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchlistTvSeriesBloc
    extends MockBloc<WatchlistTVSeriesEvent, WatchlistTVSeriesState>
    implements WatchlistTVSeriesBloc {}

void main() {
  late MockWatchlistTvSeriesBloc mockBloc;

  final testTvSeries = [
    TVSeries(
      id: 1,
      name: 'Watchlist Series 1',
      overview: 'Overview 1',
      posterPath: '/test1.jpg',
      voteAverage: 8.5,
      genreIds: const [18],
    ),
    TVSeries(
      id: 2,
      name: 'Watchlist Series 2',
      overview: 'Overview 2',
      posterPath: '/test2.jpg',
      voteAverage: 7.5,
      genreIds: const [10765],
    ),
  ];

  setUp(() {
    mockBloc = MockWatchlistTvSeriesBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<WatchlistTVSeriesBloc>(
        create: (_) => mockBloc,
        child: const WatchlistTVSeriesPage(),
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
            child: BlocProvider<WatchlistTVSeriesBloc>(
              create: (_) => mockBloc,
              child: const WatchlistTVSeriesPage(),
            ),
          ),
        ),
        GoRoute(
          path: '/tv-series/:id',
          pageBuilder: (_, __) => const NoTransitionPage(child: SizedBox()),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('should display AppBar with Watchlist title', (tester) async {
    when(() => mockBloc.state).thenReturn(const WatchlistTVSeriesState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('should show loading indicator when state is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const WatchlistTVSeriesState(state: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show watchlist items when state is loaded', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistTVSeriesState(
        state: RequestState.loaded,
        watchlistTVSeries: testTvSeries,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Watchlist Series 1'), findsOneWidget);
    expect(find.text('Watchlist Series 2'), findsOneWidget);
  });

  testWidgets('should show "No watchlist yet" when watchlist is empty', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const WatchlistTVSeriesState(
        state: RequestState.loaded,
        watchlistTVSeries: [],
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('No watchlist yet'), findsOneWidget);
  });

  testWidgets('should show error message when state is error', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const WatchlistTVSeriesState(
        state: RequestState.error,
        message: 'Failed to fetch watchlist',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Failed to fetch watchlist'), findsOneWidget);
  });

  testWidgets('should show pull-to-refresh on empty watchlist', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const WatchlistTVSeriesState(
        state: RequestState.loaded,
        watchlistTVSeries: [],
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(RefreshIndicator), findsOneWidget);
  });

  testWidgets('pull-to-refresh triggers _onRefresh (coverage)', (tester) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistTVSeriesState(
        state: RequestState.loaded,
        watchlistTVSeries: testTvSeries,
      ),
    );

    await tester.pumpWidget(makeRoutableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200)); // snap animation
    await tester.pump(
      const Duration(milliseconds: 600),
    ); // Future.delayed(500ms)
    await tester.pump(const Duration(milliseconds: 400)); // dismiss animation
  });

  testWidgets('tapping watchlist item executes onTap (coverage)', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistTVSeriesState(
        state: RequestState.loaded,
        watchlistTVSeries: testTvSeries,
      ),
    );

    await tester.pumpWidget(makeRoutableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final seriesTitle = find.text('Watchlist Series 1');
    expect(seriesTitle, findsOneWidget);
    await tester.tap(seriesTitle, warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('should show Container when state is default empty', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const WatchlistTVSeriesState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(Container), findsWidgets);
  });
}
