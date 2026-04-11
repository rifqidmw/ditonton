import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/core/error/failures.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/search_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_search/tv_series_search_event.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_search/tv_series_search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchTvSeries extends Mock implements SearchTvSeries {}

void main() {
  late TvSeriesSearchBloc bloc;
  late MockSearchTvSeries mockSearchTvSeries;

  final tResults = [
    TvSeries(
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
    bloc = TvSeriesSearchBloc(searchTvSeries: mockSearchTvSeries);
  });

  tearDown(() => bloc.close());

  test('initial state should be TvSeriesSearchState empty', () {
    expect(bloc.state, const TvSeriesSearchState());
  });

  group('OnQueryChanged', () {
    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
      'should emit [empty] when query is empty',
      build: () => bloc,
      act: (b) => b.add(const OnQueryChanged('')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        const TvSeriesSearchState(state: RequestState.empty, searchResult: []),
      ],
    );

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
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
        const TvSeriesSearchState(state: RequestState.loading),
        TvSeriesSearchState(state: RequestState.loaded, searchResult: tResults),
      ],
    );

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
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
        const TvSeriesSearchState(state: RequestState.loading),
        const TvSeriesSearchState(
          state: RequestState.error,
          message: 'Server Error',
        ),
      ],
    );

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
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
        const TvSeriesSearchState(state: RequestState.loading),
        const TvSeriesSearchState(
          state: RequestState.error,
          message: 'No internet',
        ),
      ],
    );

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
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
        const TvSeriesSearchState(state: RequestState.loading),
        const TvSeriesSearchState(state: RequestState.loaded, searchResult: []),
      ],
    );
  });
}
