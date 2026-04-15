import 'package:dartz/dartz.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/entities/movie_detail.dart';
import 'package:movies/domain/repositories/movie_repository.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/domain/usecases/search_movies.dart';
import 'package:movies/domain/usecases/get_watchlist_status_movie.dart';
import 'package:movies/domain/usecases/save_watchlist_movie.dart';
import 'package:movies/domain/usecases/remove_watchlist_movie.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockRepository;

  final tMovies = <Movie>[
    Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
      genreIds: const [28],
    ),
  ];

  const tMovieDetail = MovieDetail(
    id: 1,
    title: 'Test Movie',
    overview: 'Overview',
    voteAverage: 8.0,
    genres: [],
    runtime: 120,
    status: 'Released',
  );

  setUp(() {
    mockRepository = MockMovieRepository();
  });

  group('GetNowPlayingMovies', () {
    test('should get list of now playing movies from repository', () async {
      when(
        () => mockRepository.getNowPlayingMovies(),
      ).thenAnswer((_) async => Right(tMovies));

      final usecase = GetNowPlayingMovies(mockRepository);
      final result = await usecase.execute();

      expect(result, Right(tMovies));
      verify(() => mockRepository.getNowPlayingMovies());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('GetPopularMovies', () {
    test('should get list of popular movies from repository', () async {
      when(
        () => mockRepository.getPopularMovies(),
      ).thenAnswer((_) async => Right(tMovies));

      final usecase = GetPopularMovies(mockRepository);
      final result = await usecase.execute();

      expect(result, Right(tMovies));
      verify(() => mockRepository.getPopularMovies());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('GetTopRatedMovies', () {
    test('should get list of top rated movies from repository', () async {
      when(
        () => mockRepository.getTopRatedMovies(),
      ).thenAnswer((_) async => Right(tMovies));

      final usecase = GetTopRatedMovies(mockRepository);
      final result = await usecase.execute();

      expect(result, Right(tMovies));
      verify(() => mockRepository.getTopRatedMovies());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('GetMovieDetail', () {
    test('should get movie detail from repository', () async {
      when(
        () => mockRepository.getMovieDetail(1),
      ).thenAnswer((_) async => const Right(tMovieDetail));

      final usecase = GetMovieDetail(mockRepository);
      final result = await usecase.execute(1);

      expect(result, const Right(tMovieDetail));
      verify(() => mockRepository.getMovieDetail(1));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('GetMovieRecommendations', () {
    test('should get recommendations from repository', () async {
      when(
        () => mockRepository.getMovieRecommendations(1),
      ).thenAnswer((_) async => Right(tMovies));

      final usecase = GetMovieRecommendations(mockRepository);
      final result = await usecase.execute(1);

      expect(result, Right(tMovies));
      verify(() => mockRepository.getMovieRecommendations(1));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('SearchMovies', () {
    test('should get movies matching query from repository', () async {
      when(
        () => mockRepository.searchMovies('test'),
      ).thenAnswer((_) async => Right(tMovies));

      final usecase = SearchMovies(mockRepository);
      final result = await usecase.execute('test');

      expect(result, Right(tMovies));
      verify(() => mockRepository.searchMovies('test'));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('GetWatchlistStatusMovie', () {
    test('should get watchlist status from repository', () async {
      when(
        () => mockRepository.isAddedToWatchlist(1),
      ).thenAnswer((_) async => true);

      final usecase = GetWatchlistStatusMovie(mockRepository);
      final result = await usecase.execute(1);

      expect(result, true);
      verify(() => mockRepository.isAddedToWatchlist(1));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('SaveWatchlistMovie', () {
    test('should save movie to watchlist in repository', () async {
      when(
        () => mockRepository.saveWatchlist(tMovieDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));

      final usecase = SaveWatchlistMovie(mockRepository);
      final result = await usecase.execute(tMovieDetail);

      expect(result, const Right('Added to Watchlist'));
      verify(() => mockRepository.saveWatchlist(tMovieDetail));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('RemoveWatchlistMovie', () {
    test('should remove movie from watchlist in repository', () async {
      when(
        () => mockRepository.removeWatchlist(tMovieDetail),
      ).thenAnswer((_) async => const Right('Removed from Watchlist'));

      final usecase = RemoveWatchlistMovie(mockRepository);
      final result = await usecase.execute(tMovieDetail);

      expect(result, const Right('Removed from Watchlist'));
      verify(() => mockRepository.removeWatchlist(tMovieDetail));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('GetWatchlistMovies', () {
    test('should get watchlist movies from repository', () async {
      when(
        () => mockRepository.getWatchlistMovies(),
      ).thenAnswer((_) async => Right(tMovies));

      final usecase = GetWatchlistMovies(mockRepository);
      final result = await usecase.execute();

      expect(result, Right(tMovies));
      verify(() => mockRepository.getWatchlistMovies());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
