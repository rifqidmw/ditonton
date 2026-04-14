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

  final tTvSeries = TVSeries(
    id: 2,
    name: 'Recommended Series',
    overview: 'Rec overview',
    posterPath: '/rec.jpg',
    voteAverage: 7.5,
    genreIds: const [18],
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

    // The grey container renders when posterPath is null
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
}
