import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/core/error/failures.dart';
import 'package:ditonton/features/movies/domain/entities/movie.dart';
import 'package:ditonton/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/features/movies/domain/usecases/get_watchlist_status_movie.dart';
import 'package:ditonton/features/movies/domain/usecases/save_watchlist_movie.dart';
import 'package:ditonton/features/movies/domain/usecases/remove_watchlist_movie.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMovieDetail extends Mock implements GetMovieDetail {}

class MockGetMovieRecommendations extends Mock
    implements GetMovieRecommendations {}

class MockGetWatchlistStatusMovie extends Mock
    implements GetWatchlistStatusMovie {}

class MockSaveWatchlistMovie extends Mock implements SaveWatchlistMovie {}

class MockRemoveWatchlistMovie extends Mock implements RemoveWatchlistMovie {}

void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetDetail;
  late MockGetMovieRecommendations mockGetRecommendations;
  late MockGetWatchlistStatusMovie mockGetWatchlistStatus;
  late MockSaveWatchlistMovie mockSaveWatchlist;
  late MockRemoveWatchlistMovie mockRemoveWatchlist;

  const tId = 1;

  const tMovieDetail = MovieDetail(
    id: tId,
    title: 'Test Movie',
    overview: 'Overview',
    voteAverage: 8.5,
    genres: [MovieGenre(id: 28, name: 'Action')],
    runtime: 120,
    status: 'Released',
  );

  final tRecommendations = [
    Movie(
      id: 2,
      title: 'Recommended Movie',
      overview: 'Rec overview',
      posterPath: '/rec.jpg',
      voteAverage: 7.5,
      genreIds: const [28],
    ),
  ];

  setUp(() {
    mockGetDetail = MockGetMovieDetail();
    mockGetRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchlistStatusMovie();
    mockSaveWatchlist = MockSaveWatchlistMovie();
    mockRemoveWatchlist = MockRemoveWatchlistMovie();
    bloc = MovieDetailBloc(
      getMovieDetail: mockGetDetail,
      getMovieRecommendations: mockGetRecommendations,
      getWatchlistStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  tearDown(() => bloc.close());

  test('initial state should be MovieDetailState empty', () {
    expect(bloc.state, const MovieDetailState());
  });

  group('FetchMovieDetail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [loading, loaded] with recommendations when both succeed',
      build: () {
        when(
          () => mockGetDetail.execute(tId),
        ).thenAnswer((_) async => const Right(tMovieDetail));
        when(
          () => mockGetRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tRecommendations));
        return bloc;
      },
      act: (b) => b.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(
          detailState: MovieRequestState.loading,
          watchlistMessage: '',
        ),
        const MovieDetailState(
          detailState: MovieRequestState.loaded,
          movieDetail: tMovieDetail,
          recommendationState: MovieRequestState.loading,
        ),
        MovieDetailState(
          detailState: MovieRequestState.loaded,
          movieDetail: tMovieDetail,
          recommendationState: MovieRequestState.loaded,
          recommendations: tRecommendations,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [loading, error] when fetch detail fails',
      build: () {
        when(
          () => mockGetDetail.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        when(
          () => mockGetRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tRecommendations));
        return bloc;
      },
      act: (b) => b.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(
          detailState: MovieRequestState.loading,
          watchlistMessage: '',
        ),
        const MovieDetailState(
          detailState: MovieRequestState.error,
          detailMessage: 'Server Error',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit loaded detail with recommendation error when rec fails',
      build: () {
        when(
          () => mockGetDetail.execute(tId),
        ).thenAnswer((_) async => const Right(tMovieDetail));
        when(
          () => mockGetRecommendations.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Rec Error')));
        return bloc;
      },
      act: (b) => b.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(
          detailState: MovieRequestState.loading,
          watchlistMessage: '',
        ),
        const MovieDetailState(
          detailState: MovieRequestState.loaded,
          movieDetail: tMovieDetail,
          recommendationState: MovieRequestState.loading,
        ),
        const MovieDetailState(
          detailState: MovieRequestState.loaded,
          movieDetail: tMovieDetail,
          recommendationState: MovieRequestState.error,
          recommendationMessage: 'Rec Error',
        ),
      ],
    );
  });

  group('AddMovieToWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit state with success message and isAddedToWatchlist true',
      build: () {
        when(
          () => mockSaveWatchlist.execute(tMovieDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        return bloc;
      },
      act: (b) => b.add(const AddMovieToWatchlist(tMovieDetail)),
      expect: () => [
        const MovieDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit state with error message when save fails',
      build: () {
        when(
          () => mockSaveWatchlist.execute(tMovieDetail),
        ).thenAnswer((_) async => const Left(DatabaseFailure('Failed to add')));
        return bloc;
      },
      act: (b) => b.add(const AddMovieToWatchlist(tMovieDetail)),
      expect: () => [const MovieDetailState(watchlistMessage: 'Failed to add')],
    );
  });

  group('RemoveMovieFromWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit state with success message and isAddedToWatchlist false',
      build: () {
        when(
          () => mockRemoveWatchlist.execute(tMovieDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        return bloc;
      },
      act: (b) => b.add(const RemoveMovieFromWatchlist(tMovieDetail)),
      expect: () => [
        const MovieDetailState(
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed from Watchlist',
        ),
      ],
    );
  });

  group('LoadMovieWatchlistStatus', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit state with isAddedToWatchlist true',
      build: () {
        when(
          () => mockGetWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (b) => b.add(const LoadMovieWatchlistStatus(tId)),
      expect: () => [const MovieDetailState(isAddedToWatchlist: true)],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit state with isAddedToWatchlist false',
      build: () {
        when(
          () => mockGetWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (b) => b.add(const LoadMovieWatchlistStatus(tId)),
      expect: () => [const MovieDetailState(isAddedToWatchlist: false)],
    );
  });
}
