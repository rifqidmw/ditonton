import 'package:flutter_test/flutter_test.dart';
import 'package:movies/presentation/bloc/movie_search/movie_search_event.dart';

void main() {
  group('OnMovieQueryChanged', () {
    test('props should contain query', () {
      // ignore: prefer_const_constructors
      final event = OnMovieQueryChanged('avengers');
      expect(event.props, ['avengers']);
    });

    test('should support value equality', () {
      // ignore: prefer_const_constructors
      expect(OnMovieQueryChanged('avengers'), OnMovieQueryChanged('avengers'));
    });

    test('should not be equal with different queries', () {
      // ignore: prefer_const_constructors
      expect(
        // ignore: prefer_const_constructors
        OnMovieQueryChanged('avengers') == OnMovieQueryChanged('batman'),
        false,
      );
    });
  });
}
