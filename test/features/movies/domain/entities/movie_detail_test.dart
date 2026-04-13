import 'package:movies/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const genre = MovieGenre(id: 1, name: 'Action');

  const movieDetail = MovieDetail(
    id: 1,
    title: 'Test Movie',
    overview: 'Test overview',
    posterPath: '/test.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 8.5,
    releaseDate: '2023-01-01',
    genres: [genre],
    runtime: 120,
    status: 'Released',
  );

  group('MovieGenre Entity', () {
    test('should have correct properties', () {
      expect(genre.id, 1);
      expect(genre.name, 'Action');
    });

    test('props should contain all properties', () {
      expect(genre.props, [1, 'Action']);
    });

    test('should support value equality', () {
      const genre1 = MovieGenre(id: 1, name: 'Action');
      const genre2 = MovieGenre(id: 1, name: 'Action');

      expect(genre1, genre2);
    });

    test('should not be equal when different', () {
      const genre1 = MovieGenre(id: 1, name: 'Action');
      const genre2 = MovieGenre(id: 2, name: 'Drama');

      expect(genre1, isNot(genre2));
    });
  });

  group('MovieDetail Entity', () {
    test('should have correct properties', () {
      expect(movieDetail.id, 1);
      expect(movieDetail.title, 'Test Movie');
      expect(movieDetail.overview, 'Test overview');
      expect(movieDetail.runtime, 120);
      expect(movieDetail.status, 'Released');
      expect(movieDetail.genres, [genre]);
    });

    test('props should contain all properties', () {
      expect(movieDetail.props, [
        1,
        'Test Movie',
        '/test.jpg',
        '/backdrop.jpg',
        'Test overview',
        8.5,
        '2023-01-01',
        [genre],
        120,
        'Released',
      ]);
    });

    test('should support value equality', () {
      const other = MovieDetail(
        id: 1,
        title: 'Test Movie',
        overview: 'Test overview',
        posterPath: '/test.jpg',
        backdropPath: '/backdrop.jpg',
        voteAverage: 8.5,
        releaseDate: '2023-01-01',
        genres: [genre],
        runtime: 120,
        status: 'Released',
      );

      expect(movieDetail, other);
    });

    test('should handle null posterPath and backdropPath', () {
      const detail = MovieDetail(
        id: 2,
        title: 'No Images',
        overview: 'Overview',
        voteAverage: 7.0,
        genres: [],
        runtime: 90,
        status: 'Released',
      );

      expect(detail.posterPath, isNull);
      expect(detail.backdropPath, isNull);
    });
  });
}
