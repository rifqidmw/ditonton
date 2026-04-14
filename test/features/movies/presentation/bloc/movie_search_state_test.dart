import 'package:flutter_test/flutter_test.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:movies/presentation/bloc/movie_search/movie_search_state.dart';

void main() {
  group('MovieSearchState', () {
    const tMovie = Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
      genreIds: [],
    );

    test('default state should have correct initial values', () {
      const state = MovieSearchState();
      expect(state.state, MovieRequestState.empty);
      expect(state.searchResult, isEmpty);
      expect(state.message, '');
    });

    test('copyWith should update provided fields', () {
      const state = MovieSearchState();
      final updated = state.copyWith(
        state: MovieRequestState.loaded,
        searchResult: [tMovie],
        message: 'ok',
      );
      expect(updated.state, MovieRequestState.loaded);
      expect(updated.searchResult, [tMovie]);
      expect(updated.message, 'ok');
    });

    test('copyWith with no args should return equivalent state', () {
      const state = MovieSearchState(
        state: MovieRequestState.loading,
        message: 'msg',
      );
      final copy = state.copyWith();
      expect(copy, state);
    });

    test('props should contain all fields', () {
      const state = MovieSearchState(
        state: MovieRequestState.loading,
        searchResult: [],
        message: 'msg',
      );
      expect(state.props, [MovieRequestState.loading, <Movie>[], 'msg']);
    });
  });
}
