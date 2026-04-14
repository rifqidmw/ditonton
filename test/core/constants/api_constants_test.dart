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
  });
}
