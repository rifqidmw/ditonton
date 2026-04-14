import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/error/failures.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series/domain/usecases/get_season_detail.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTvSeriesDetail extends Mock implements GetTVSeriesDetail {}

class MockGetTvSeriesRecommendations extends Mock
    implements GetTVSeriesRecommendations {}

class MockGetWatchlistStatus extends Mock implements GetWatchlistStatus {}

class MockSaveWatchlist extends Mock implements SaveWatchlist {}

class MockRemoveWatchlist extends Mock implements RemoveWatchlist {}

class MockGetSeasonDetail extends Mock implements GetSeasonDetail {}

void main() {
  late TVSeriesDetailBloc bloc;
  late MockGetTvSeriesDetail mockGetDetail;
  late MockGetTvSeriesRecommendations mockGetRecommendations;
  late MockGetWatchlistStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  late MockGetSeasonDetail mockGetSeasonDetail;

  const tId = 1;

  const tTvSeriesDetail = TVSeriesDetail(
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
    TVSeries(
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
    mockGetSeasonDetail = MockGetSeasonDetail();
    bloc = TVSeriesDetailBloc(
      getTVSeriesDetail: mockGetDetail,
      getTVSeriesRecommendations: mockGetRecommendations,
      getWatchlistStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
      getSeasonDetail: mockGetSeasonDetail,
    );
  });

  tearDown(() => bloc.close());

  test('initial state should be TvSeriesDetailState empty', () {
    expect(bloc.state, const TVSeriesDetailState());
  });

  group('FetchTvSeriesDetail', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
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
      act: (b) => b.add(const FetchTVSeriesDetail(tId)),
      expect: () => [
        const TVSeriesDetailState(
          detailState: RequestState.loading,
          watchlistMessage: '',
        ),
        const TVSeriesDetailState(
          detailState: RequestState.loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationState: RequestState.loading,
        ),
        TVSeriesDetailState(
          detailState: RequestState.loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationState: RequestState.loaded,
          recommendations: tRecommendations,
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
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
      act: (b) => b.add(const FetchTVSeriesDetail(tId)),
      expect: () => [
        const TVSeriesDetailState(
          detailState: RequestState.loading,
          watchlistMessage: '',
        ),
        const TVSeriesDetailState(
          detailState: RequestState.loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationState: RequestState.loading,
        ),
        const TVSeriesDetailState(
          detailState: RequestState.loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationState: RequestState.error,
          recommendationMessage: 'Rec Error',
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
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
      act: (b) => b.add(const FetchTVSeriesDetail(tId)),
      expect: () => [
        const TVSeriesDetailState(
          detailState: RequestState.loading,
          watchlistMessage: '',
        ),
        const TVSeriesDetailState(
          detailState: RequestState.error,
          detailMessage: 'Server Error',
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
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
      act: (b) => b.add(const FetchTVSeriesDetail(tId)),
      expect: () => [
        const TVSeriesDetailState(
          detailState: RequestState.loading,
          watchlistMessage: '',
        ),
        const TVSeriesDetailState(
          detailState: RequestState.error,
          detailMessage: 'No internet',
        ),
      ],
    );
  });

  group('AddToWatchlist', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit state with isAddedToWatchlist=true on success',
      build: () {
        when(
          () => mockSaveWatchlist.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        return bloc;
      },
      act: (b) => b.add(const AddToWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TVSeriesDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit state with failure message on error',
      build: () {
        when(
          () => mockSaveWatchlist.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => const Left(DatabaseFailure('Failed to add')));
        return bloc;
      },
      act: (b) => b.add(const AddToWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TVSeriesDetailState(watchlistMessage: 'Failed to add'),
      ],
    );
  });

  group('RemoveFromWatchlist', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit state with isAddedToWatchlist=false on success',
      build: () {
        when(
          () => mockRemoveWatchlist.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        return bloc;
      },
      act: (b) => b.add(const RemoveFromWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TVSeriesDetailState(
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed from Watchlist',
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit state with failure message on error',
      build: () {
        when(() => mockRemoveWatchlist.execute(tTvSeriesDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed to remove')),
        );
        return bloc;
      },
      act: (b) => b.add(const RemoveFromWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TVSeriesDetailState(watchlistMessage: 'Failed to remove'),
      ],
    );
  });

  group('LoadWatchlistStatus', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit state with isAddedToWatchlist=true when in watchlist',
      build: () {
        when(
          () => mockGetWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (b) => b.add(const LoadWatchlistStatus(tId)),
      expect: () => [const TVSeriesDetailState(isAddedToWatchlist: true)],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit state with isAddedToWatchlist=false when not in watchlist',
      build: () {
        when(
          () => mockGetWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (b) => b.add(const LoadWatchlistStatus(tId)),
      expect: () => [const TVSeriesDetailState(isAddedToWatchlist: false)],
    );
  });
}
