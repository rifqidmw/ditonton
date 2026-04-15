import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tvSeries = TVSeries(
    id: 1,
    name: 'Test TV Series',
    overview: 'Test overview',
    posterPath: '/test.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 8.5,
    firstAirDate: '2023-01-01',
    genreIds: [18, 10765],
  );

  group('TvSeries Entity', () {
    test('should have correct properties', () {
      expect(tvSeries.id, 1);
      expect(tvSeries.name, 'Test TV Series');
      expect(tvSeries.overview, 'Test overview');
      expect(tvSeries.posterPath, '/test.jpg');
      expect(tvSeries.backdropPath, '/backdrop.jpg');
      expect(tvSeries.voteAverage, 8.5);
      expect(tvSeries.firstAirDate, '2023-01-01');
      expect(tvSeries.genreIds, [18, 10765]);
    });

    test('props should contain all properties', () {
      expect(tvSeries.props, [
        1,
        'Test TV Series',
        '/test.jpg',
        '/backdrop.jpg',
        'Test overview',
        8.5,
        '2023-01-01',
        [18, 10765],
      ]);
    });

    test('should support value equality', () {
      const tvSeries1 = TVSeries(
        id: 1,
        name: 'Test',
        overview: 'Overview',
        posterPath: '/test.jpg',
        voteAverage: 8.0,
        genreIds: [18],
      );

      const tvSeries2 = TVSeries(
        id: 1,
        name: 'Test',
        overview: 'Overview',
        posterPath: '/test.jpg',
        voteAverage: 8.0,
        genreIds: [18],
      );

      expect(tvSeries1, tvSeries2);
    });

    test('should not be equal when properties differ', () {
      const tvSeries1 = TVSeries(
        id: 1,
        name: 'Test',
        overview: 'Overview',
        posterPath: '/test.jpg',
        voteAverage: 8.0,
        genreIds: [18],
      );

      const tvSeries2 = TVSeries(
        id: 2,
        name: 'Test',
        overview: 'Overview',
        posterPath: '/test.jpg',
        voteAverage: 8.0,
        genreIds: [18],
      );

      expect(tvSeries1 == tvSeries2, false);
    });
  });
}
