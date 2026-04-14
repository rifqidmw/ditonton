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

  const tvSeriesDetail = TVSeriesDetail(
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
      const tvSeriesDetail1 = TVSeriesDetail(
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

      const tvSeriesDetail2 = TVSeriesDetail(
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
      const tvSeriesDetail1 = TVSeriesDetail(
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

      const tvSeriesDetail2 = TVSeriesDetail(
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

  group('Episode Entity', () {
    const tEpisode = Episode(
      id: 1,
      name: 'Pilot',
      episodeNumber: 1,
      seasonNumber: 1,
      overview: 'The beginning.',
      stillPath: '/still.jpg',
      voteAverage: 8.5,
      airDate: '2023-01-01',
    );

    test('should have correct properties', () {
      expect(tEpisode.id, 1);
      expect(tEpisode.name, 'Pilot');
      expect(tEpisode.episodeNumber, 1);
      expect(tEpisode.seasonNumber, 1);
      expect(tEpisode.overview, 'The beginning.');
      expect(tEpisode.stillPath, '/still.jpg');
      expect(tEpisode.voteAverage, 8.5);
      expect(tEpisode.airDate, '2023-01-01');
    });

    test('props should contain all properties', () {
      expect(tEpisode.props, [
        1,
        'Pilot',
        1,
        1,
        'The beginning.',
        '/still.jpg',
        8.5,
        '2023-01-01',
      ]);
    });

    test('should support value equality', () {
      const episode1 = Episode(
        id: 1,
        name: 'Pilot',
        episodeNumber: 1,
        seasonNumber: 1,
        overview: 'The beginning.',
        voteAverage: 8.5,
      );
      const episode2 = Episode(
        id: 1,
        name: 'Pilot',
        episodeNumber: 1,
        seasonNumber: 1,
        overview: 'The beginning.',
        voteAverage: 8.5,
      );
      expect(episode1, episode2);
    });

    test('should handle null stillPath and airDate', () {
      const episode = Episode(
        id: 2,
        name: 'Second',
        episodeNumber: 2,
        seasonNumber: 1,
        overview: '',
        voteAverage: 0,
      );
      expect(episode.stillPath, null);
      expect(episode.airDate, null);
    });
  });

  group('SeasonDetail Entity', () {
    const tEpisode = Episode(
      id: 1,
      name: 'Pilot',
      episodeNumber: 1,
      seasonNumber: 1,
      overview: 'The beginning.',
      voteAverage: 8.5,
    );

    const tSeasonDetail = SeasonDetail(
      id: 1,
      name: 'Season 1',
      seasonNumber: 1,
      posterPath: '/poster.jpg',
      overview: 'First season.',
      episodes: [tEpisode],
    );

    test('should have correct properties', () {
      expect(tSeasonDetail.id, 1);
      expect(tSeasonDetail.name, 'Season 1');
      expect(tSeasonDetail.seasonNumber, 1);
      expect(tSeasonDetail.posterPath, '/poster.jpg');
      expect(tSeasonDetail.overview, 'First season.');
      expect(tSeasonDetail.episodes.length, 1);
    });

    test('props should contain all properties', () {
      expect(tSeasonDetail.props, [
        1,
        'Season 1',
        1,
        '/poster.jpg',
        'First season.',
        [tEpisode],
      ]);
    });

    test('should support value equality', () {
      const sd1 = SeasonDetail(
        id: 1,
        name: 'Season 1',
        seasonNumber: 1,
        overview: '',
        episodes: [],
      );
      const sd2 = SeasonDetail(
        id: 1,
        name: 'Season 1',
        seasonNumber: 1,
        overview: '',
        episodes: [],
      );
      expect(sd1, sd2);
    });

    test('should handle null posterPath', () {
      const sd = SeasonDetail(
        id: 1,
        name: 'Season 1',
        seasonNumber: 1,
        overview: '',
        episodes: [],
      );
      expect(sd.posterPath, null);
    });
  });
}
