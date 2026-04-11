import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/core/error/failures.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_event.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetWatchlistTvSeries extends Mock implements GetWatchlistTvSeries {}

void main() {
  late WatchlistTvSeriesBloc bloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  final tWatchlist = [
    TvSeries(
      id: 1,
      name: 'Watchlist Series',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.5,
      genreIds: const [18],
    ),
  ];

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    bloc = WatchlistTvSeriesBloc(
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
    );
  });

  tearDown(() => bloc.close());

  test('initial state should be WatchlistTvSeriesState empty', () {
    expect(bloc.state, const WatchlistTvSeriesState());
  });

  group('FetchWatchlistTvSeries', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [loading, loaded] when data is fetched successfully',
      build: () {
        when(
          () => mockGetWatchlistTvSeries.execute(),
        ).thenAnswer((_) async => Right(tWatchlist));
        return bloc;
      },
      act: (b) => b.add(FetchWatchlistTvSeries()),
      expect:
          () => [
            const WatchlistTvSeriesState(state: RequestState.loading),
            WatchlistTvSeriesState(
              state: RequestState.loaded,
              watchlistTvSeries: tWatchlist,
            ),
          ],
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [loading, loaded] with empty list when watchlist is empty',
      build: () {
        when(
          () => mockGetWatchlistTvSeries.execute(),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (b) => b.add(FetchWatchlistTvSeries()),
      expect:
          () => [
            const WatchlistTvSeriesState(state: RequestState.loading),
            const WatchlistTvSeriesState(
              state: RequestState.loaded,
              watchlistTvSeries: [],
            ),
          ],
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [loading, error] when fetch fails with server error',
      build: () {
        when(
          () => mockGetWatchlistTvSeries.execute(),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('Server Error')),
        );
        return bloc;
      },
      act: (b) => b.add(FetchWatchlistTvSeries()),
      expect:
          () => [
            const WatchlistTvSeriesState(state: RequestState.loading),
            const WatchlistTvSeriesState(
              state: RequestState.error,
              message: 'Server Error',
            ),
          ],
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [loading, error] when fetch fails with database error',
      build: () {
        when(
          () => mockGetWatchlistTvSeries.execute(),
        ).thenAnswer(
          (_) async => const Left(DatabaseFailure('DB Error')),
        );
        return bloc;
      },
      act: (b) => b.add(FetchWatchlistTvSeries()),
      expect:
          () => [
            const WatchlistTvSeriesState(state: RequestState.loading),
            const WatchlistTvSeriesState(
              state: RequestState.error,
              message: 'DB Error',
            ),
          ],
    );
  });
}
