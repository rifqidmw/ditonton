import 'package:ditonton/features/tv_series/data/models/tv_series_table.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tvSeriesTable = TvSeriesTable(
    id: 1,
    name: 'Test TV Series',
    posterPath: '/test.jpg',
    overview: 'Test overview',
  );

  const tvSeriesDetail = TvSeriesDetail(
    id: 1,
    name: 'Test TV Series',
    posterPath: '/test.jpg',
    backdropPath: '/backdrop.jpg',
    overview: 'Test overview',
    voteAverage: 8.5,
    firstAirDate: '2023-01-01',
    genres: [],
    numberOfEpisodes: 20,
    numberOfSeasons: 2,
    seasons: [],
    status: 'Returning Series',
  );

  group('TvSeriesTable', () {
    test('fromEntity should return a valid TvSeriesTable', () {
      final result = TvSeriesTable.fromEntity(tvSeriesDetail);

      expect(result.id, tvSeriesDetail.id);
      expect(result.name, tvSeriesDetail.name);
      expect(result.posterPath, tvSeriesDetail.posterPath);
      expect(result.overview, tvSeriesDetail.overview);
    });

    test('fromMap should return a valid TvSeriesTable', () {
      final Map<String, dynamic> map = {
        'id': 1,
        'name': 'Test TV Series',
        'posterPath': '/test.jpg',
        'overview': 'Test overview',
      };

      final result = TvSeriesTable.fromMap(map);

      expect(result, isA<TvSeriesTable>());
      expect(result.id, 1);
      expect(result.name, 'Test TV Series');
      expect(result.posterPath, '/test.jpg');
      expect(result.overview, 'Test overview');
    });

    test('fromMap should handle null posterPath', () {
      final Map<String, dynamic> map = {
        'id': 1,
        'name': 'Test TV Series',
        'posterPath': null,
        'overview': 'Test overview',
      };

      final result = TvSeriesTable.fromMap(map);

      expect(result.posterPath, null);
    });

    test('toJson should return a JSON map', () {
      final result = tvSeriesTable.toJson();

      final expectedMap = {
        'id': 1,
        'name': 'Test TV Series',
        'posterPath': '/test.jpg',
        'overview': 'Test overview',
      };

      expect(result, expectedMap);
    });

    test('toEntity should return TvSeries entity', () {
      final result = tvSeriesTable.toEntity();

      expect(result, isA<TvSeries>());
      expect(result.id, tvSeriesTable.id);
      expect(result.name, tvSeriesTable.name);
      expect(result.posterPath, tvSeriesTable.posterPath);
      expect(result.overview, tvSeriesTable.overview);
      expect(result.backdropPath, null);
      expect(result.voteAverage, 0);
      expect(result.genreIds, const []);
    });

    test('toEntity should set default values correctly', () {
      final result = tvSeriesTable.toEntity();

      expect(result.backdropPath, isNull);
      expect(result.voteAverage, 0.0);
      expect(result.genreIds, isEmpty);
    });
  });
}
