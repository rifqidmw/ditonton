import 'package:flutter_test/flutter_test.dart';
import 'package:movies/presentation/bloc/movie_search/movie_search_event.dart';

void main() {
  group('OnMovieQueryChanged', () {
    test('props should contain query', () {
      const event = OnMovieQueryChanged('avengers');
      expect(event.props, ['avengers']);
    });

    test('should support value equality', () {
      expect(
        const OnMovieQueryChanged('avengers'),
        const OnMovieQueryChanged('avengers'),
      );
    });

    test('should not be equal with different queries', () {
      expect(
        const OnMovieQueryChanged('avengers') ==
            const OnMovieQueryChanged('batman'),
        false,
      );
    });
  });
}
