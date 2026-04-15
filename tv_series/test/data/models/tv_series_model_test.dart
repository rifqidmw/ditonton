import 'package:tv_series/data/models/tv_series_model.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTvSeriesModel = TVSeriesModel(
    id: 1,
    name: 'Test Name',
    overview: 'Test Overview',
    posterPath: '/test.jpg',
    voteAverage: 8.0,
    genreIds: [1, 2, 3],
  );

  test('should be a subclass of TvSeries entity', () async {
    expect(tTvSeriesModel, isA<TVSeries>());
  });

  test('should return a valid model from JSON', () async {
    final Map<String, dynamic> jsonMap = {
      'id': 1,
      'name': 'Test Name',
      'overview': 'Test Overview',
      'poster_path': '/test.jpg',
      'vote_average': 8.0,
      'genre_ids': [1, 2, 3],
      'backdrop_path': null,
      'first_air_date': null,
    };
    final result = TVSeriesModel.fromJson(jsonMap);
    expect(result, tTvSeriesModel);
  });

  test('should return a JSON map containing proper data', () async {
    final result = tTvSeriesModel.toJson();
    final expectedJsonMap = {
      'id': 1,
      'name': 'Test Name',
      'overview': 'Test Overview',
      'poster_path': '/test.jpg',
      'backdrop_path': null,
      'vote_average': 8.0,
      'first_air_date': null,
      'genre_ids': [1, 2, 3],
    };
    expect(result, expectedJsonMap);
  });

  test('toEntity should return a TVSeries entity with same data', () {
    final entity = tTvSeriesModel.toEntity();
    expect(entity.id, tTvSeriesModel.id);
    expect(entity.name, tTvSeriesModel.name);
    expect(entity.overview, tTvSeriesModel.overview);
    expect(entity.posterPath, tTvSeriesModel.posterPath);
    expect(entity.voteAverage, tTvSeriesModel.voteAverage);
    expect(entity.genreIds, tTvSeriesModel.genreIds);
  });

  group('TVSeriesResponse', () {
    test('should return a valid TVSeriesResponse from JSON', () {
      final Map<String, dynamic> jsonMap = {
        'results': [
          {
            'id': 1,
            'name': 'Test Name',
            'overview': 'Test Overview',
            'poster_path': '/test.jpg',
            'backdrop_path': null,
            'vote_average': 8.0,
            'first_air_date': null,
            'genre_ids': [1, 2, 3],
          },
        ],
      };

      final result = TVSeriesResponse.fromJson(jsonMap);

      expect(result.tvSeriesList.length, 1);
      expect(result.tvSeriesList.first, tTvSeriesModel);
    });

    test('should return empty list when results is empty', () {
      final Map<String, dynamic> jsonMap = {'results': []};
      final result = TVSeriesResponse.fromJson(jsonMap);
      expect(result.tvSeriesList, isEmpty);
    });
  });
}
