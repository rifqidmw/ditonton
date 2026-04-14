import 'package:flutter_test/flutter_test.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_event.dart';

void main() {
  group('FetchNowPlayingMovies', () {
    test('props should be empty', () {
      expect(FetchNowPlayingMovies().props, []);
    });

    test('should support value equality', () {
      expect(FetchNowPlayingMovies(), FetchNowPlayingMovies());
    });
  });

  group('FetchPopularMovies', () {
    test('props should be empty', () {
      expect(FetchPopularMovies().props, []);
    });

    test('should support value equality', () {
      expect(FetchPopularMovies(), FetchPopularMovies());
    });
  });

  group('FetchTopRatedMovies', () {
    test('props should be empty', () {
      expect(FetchTopRatedMovies().props, []);
    });

    test('should support value equality', () {
      expect(FetchTopRatedMovies(), FetchTopRatedMovies());
    });
  });
}
