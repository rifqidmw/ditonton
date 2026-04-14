import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_state.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';
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
      name: 'Top Rated Series 1',
      overview: 'Overview 1',
      posterPath: '/test1.jpg',
      voteAverage: 9.0,
      genreIds: const [18],
    ),
    TVSeries(
      id: 2,
      name: 'Top Rated Series 2',
      overview: 'Overview 2',
      posterPath: '/test2.jpg',
      voteAverage: 8.5,
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
        child: const TopRatedTVSeriesPage(),
      ),
    );
  }

  testWidgets('should display AppBar with title', (tester) async {
    when(() => mockBloc.state).thenReturn(const TVSeriesListState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Top Rated TV Series'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('should show loading indicator when state is loading', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(const TVSeriesListState(topRatedState: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show list when state is loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(
      TVSeriesListState(
        topRatedState: RequestState.loaded,
        topRatedTVSeries: testTvSeries,
      ),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Top Rated Series 1'), findsOneWidget);
    expect(find.text('Top Rated Series 2'), findsOneWidget);
  });

  testWidgets('should show error message when state is error', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const TVSeriesListState(
        topRatedState: RequestState.error,
        topRatedMessage: 'Failed to load top rated',
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Failed to load top rated'), findsOneWidget);
  });
}
