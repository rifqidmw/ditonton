import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/error/failures.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPopularTvSeries extends Mock implements GetPopularTVSeries {}

class MockGetTopRatedTvSeries extends Mock implements GetTopRatedTVSeries {}

class MockGetOnTheAirTvSeries extends Mock implements GetOnTheAirTVSeries {}

void main() {
  late TVSeriesListBloc bloc;
  late MockGetPopularTvSeries mockGetPopular;
  late MockGetTopRatedTvSeries mockGetTopRated;
  late MockGetOnTheAirTvSeries mockGetOnTheAir;

  final tTvSeries = [
    TVSeries(
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
    bloc = TVSeriesListBloc(
      getPopularTVSeries: mockGetPopular,
      getTopRatedTVSeries: mockGetTopRated,
      getOnTheAirTVSeries: mockGetOnTheAir,
    );
  });

  tearDown(() => bloc.close());

  test('initial state should be TvSeriesListState with empty RequestState', () {
    expect(bloc.state, const TVSeriesListState());
  });

  group('FetchPopularTvSeries', () {
    blocTest<TVSeriesListBloc, TVSeriesListState>(
      'should emit [loading, loaded] when data is fetched successfully',
      build: () {
        when(
          () => mockGetPopular.execute(),
        ).thenAnswer((_) async => Right(tTvSeries));
        return bloc;
      },
      act: (b) => b.add(FetchPopularTVSeries()),
      expect: () => [
        const TVSeriesListState(popularState: RequestState.loading),
        TVSeriesListState(
          popularState: RequestState.loaded,
          popularTVSeries: tTvSeries,
        ),
      ],
    );

    blocTest<TVSeriesListBloc, TVSeriesListState>(
      'should emit [loading, error] when fetch fails',
      build: () {
        when(
          () => mockGetPopular.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (b) => b.add(FetchPopularTVSeries()),
      expect: () => [
        const TVSeriesListState(popularState: RequestState.loading),
        const TVSeriesListState(
          popularState: RequestState.error,
          popularMessage: 'Server Error',
        ),
      ],
    );

    blocTest<TVSeriesListBloc, TVSeriesListState>(
      'should emit [loading, error] on connection failure',
      build: () {
        when(
          () => mockGetPopular.execute(),
        ).thenAnswer((_) async => const Left(ConnectionFailure('No internet')));
        return bloc;
      },
      act: (b) => b.add(FetchPopularTVSeries()),
      expect: () => [
        const TVSeriesListState(popularState: RequestState.loading),
        const TVSeriesListState(
          popularState: RequestState.error,
          popularMessage: 'No internet',
        ),
      ],
    );
  });

  group('FetchTopRatedTvSeries', () {
    blocTest<TVSeriesListBloc, TVSeriesListState>(
      'should emit [loading, loaded] when data is fetched successfully',
      build: () {
        when(
          () => mockGetTopRated.execute(),
        ).thenAnswer((_) async => Right(tTvSeries));
        return bloc;
      },
      act: (b) => b.add(FetchTopRatedTVSeries()),
      expect: () => [
        const TVSeriesListState(topRatedState: RequestState.loading),
        TVSeriesListState(
          topRatedState: RequestState.loaded,
          topRatedTVSeries: tTvSeries,
        ),
      ],
    );

    blocTest<TVSeriesListBloc, TVSeriesListState>(
      'should emit [loading, error] when fetch fails',
      build: () {
        when(
          () => mockGetTopRated.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (b) => b.add(FetchTopRatedTVSeries()),
      expect: () => [
        const TVSeriesListState(topRatedState: RequestState.loading),
        const TVSeriesListState(
          topRatedState: RequestState.error,
          topRatedMessage: 'Server Error',
        ),
      ],
    );

    blocTest<TVSeriesListBloc, TVSeriesListState>(
      'should emit [loading, error] on database failure',
      build: () {
        when(
          () => mockGetTopRated.execute(),
        ).thenAnswer((_) async => const Left(DatabaseFailure('DB Error')));
        return bloc;
      },
      act: (b) => b.add(FetchTopRatedTVSeries()),
      expect: () => [
        const TVSeriesListState(topRatedState: RequestState.loading),
        const TVSeriesListState(
          topRatedState: RequestState.error,
          topRatedMessage: 'DB Error',
        ),
      ],
    );
  });

  group('FetchOnTheAirTvSeries', () {
    blocTest<TVSeriesListBloc, TVSeriesListState>(
      'should emit [loading, loaded] when data is fetched successfully',
      build: () {
        when(
          () => mockGetOnTheAir.execute(),
        ).thenAnswer((_) async => Right(tTvSeries));
        return bloc;
      },
      act: (b) => b.add(FetchOnTheAirTVSeries()),
      expect: () => [
        const TVSeriesListState(onTheAirState: RequestState.loading),
        TVSeriesListState(
          onTheAirState: RequestState.loaded,
          onTheAirTVSeries: tTvSeries,
        ),
      ],
    );

    blocTest<TVSeriesListBloc, TVSeriesListState>(
      'should emit [loading, error] when fetch fails',
      build: () {
        when(
          () => mockGetOnTheAir.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (b) => b.add(FetchOnTheAirTVSeries()),
      expect: () => [
        const TVSeriesListState(onTheAirState: RequestState.loading),
        const TVSeriesListState(
          onTheAirState: RequestState.error,
          onTheAirMessage: 'Server Error',
        ),
      ],
    );
  });
}
