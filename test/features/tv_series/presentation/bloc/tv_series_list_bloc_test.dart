import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/core/error/failures.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPopularTvSeries extends Mock implements GetPopularTvSeries {}

class MockGetTopRatedTvSeries extends Mock implements GetTopRatedTvSeries {}

class MockGetOnTheAirTvSeries extends Mock implements GetOnTheAirTvSeries {}

void main() {
  late TvSeriesListBloc bloc;
  late MockGetPopularTvSeries mockGetPopular;
  late MockGetTopRatedTvSeries mockGetTopRated;
  late MockGetOnTheAirTvSeries mockGetOnTheAir;

  final tTvSeries = [
    TvSeries(
      id: 1,
      name: 'Test Series',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
      genreIds: const [18],
    ),
  ];

  setUp(() {
    mockGetPopular = MockGetPopularTvSeries();
    mockGetTopRated = MockGetTopRatedTvSeries();
    mockGetOnTheAir = MockGetOnTheAirTvSeries();
    bloc = TvSeriesListBloc(
      getPopularTvSeries: mockGetPopular,
      getTopRatedTvSeries: mockGetTopRated,
      getOnTheAirTvSeries: mockGetOnTheAir,
    );
  });

  tearDown(() => bloc.close());

  test('initial state should be TvSeriesListState with empty RequestState', () {
    expect(bloc.state, const TvSeriesListState());
  });

  group('FetchPopularTvSeries', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, loaded] when data is fetched successfully',
      build: () {
        when(
          () => mockGetPopular.execute(),
        ).thenAnswer((_) async => Right(tTvSeries));
        return bloc;
      },
      act: (b) => b.add(FetchPopularTvSeries()),
      expect: () => [
        const TvSeriesListState(popularState: RequestState.loading),
        TvSeriesListState(
          popularState: RequestState.loaded,
          popularTvSeries: tTvSeries,
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, error] when fetch fails',
      build: () {
        when(
          () => mockGetPopular.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (b) => b.add(FetchPopularTvSeries()),
      expect: () => [
        const TvSeriesListState(popularState: RequestState.loading),
        const TvSeriesListState(
          popularState: RequestState.error,
          popularMessage: 'Server Error',
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, error] on connection failure',
      build: () {
        when(
          () => mockGetPopular.execute(),
        ).thenAnswer((_) async => const Left(ConnectionFailure('No internet')));
        return bloc;
      },
      act: (b) => b.add(FetchPopularTvSeries()),
      expect: () => [
        const TvSeriesListState(popularState: RequestState.loading),
        const TvSeriesListState(
          popularState: RequestState.error,
          popularMessage: 'No internet',
        ),
      ],
    );
  });

  group('FetchTopRatedTvSeries', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, loaded] when data is fetched successfully',
      build: () {
        when(
          () => mockGetTopRated.execute(),
        ).thenAnswer((_) async => Right(tTvSeries));
        return bloc;
      },
      act: (b) => b.add(FetchTopRatedTvSeries()),
      expect: () => [
        const TvSeriesListState(topRatedState: RequestState.loading),
        TvSeriesListState(
          topRatedState: RequestState.loaded,
          topRatedTvSeries: tTvSeries,
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, error] when fetch fails',
      build: () {
        when(
          () => mockGetTopRated.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (b) => b.add(FetchTopRatedTvSeries()),
      expect: () => [
        const TvSeriesListState(topRatedState: RequestState.loading),
        const TvSeriesListState(
          topRatedState: RequestState.error,
          topRatedMessage: 'Server Error',
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, error] on database failure',
      build: () {
        when(
          () => mockGetTopRated.execute(),
        ).thenAnswer((_) async => const Left(DatabaseFailure('DB Error')));
        return bloc;
      },
      act: (b) => b.add(FetchTopRatedTvSeries()),
      expect: () => [
        const TvSeriesListState(topRatedState: RequestState.loading),
        const TvSeriesListState(
          topRatedState: RequestState.error,
          topRatedMessage: 'DB Error',
        ),
      ],
    );
  });

  group('FetchOnTheAirTvSeries', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, loaded] when data is fetched successfully',
      build: () {
        when(
          () => mockGetOnTheAir.execute(),
        ).thenAnswer((_) async => Right(tTvSeries));
        return bloc;
      },
      act: (b) => b.add(FetchOnTheAirTvSeries()),
      expect: () => [
        const TvSeriesListState(onTheAirState: RequestState.loading),
        TvSeriesListState(
          onTheAirState: RequestState.loaded,
          onTheAirTvSeries: tTvSeries,
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, error] when fetch fails',
      build: () {
        when(
          () => mockGetOnTheAir.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (b) => b.add(FetchOnTheAirTvSeries()),
      expect: () => [
        const TvSeriesListState(onTheAirState: RequestState.loading),
        const TvSeriesListState(
          onTheAirState: RequestState.error,
          onTheAirMessage: 'Server Error',
        ),
      ],
    );
  });
}
