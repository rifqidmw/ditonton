import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/error/failures.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/search_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_search/tv_series_search_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_search/tv_series_search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchTvSeries extends Mock implements SearchTVSeries {}

void main() {
  late TVSeriesSearchBloc bloc;
  late MockSearchTvSeries mockSearchTvSeries;

  final tResults = [
    TVSeries(
      id: 1,
      name: 'Search Result',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
      genreIds: const [18],
    ),
  ];

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    bloc = TVSeriesSearchBloc(searchTVSeries: mockSearchTvSeries);
  });

  tearDown(() => bloc.close());

  test('initial state should be TvSeriesSearchState empty', () {
    expect(bloc.state, const TVSeriesSearchState());
  });

  group('OnQueryChanged', () {
    blocTest<TVSeriesSearchBloc, TVSeriesSearchState>(
      'should emit [empty] when query is empty',
      build: () => bloc,
      act: (b) => b.add(const OnQueryChanged('')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        const TVSeriesSearchState(state: RequestState.empty, searchResult: []),
      ],
    );

    blocTest<TVSeriesSearchBloc, TVSeriesSearchState>(
      'should emit [loading, loaded] when search succeeds',
      build: () {
        when(
          () => mockSearchTvSeries.execute('test'),
        ).thenAnswer((_) async => Right(tResults));
        return bloc;
      },
      act: (b) => b.add(const OnQueryChanged('test')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        const TVSeriesSearchState(state: RequestState.loading),
        TVSeriesSearchState(state: RequestState.loaded, searchResult: tResults),
      ],
    );

    blocTest<TVSeriesSearchBloc, TVSeriesSearchState>(
      'should emit [loading, error] when search fails with server error',
      build: () {
        when(
          () => mockSearchTvSeries.execute('test'),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (b) => b.add(const OnQueryChanged('test')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        const TVSeriesSearchState(state: RequestState.loading),
        const TVSeriesSearchState(
          state: RequestState.error,
          message: 'Server Error',
        ),
      ],
    );

    blocTest<TVSeriesSearchBloc, TVSeriesSearchState>(
      'should emit [loading, error] on connection failure',
      build: () {
        when(
          () => mockSearchTvSeries.execute('test'),
        ).thenAnswer((_) async => const Left(ConnectionFailure('No internet')));
        return bloc;
      },
      act: (b) => b.add(const OnQueryChanged('test')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        const TVSeriesSearchState(state: RequestState.loading),
        const TVSeriesSearchState(
          state: RequestState.error,
          message: 'No internet',
        ),
      ],
    );

    blocTest<TVSeriesSearchBloc, TVSeriesSearchState>(
      'should emit [loading, loaded] with empty list when no results',
      build: () {
        when(
          () => mockSearchTvSeries.execute('unknown'),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (b) => b.add(const OnQueryChanged('unknown')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        const TVSeriesSearchState(state: RequestState.loading),
        const TVSeriesSearchState(state: RequestState.loaded, searchResult: []),
      ],
    );
  });
}
