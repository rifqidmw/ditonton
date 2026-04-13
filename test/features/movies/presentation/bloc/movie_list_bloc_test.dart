import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/error/failures.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

void main() {
  late MovieListBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlaying;
  late MockGetPopularMovies mockGetPopular;
  late MockGetTopRatedMovies mockGetTopRated;

  final tMovies = [
    Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
      genreIds: const [28],
    ),
  ];

  setUp(() {
    mockGetNowPlaying = MockGetNowPlayingMovies();
    mockGetPopular = MockGetPopularMovies();
    mockGetTopRated = MockGetTopRatedMovies();
    bloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlaying,
      getPopularMovies: mockGetPopular,
      getTopRatedMovies: mockGetTopRated,
    );
  });

  tearDown(() => bloc.close());

  test(
    'initial state should be MovieListState with empty MovieRequestState',
    () {
      expect(bloc.state, const MovieListState());
    },
  );

  group('FetchNowPlayingMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, loaded] when data is fetched successfully',
      build: () {
        when(
          () => mockGetNowPlaying.execute(),
        ).thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (b) => b.add(FetchNowPlayingMovies()),
      expect: () => [
        const MovieListState(nowPlayingState: MovieRequestState.loading),
        MovieListState(
          nowPlayingState: MovieRequestState.loaded,
          nowPlayingMovies: tMovies,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when fetch fails',
      build: () {
        when(
          () => mockGetNowPlaying.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (b) => b.add(FetchNowPlayingMovies()),
      expect: () => [
        const MovieListState(nowPlayingState: MovieRequestState.loading),
        const MovieListState(
          nowPlayingState: MovieRequestState.error,
          nowPlayingMessage: 'Server Error',
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] on connection failure',
      build: () {
        when(
          () => mockGetNowPlaying.execute(),
        ).thenAnswer((_) async => const Left(ConnectionFailure('No internet')));
        return bloc;
      },
      act: (b) => b.add(FetchNowPlayingMovies()),
      expect: () => [
        const MovieListState(nowPlayingState: MovieRequestState.loading),
        const MovieListState(
          nowPlayingState: MovieRequestState.error,
          nowPlayingMessage: 'No internet',
        ),
      ],
    );
  });

  group('FetchPopularMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, loaded] when data is fetched successfully',
      build: () {
        when(
          () => mockGetPopular.execute(),
        ).thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (b) => b.add(FetchPopularMovies()),
      expect: () => [
        const MovieListState(popularState: MovieRequestState.loading),
        MovieListState(
          popularState: MovieRequestState.loaded,
          popularMovies: tMovies,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when fetch fails',
      build: () {
        when(
          () => mockGetPopular.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (b) => b.add(FetchPopularMovies()),
      expect: () => [
        const MovieListState(popularState: MovieRequestState.loading),
        const MovieListState(
          popularState: MovieRequestState.error,
          popularMessage: 'Server Error',
        ),
      ],
    );
  });

  group('FetchTopRatedMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, loaded] when data is fetched successfully',
      build: () {
        when(
          () => mockGetTopRated.execute(),
        ).thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (b) => b.add(FetchTopRatedMovies()),
      expect: () => [
        const MovieListState(topRatedState: MovieRequestState.loading),
        MovieListState(
          topRatedState: MovieRequestState.loaded,
          topRatedMovies: tMovies,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when fetch fails',
      build: () {
        when(
          () => mockGetTopRated.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (b) => b.add(FetchTopRatedMovies()),
      expect: () => [
        const MovieListState(topRatedState: MovieRequestState.loading),
        const MovieListState(
          topRatedState: MovieRequestState.error,
          topRatedMessage: 'Server Error',
        ),
      ],
    );
  });
}
