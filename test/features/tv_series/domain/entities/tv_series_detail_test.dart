import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const genre = Genre(id: 1, name: 'Drama');
  const season = Season(
    id: 1,
    name: 'Season 1',
    episodeCount: 10,
    seasonNumber: 1,
    posterPath: '/season1.jpg',
  );

  const tvSeriesDetail = TvSeriesDetail(
    id: 1,
    name: 'Test TV Series',
    overview: 'Test overview',
    posterPath: '/test.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 8.5,
    firstAirDate: '2023-01-01',
    genres: [genre],
    numberOfEpisodes: 20,
    numberOfSeasons: 2,
    seasons: [season],
    status: 'Returning Series',
  );

  group('Genre Entity', () {
    test('should have correct properties', () {
      expect(genre.id, 1);
      expect(genre.name, 'Drama');
    });

    test('props should contain all properties', () {
      expect(genre.props, [1, 'Drama']);
    });

    test('should support value equality', () {
      const genre1 = Genre(id: 1, name: 'Drama');
      const genre2 = Genre(id: 1, name: 'Drama');

      expect(genre1, genre2);
    });
  });

  group('Season Entity', () {
    test('should have correct properties', () {
      expect(season.id, 1);
      expect(season.name, 'Season 1');
      expect(season.episodeCount, 10);
      expect(season.seasonNumber, 1);
      expect(season.posterPath, '/season1.jpg');
    });

    test('props should contain all properties', () {
      expect(season.props, [1, 'Season 1', 10, 1, '/season1.jpg']);
    });

    test('should support value equality', () {
      const season1 = Season(
        id: 1,
        name: 'Season 1',
        episodeCount: 10,
        seasonNumber: 1,
      );
      const season2 = Season(
        id: 1,
        name: 'Season 1',
        episodeCount: 10,
        seasonNumber: 1,
      );

      expect(season1, season2);
    });

    test('should handle null posterPath', () {
      const seasonWithoutPoster = Season(
        id: 1,
        name: 'Season 1',
        episodeCount: 10,
        seasonNumber: 1,
      );

      expect(seasonWithoutPoster.posterPath, null);
    });
  });

  group('TvSeriesDetail Entity', () {
    test('should have correct properties', () {
      expect(tvSeriesDetail.id, 1);
      expect(tvSeriesDetail.name, 'Test TV Series');
      expect(tvSeriesDetail.overview, 'Test overview');
      expect(tvSeriesDetail.posterPath, '/test.jpg');
      expect(tvSeriesDetail.backdropPath, '/backdrop.jpg');
      expect(tvSeriesDetail.voteAverage, 8.5);
      expect(tvSeriesDetail.firstAirDate, '2023-01-01');
      expect(tvSeriesDetail.genres, [genre]);
      expect(tvSeriesDetail.numberOfEpisodes, 20);
      expect(tvSeriesDetail.numberOfSeasons, 2);
      expect(tvSeriesDetail.seasons, [season]);
      expect(tvSeriesDetail.status, 'Returning Series');
    });

    test('props should contain all properties', () {
      expect(tvSeriesDetail.props, [
        1,
        'Test TV Series',
        '/test.jpg',
        '/backdrop.jpg',
        'Test overview',
        8.5,
        '2023-01-01',
        [genre],
        20,
        2,
        [season],
        'Returning Series',
      ]);
    });

    test('should support value equality', () {
      const tvSeriesDetail1 = TvSeriesDetail(
        id: 1,
        name: 'Test',
        overview: 'Overview',
        posterPath: '/test.jpg',
        voteAverage: 8.0,
        genres: [],
        numberOfEpisodes: 10,
        numberOfSeasons: 1,
        seasons: [],
        status: 'Ended',
      );

      const tvSeriesDetail2 = TvSeriesDetail(
        id: 1,
        name: 'Test',
        overview: 'Overview',
        posterPath: '/test.jpg',
        voteAverage: 8.0,
        genres: [],
        numberOfEpisodes: 10,
        numberOfSeasons: 1,
        seasons: [],
        status: 'Ended',
      );

      expect(tvSeriesDetail1, tvSeriesDetail2);
    });

    test('should not be equal when properties differ', () {
      const tvSeriesDetail1 = TvSeriesDetail(
        id: 1,
        name: 'Test',
        overview: 'Overview',
        posterPath: '/test.jpg',
        voteAverage: 8.0,
        genres: [],
        numberOfEpisodes: 10,
        numberOfSeasons: 1,
        seasons: [],
        status: 'Ended',
      );

      const tvSeriesDetail2 = TvSeriesDetail(
        id: 2,
        name: 'Test',
        overview: 'Overview',
        posterPath: '/test.jpg',
        voteAverage: 8.0,
        genres: [],
        numberOfEpisodes: 10,
        numberOfSeasons: 1,
        seasons: [],
        status: 'Ended',
      );

      expect(tvSeriesDetail1 == tvSeriesDetail2, false);
    });
  });
}
