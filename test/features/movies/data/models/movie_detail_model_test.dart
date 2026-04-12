import 'package:ditonton/features/movies/data/models/movie_detail_model.dart';
import 'package:ditonton/features/movies/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tGenreModel = MovieGenreModel(id: 28, name: 'Action');

  const tMovieDetailModel = MovieDetailModel(
    id: 1,
    title: 'Test Movie',
    overview: 'Test overview',
    posterPath: '/test.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 8.5,
    releaseDate: '2023-07-01',
    genres: [tGenreModel],
    runtime: 120,
    status: 'Released',
  );

  group('MovieGenreModel', () {
    test('fromJson should return a valid model', () {
      final Map<String, dynamic> json = {'id': 28, 'name': 'Action'};
      final result = MovieGenreModel.fromJson(json);
      expect(result, tGenreModel);
    });

    test('toJson should return a valid map', () {
      final result = tGenreModel.toJson();
      expect(result, {'id': 28, 'name': 'Action'});
    });

    test('toEntity should return a MovieGenre', () {
      final entity = tGenreModel.toEntity();
      expect(entity, isA<MovieGenre>());
      expect(entity.id, 28);
      expect(entity.name, 'Action');
    });
  });

  group('MovieDetailModel', () {
    test('should be a subclass of MovieDetail entity', () {
      expect(tMovieDetailModel, isA<MovieDetail>());
    });

    test('fromJson should return a valid model', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'title': 'Test Movie',
        'overview': 'Test overview',
        'poster_path': '/test.jpg',
        'backdrop_path': '/backdrop.jpg',
        'vote_average': 8.5,
        'release_date': '2023-07-01',
        'genres': [
          {'id': 28, 'name': 'Action'},
        ],
        'runtime': 120,
        'status': 'Released',
      };

      final result = MovieDetailModel.fromJson(json);

      expect(result.id, 1);
      expect(result.title, 'Test Movie');
      expect(result.runtime, 120);
      expect(result.genres, hasLength(1));
      expect(result.genres.first.name, 'Action');
    });

    test('fromJson should handle null runtime', () {
      final Map<String, dynamic> json = {
        'id': 2,
        'title': 'No Runtime',
        'overview': 'Overview',
        'poster_path': null,
        'backdrop_path': null,
        'vote_average': 7.0,
        'release_date': null,
        'genres': [],
        'runtime': null,
        'status': 'Released',
      };

      final result = MovieDetailModel.fromJson(json);
      expect(result.runtime, 0);
    });

    test('toJson should return a valid map', () {
      final result = tMovieDetailModel.toJson();
      expect(result['id'], 1);
      expect(result['title'], 'Test Movie');
      expect(result['runtime'], 120);
      expect((result['genres'] as List).first['name'], 'Action');
    });

    test('toEntity should return a MovieDetail', () {
      final entity = tMovieDetailModel.toEntity();
      expect(entity, isA<MovieDetail>());
      expect(entity.id, tMovieDetailModel.id);
      expect(entity.title, tMovieDetailModel.title);
      expect(entity.genres.first, isA<MovieGenre>());
    });
  });
}
