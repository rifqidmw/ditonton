import 'package:flutter_test/flutter_test.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';

void main() {
  group('WatchlistMovieState', () {
    const tMovie = Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
      genreIds: [],
    );

    test('default state should have correct initial values', () {
      const state = WatchlistMovieState();
      expect(state.state, MovieRequestState.empty);
      expect(state.watchlistMovies, isEmpty);
      expect(state.message, '');
    });

    test('copyWith should update provided fields', () {
      const state = WatchlistMovieState();
      final updated = state.copyWith(
        state: MovieRequestState.loaded,
        watchlistMovies: [tMovie],
        message: 'ok',
      );
      expect(updated.state, MovieRequestState.loaded);
      expect(updated.watchlistMovies, [tMovie]);
      expect(updated.message, 'ok');
    });

    test('copyWith with no args should return equivalent state', () {
      const state = WatchlistMovieState(
        state: MovieRequestState.loading,
        message: 'msg',
      );
      final copy = state.copyWith();
      expect(copy, state);
    });

    test('props should contain all fields', () {
      const state = WatchlistMovieState(
        state: MovieRequestState.loading,
        watchlistMovies: [],
        message: 'msg',
      );
      expect(state.props, [MovieRequestState.loading, <Movie>[], 'msg']);
    });
  });
}
