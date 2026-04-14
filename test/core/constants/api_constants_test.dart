import 'package:core/constants/api_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiConstants', () {
    test('baseUrl should be correct TMDB endpoint', () {
      expect(ApiConstants.baseUrl, 'https://api.themoviedb.org/3');
    });

    test('popularTvSeries URL should contain api_key', () {
      expect(ApiConstants.popularTVSeries, contains('api_key='));
      expect(ApiConstants.popularTVSeries, contains('/tv/popular'));
    });

    test('topRatedTvSeries URL should contain api_key', () {
      expect(ApiConstants.topRatedTVSeries, contains('api_key='));
      expect(ApiConstants.topRatedTVSeries, contains('/tv/top_rated'));
    });

    test('onTheAirTvSeries URL should contain api_key', () {
      expect(ApiConstants.onTheAirTVSeries, contains('api_key='));
      expect(ApiConstants.onTheAirTVSeries, contains('/tv/on_the_air'));
    });

    test('tvSeriesDetail should generate correct URL for given id', () {
      const id = 42;
      final url = ApiConstants.tvSeriesDetail(id);
      expect(url, contains('/tv/42'));
      expect(url, contains('api_key='));
    });

    test(
      'tvSeriesRecommendations should generate correct URL for given id',
      () {
        const id = 99;
        final url = ApiConstants.tvSeriesRecommendations(id);
        expect(url, contains('/tv/99/recommendations'));
        expect(url, contains('api_key='));
      },
    );

    test('searchTvSeries should generate correct URL with query', () {
      const query = 'breaking bad';
      final url = ApiConstants.searchTVSeries(query);
      expect(url, contains('/search/tv'));
      expect(url, contains('query=breaking bad'));
      expect(url, contains('api_key='));
    });

    test('imageUrl should prepend base image URL to path', () {
      const path = '/test.jpg';
      final url = ApiConstants.imageUrl(path);
      expect(url, 'https://image.tmdb.org/t/p/w500/test.jpg');
    });

    test('baseImageUrl should be correct', () {
      expect(ApiConstants.baseImageUrl, 'https://image.tmdb.org/t/p/w500');
    });

    test(
      'tvSeasonDetail should generate correct URL for given tvId and seasonNumber',
      () {
        const tvId = 1;
        const seasonNumber = 2;
        final url = ApiConstants.tvSeasonDetail(tvId, seasonNumber);
        expect(url, contains('/tv/1/season/2'));
        expect(url, contains('api_key='));
      },
    );

    test('nowPlayingMovies URL should contain api_key', () {
      expect(ApiConstants.nowPlayingMovies, contains('api_key='));
      expect(ApiConstants.nowPlayingMovies, contains('/movie/now_playing'));
    });

    test('popularMovies URL should contain api_key', () {
      expect(ApiConstants.popularMovies, contains('api_key='));
      expect(ApiConstants.popularMovies, contains('/movie/popular'));
    });

    test('topRatedMovies URL should contain api_key', () {
      expect(ApiConstants.topRatedMovies, contains('api_key='));
      expect(ApiConstants.topRatedMovies, contains('/movie/top_rated'));
    });

    test('movieDetail should generate correct URL for given id', () {
      const id = 10;
      final url = ApiConstants.movieDetail(id);
      expect(url, contains('/movie/10'));
      expect(url, contains('api_key='));
    });

    test('movieRecommendations should generate correct URL for given id', () {
      const id = 10;
      final url = ApiConstants.movieRecommendations(id);
      expect(url, contains('/movie/10/recommendations'));
      expect(url, contains('api_key='));
    });

    test('searchMovies should generate correct URL with query', () {
      const query = 'inception';
      final url = ApiConstants.searchMovies(query);
      expect(url, contains('/search/movie'));
      expect(url, contains('query=inception'));
      expect(url, contains('api_key='));
    });
  });
}
