import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/error/failures.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTvSeriesDetail extends Mock implements GetTvSeriesDetail {}

class MockGetTvSeriesRecommendations extends Mock
    implements GetTvSeriesRecommendations {}

class MockGetWatchlistStatus extends Mock implements GetWatchlistStatus {}

class MockSaveWatchlist extends Mock implements SaveWatchlist {}

class MockRemoveWatchlist extends Mock implements RemoveWatchlist {}

void main() {
  late TvSeriesDetailBloc bloc;
  late MockGetTvSeriesDetail mockGetDetail;
  late MockGetTvSeriesRecommendations mockGetRecommendations;
  late MockGetWatchlistStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  const tId = 1;

  const tTvSeriesDetail = TvSeriesDetail(
    id: tId,
    name: 'Test Series',
    overview: 'Overview',
    voteAverage: 8.5,
    genres: [Genre(id: 18, name: 'Drama')],
    numberOfEpisodes: 20,
    numberOfSeasons: 2,
    seasons: [
      Season(id: 1, name: 'Season 1', episodeCount: 10, seasonNumber: 1),
    ],
    status: 'Returning Series',
  );

  final tRecommendations = [
    TvSeries(
      id: 2,
      name: 'Recommended',
      overview: 'Rec overview',
      posterPath: '/rec.jpg',
      voteAverage: 7.5,
      genreIds: const [18],
    ),
  ];

  setUp(() {
    mockGetDetail = MockGetTvSeriesDetail();
    mockGetRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchlistStatus = MockGetWatchlistStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = TvSeriesDetailBloc(
      getTvSeriesDetail: mockGetDetail,
      getTvSeriesRecommendations: mockGetRecommendations,
      getWatchlistStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  tearDown(() => bloc.close());

  test('initial state should be TvSeriesDetailState empty', () {
    expect(bloc.state, const TvSeriesDetailState());
  });

  group('FetchTvSeriesDetail', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [loading, loaded] with recommendations when both succeed',
      build: () {
        when(
          () => mockGetDetail.execute(tId),
        ).thenAnswer((_) async => const Right(tTvSeriesDetail));
        when(
          () => mockGetRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tRecommendations));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(
          detailState: RequestState.loading,
          watchlistMessage: '',
        ),
        const TvSeriesDetailState(
          detailState: RequestState.loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationState: RequestState.loading,
        ),
        TvSeriesDetailState(
          detailState: RequestState.loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationState: RequestState.loaded,
          recommendations: tRecommendations,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [loading, loaded] with recommendation error when rec fails',
      build: () {
        when(
          () => mockGetDetail.execute(tId),
        ).thenAnswer((_) async => const Right(tTvSeriesDetail));
        when(
          () => mockGetRecommendations.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Rec Error')));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(
          detailState: RequestState.loading,
          watchlistMessage: '',
        ),
        const TvSeriesDetailState(
          detailState: RequestState.loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationState: RequestState.loading,
        ),
        const TvSeriesDetailState(
          detailState: RequestState.loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationState: RequestState.error,
          recommendationMessage: 'Rec Error',
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [loading, error] when detail fetch fails',
      build: () {
        when(
          () => mockGetDetail.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        when(
          () => mockGetRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tRecommendations));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(
          detailState: RequestState.loading,
          watchlistMessage: '',
        ),
        const TvSeriesDetailState(
          detailState: RequestState.error,
          detailMessage: 'Server Error',
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [loading, error] on connection failure',
      build: () {
        when(
          () => mockGetDetail.execute(tId),
        ).thenAnswer((_) async => const Left(ConnectionFailure('No internet')));
        when(
          () => mockGetRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tRecommendations));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(
          detailState: RequestState.loading,
          watchlistMessage: '',
        ),
        const TvSeriesDetailState(
          detailState: RequestState.error,
          detailMessage: 'No internet',
        ),
      ],
    );
  });

  group('AddToWatchlist', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit state with isAddedToWatchlist=true on success',
      build: () {
        when(
          () => mockSaveWatchlist.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        return bloc;
      },
      act: (b) => b.add(const AddToWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit state with failure message on error',
      build: () {
        when(
          () => mockSaveWatchlist.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => const Left(DatabaseFailure('Failed to add')));
        return bloc;
      },
      act: (b) => b.add(const AddToWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(watchlistMessage: 'Failed to add'),
      ],
    );
  });

  group('RemoveFromWatchlist', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit state with isAddedToWatchlist=false on success',
      build: () {
        when(
          () => mockRemoveWatchlist.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        return bloc;
      },
      act: (b) => b.add(const RemoveFromWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed from Watchlist',
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit state with failure message on error',
      build: () {
        when(() => mockRemoveWatchlist.execute(tTvSeriesDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed to remove')),
        );
        return bloc;
      },
      act: (b) => b.add(const RemoveFromWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(watchlistMessage: 'Failed to remove'),
      ],
    );
  });

  group('LoadWatchlistStatus', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit state with isAddedToWatchlist=true when in watchlist',
      build: () {
        when(
          () => mockGetWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (b) => b.add(const LoadWatchlistStatus(tId)),
      expect: () => [const TvSeriesDetailState(isAddedToWatchlist: true)],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit state with isAddedToWatchlist=false when not in watchlist',
      build: () {
        when(
          () => mockGetWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (b) => b.add(const LoadWatchlistStatus(tId)),
      expect: () => [const TvSeriesDetailState(isAddedToWatchlist: false)],
    );
  });
}
