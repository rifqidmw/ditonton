import 'package:movies/data/models/movie_table.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final movieTable = MovieTable(
    id: 1,
    title: 'Test Movie',
    posterPath: '/test.jpg',
    overview: 'Test overview',
  );

  const movieDetail = MovieDetail(
    id: 1,
    title: 'Test Movie',
    posterPath: '/test.jpg',
    backdropPath: '/backdrop.jpg',
    overview: 'Test overview',
    voteAverage: 8.5,
    releaseDate: '2023-01-01',
    genres: [],
    runtime: 120,
    status: 'Released',
  );

  group('MovieTable', () {
    test('fromEntity should return a valid MovieTable', () {
      final result = MovieTable.fromEntity(movieDetail);

      expect(result.id, movieDetail.id);
      expect(result.title, movieDetail.title);
      expect(result.posterPath, movieDetail.posterPath);
      expect(result.overview, movieDetail.overview);
    });

    test('fromMap should return a valid MovieTable', () {
      final Map<String, dynamic> map = {
        'id': 1,
        'title': 'Test Movie',
        'posterPath': '/test.jpg',
        'overview': 'Test overview',
      };

      final result = MovieTable.fromMap(map);

      expect(result, isA<MovieTable>());
      expect(result.id, 1);
      expect(result.title, 'Test Movie');
      expect(result.posterPath, '/test.jpg');
      expect(result.overview, 'Test overview');
    });

    test('fromMap should handle null posterPath', () {
      final Map<String, dynamic> map = {
        'id': 1,
        'title': 'Test Movie',
        'posterPath': null,
        'overview': 'Test overview',
      };

      final result = MovieTable.fromMap(map);

      expect(result.posterPath, isNull);
    });

    test('toJson should return a valid map', () {
      final result = movieTable.toJson();

      expect(result['id'], 1);
      expect(result['title'], 'Test Movie');
      expect(result['posterPath'], '/test.jpg');
      expect(result['overview'], 'Test overview');
    });

    test('toEntity should return a Movie entity', () {
      final result = movieTable.toEntity();

      expect(result, isA<Movie>());
      expect(result.id, movieTable.id);
      expect(result.title, movieTable.title);
      expect(result.posterPath, movieTable.posterPath);
      expect(result.overview, movieTable.overview);
    });

    test('toEntity should have empty genreIds', () {
      final result = movieTable.toEntity();
      expect(result.genreIds, isEmpty);
    });
  });
}
