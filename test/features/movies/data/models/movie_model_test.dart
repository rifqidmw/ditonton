import 'package:ditonton/features/movies/data/models/movie_model.dart';
import 'package:ditonton/features/movies/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tMovieModel = MovieModel(
    id: 1,
    title: 'Test Movie',
    overview: 'Test Overview',
    posterPath: '/test.jpg',
    voteAverage: 8.0,
    genreIds: [1, 2, 3],
  );

  test('should be a subclass of Movie entity', () {
    expect(tMovieModel, isA<Movie>());
  });

  test('should return a valid model from JSON', () {
    final Map<String, dynamic> jsonMap = {
      'id': 1,
      'title': 'Test Movie',
      'overview': 'Test Overview',
      'poster_path': '/test.jpg',
      'vote_average': 8.0,
      'genre_ids': [1, 2, 3],
      'backdrop_path': null,
      'release_date': null,
    };
    final result = MovieModel.fromJson(jsonMap);
    expect(result, tMovieModel);
  });

  test('should return a JSON map containing proper data', () {
    final result = tMovieModel.toJson();
    final expectedJsonMap = {
      'id': 1,
      'title': 'Test Movie',
      'overview': 'Test Overview',
      'poster_path': '/test.jpg',
      'backdrop_path': null,
      'vote_average': 8.0,
      'release_date': null,
      'genre_ids': [1, 2, 3],
    };
    expect(result, expectedJsonMap);
  });

  test('toEntity should return a Movie entity', () {
    final entity = tMovieModel.toEntity();
    expect(entity, isA<Movie>());
    expect(entity.id, tMovieModel.id);
    expect(entity.title, tMovieModel.title);
  });

  group('MovieResponse', () {
    test('fromJson should return a valid MovieResponse', () {
      final Map<String, dynamic> jsonMap = {
        'results': [
          {
            'id': 1,
            'title': 'Test Movie',
            'overview': 'Test Overview',
            'poster_path': '/test.jpg',
            'vote_average': 8.0,
            'genre_ids': [1, 2, 3],
            'backdrop_path': null,
            'release_date': null,
          },
        ],
      };

      final result = MovieResponse.fromJson(jsonMap);

      expect(result.movieList, hasLength(1));
      expect(result.movieList.first, isA<MovieModel>());
      expect(result.movieList.first.id, 1);
    });

    test('fromJson should handle empty results list', () {
      final Map<String, dynamic> jsonMap = {'results': []};
      final result = MovieResponse.fromJson(jsonMap);
      expect(result.movieList, isEmpty);
    });
  });
}
