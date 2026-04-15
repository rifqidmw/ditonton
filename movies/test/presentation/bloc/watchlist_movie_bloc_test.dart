import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/error/failures.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetWatchlistMovies extends Mock implements GetWatchlistMovies {}

void main() {
  late WatchlistMovieBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  final tWatchlist = [
    Movie(
      id: 1,
      title: 'Watchlist Movie',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.5,
      genreIds: const [28],
    ),
  ];

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);
  });

  tearDown(() => bloc.close());

  test('initial state should be WatchlistMovieState empty', () {
    expect(bloc.state, const WatchlistMovieState());
  });

  group('FetchWatchlistMovies', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [loading, loaded] when data is fetched successfully',
      build: () {
        when(
          () => mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => Right(tWatchlist));
        return bloc;
      },
      act: (b) => b.add(FetchWatchlistMovies()),
      expect: () => [
        const WatchlistMovieState(state: MovieRequestState.loading),
        WatchlistMovieState(
          state: MovieRequestState.loaded,
          watchlistMovies: tWatchlist,
        ),
      ],
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [loading, loaded] with empty list when watchlist is empty',
      build: () {
        when(
          () => mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (b) => b.add(FetchWatchlistMovies()),
      expect: () => [
        const WatchlistMovieState(state: MovieRequestState.loading),
        const WatchlistMovieState(
          state: MovieRequestState.loaded,
          watchlistMovies: [],
        ),
      ],
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [loading, error] when fetch fails',
      build: () {
        when(() => mockGetWatchlistMovies.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure('Database Error')),
        );
        return bloc;
      },
      act: (b) => b.add(FetchWatchlistMovies()),
      expect: () => [
        const WatchlistMovieState(state: MovieRequestState.loading),
        const WatchlistMovieState(
          state: MovieRequestState.error,
          message: 'Database Error',
        ),
      ],
    );
  });
}
