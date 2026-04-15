import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:tv_series/presentation/widgets/episode_list_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesDetailBloc
    extends MockBloc<TVSeriesDetailEvent, TVSeriesDetailState>
    implements TVSeriesDetailBloc {}

void main() {
  late MockTvSeriesDetailBloc mockBloc;

  const tEpisode = Episode(
    id: 1,
    name: 'Pilot',
    episodeNumber: 1,
    seasonNumber: 1,
    overview: 'First episode.',
    voteAverage: 8.0,
    airDate: '2023-01-01',
  );

  const tSeasonDetail = SeasonDetail(
    id: 1,
    name: 'Season 1',
    seasonNumber: 1,
    overview: 'Overview',
    episodes: [tEpisode],
  );

  const tSeasonDetailEmpty = SeasonDetail(
    id: 2,
    name: 'Season 2',
    seasonNumber: 2,
    overview: '',
    episodes: [],
  );

  setUp(() {
    mockBloc = MockTvSeriesDetailBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<TVSeriesDetailBloc>(
          create: (_) => mockBloc,
          child: EpisodeListSheet(
            seasonName: 'Season 1',
            scrollController: ScrollController(),
          ),
        ),
      ),
    );
  }

  testWidgets('shows loading indicator when seasonDetailState is loading', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const TVSeriesDetailState(seasonDetailState: RequestState.loading),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when seasonDetailState is error', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const TVSeriesDetailState(
        seasonDetailState: RequestState.error,
        seasonDetailMessage: 'Failed to load',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Failed to load'), findsOneWidget);
  });

  testWidgets('shows episodes list when seasonDetailState is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const TVSeriesDetailState(
        seasonDetailState: RequestState.loaded,
        selectedSeasonDetail: tSeasonDetail,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.textContaining('Ep 1: Pilot'), findsOneWidget);
  });

  testWidgets('shows empty message when loaded but no episodes', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const TVSeriesDetailState(
        seasonDetailState: RequestState.loaded,
        selectedSeasonDetail: tSeasonDetailEmpty,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('No episodes available.'), findsOneWidget);
  });

  testWidgets('shows loading indicator when state is default (empty)', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const TVSeriesDetailState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'shows loading indicator when loaded but selectedSeasonDetail is null',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        const TVSeriesDetailState(
          seasonDetailState: RequestState.loaded,
          selectedSeasonDetail: null,
        ),
      );

      await tester.pumpWidget(makeTestableWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('shows season name as title', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TVSeriesDetailState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Season 1'), findsOneWidget);
  });
}
