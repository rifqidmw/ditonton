import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const genreModel = GenreModel(id: 1, name: 'Drama');
  const seasonModel = SeasonModel(
    id: 1,
    name: 'Season 1',
    episodeCount: 10,
    seasonNumber: 1,
    posterPath: '/season1.jpg',
  );

  const tvSeriesDetailModel = TVSeriesDetailModel(
    id: 1,
    name: 'Test TV Series',
    posterPath: '/test.jpg',
    backdropPath: '/backdrop.jpg',
    overview: 'Test overview',
    voteAverage: 8.5,
    firstAirDate: '2023-01-01',
    genres: [genreModel],
    numberOfEpisodes: 20,
    numberOfSeasons: 2,
    seasons: [seasonModel],
    status: 'Returning Series',
  );

  group('GenreModel', () {
    test('should be a subclass of Genre entity', () {
      expect(genreModel, isA<Genre>());
    });

    test('fromJson should return a valid model', () {
      final Map<String, dynamic> jsonMap = {'id': 1, 'name': 'Drama'};

      final result = GenreModel.fromJson(jsonMap);

      expect(result, genreModel);
    });

    test('toJson should return a JSON map', () {
      final result = genreModel.toJson();

      final expectedMap = {'id': 1, 'name': 'Drama'};

      expect(result, expectedMap);
    });

    test('toEntity should return Genre entity', () {
      final result = genreModel.toEntity();

      expect(result.id, genreModel.id);
      expect(result.name, genreModel.name);
    });
  });

  group('SeasonModel', () {
    test('should be a subclass of Season entity', () {
      expect(seasonModel, isA<Season>());
    });

    test('fromJson should return a valid model', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'name': 'Season 1',
        'episode_count': 10,
        'season_number': 1,
        'poster_path': '/season1.jpg',
      };

      final result = SeasonModel.fromJson(jsonMap);

      expect(result, seasonModel);
    });

    test('fromJson should handle null poster_path', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'name': 'Season 1',
        'episode_count': 10,
        'season_number': 1,
        'poster_path': null,
      };

      final result = SeasonModel.fromJson(jsonMap);

      expect(result.posterPath, null);
    });

    test('toJson should return a JSON map', () {
      final result = seasonModel.toJson();

      final expectedMap = {
        'id': 1,
        'name': 'Season 1',
        'episode_count': 10,
        'season_number': 1,
        'poster_path': '/season1.jpg',
      };

      expect(result, expectedMap);
    });

    test('toEntity should return Season entity', () {
      final result = seasonModel.toEntity();

      expect(result.id, seasonModel.id);
      expect(result.name, seasonModel.name);
      expect(result.episodeCount, seasonModel.episodeCount);
      expect(result.seasonNumber, seasonModel.seasonNumber);
      expect(result.posterPath, seasonModel.posterPath);
    });
  });

  group('TvSeriesDetailModel', () {
    test('should be a subclass of TvSeriesDetail entity', () {
      expect(tvSeriesDetailModel, isA<TVSeriesDetail>());
    });

    test('fromJson should return a valid model', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'name': 'Test TV Series',
        'poster_path': '/test.jpg',
        'backdrop_path': '/backdrop.jpg',
        'overview': 'Test overview',
        'vote_average': 8.5,
        'first_air_date': '2023-01-01',
        'genres': [
          {'id': 1, 'name': 'Drama'},
        ],
        'number_of_episodes': 20,
        'number_of_seasons': 2,
        'seasons': [
          {
            'id': 1,
            'name': 'Season 1',
            'episode_count': 10,
            'season_number': 1,
            'poster_path': '/season1.jpg',
          },
        ],
        'status': 'Returning Series',
      };

      final result = TVSeriesDetailModel.fromJson(jsonMap);

      expect(result, tvSeriesDetailModel);
    });

    test('fromJson should handle integer vote_average', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'name': 'Test TV Series',
        'poster_path': '/test.jpg',
        'backdrop_path': '/backdrop.jpg',
        'overview': 'Test overview',
        'vote_average': 8, // Integer instead of double
        'first_air_date': '2023-01-01',
        'genres': [
          {'id': 1, 'name': 'Drama'},
        ],
        'number_of_episodes': 20,
        'number_of_seasons': 2,
        'seasons': [
          {
            'id': 1,
            'name': 'Season 1',
            'episode_count': 10,
            'season_number': 1,
            'poster_path': '/season1.jpg',
          },
        ],
        'status': 'Returning Series',
      };

      final result = TVSeriesDetailModel.fromJson(jsonMap);

      expect(result.voteAverage, 8.0);
    });

    test('toJson should return a JSON map', () {
      final result = tvSeriesDetailModel.toJson();

      final expectedMap = {
        'id': 1,
        'name': 'Test TV Series',
        'poster_path': '/test.jpg',
        'backdrop_path': '/backdrop.jpg',
        'overview': 'Test overview',
        'vote_average': 8.5,
        'first_air_date': '2023-01-01',
        'genres': [
          {'id': 1, 'name': 'Drama'},
        ],
        'number_of_episodes': 20,
        'number_of_seasons': 2,
        'seasons': [
          {
            'id': 1,
            'name': 'Season 1',
            'episode_count': 10,
            'season_number': 1,
            'poster_path': '/season1.jpg',
          },
        ],
        'status': 'Returning Series',
      };

      expect(result, expectedMap);
    });

    test('toEntity should return TvSeriesDetail entity', () {
      final result = tvSeriesDetailModel.toEntity();

      expect(result.id, tvSeriesDetailModel.id);
      expect(result.name, tvSeriesDetailModel.name);
      expect(result.posterPath, tvSeriesDetailModel.posterPath);
      expect(result.backdropPath, tvSeriesDetailModel.backdropPath);
      expect(result.overview, tvSeriesDetailModel.overview);
      expect(result.voteAverage, tvSeriesDetailModel.voteAverage);
      expect(result.firstAirDate, tvSeriesDetailModel.firstAirDate);
      expect(result.numberOfEpisodes, tvSeriesDetailModel.numberOfEpisodes);
      expect(result.numberOfSeasons, tvSeriesDetailModel.numberOfSeasons);
      expect(result.status, tvSeriesDetailModel.status);
    });
  });
}
