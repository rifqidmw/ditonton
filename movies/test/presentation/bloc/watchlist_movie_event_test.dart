import 'package:flutter_test/flutter_test.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';

void main() {
  group('FetchWatchlistMovies', () {
    test('props should be empty', () {
      expect(FetchWatchlistMovies().props, []);
    });

    test('should support value equality', () {
      expect(FetchWatchlistMovies(), FetchWatchlistMovies());
    });
  });
}
