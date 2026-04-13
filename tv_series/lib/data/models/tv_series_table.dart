import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';

class TvSeriesTable {
  final int id;
  final String name;
  final String? posterPath;
  final String overview;

  TvSeriesTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  factory TvSeriesTable.fromEntity(TvSeriesDetail tvSeries) => TvSeriesTable(
    id: tvSeries.id,
    name: tvSeries.name,
    posterPath: tvSeries.posterPath,
    overview: tvSeries.overview,
  );

  factory TvSeriesTable.fromMap(Map<String, dynamic> map) => TvSeriesTable(
    id: map['id'],
    name: map['name'],
    posterPath: map['posterPath'],
    overview: map['overview'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'posterPath': posterPath,
    'overview': overview,
  };

  TvSeries toEntity() => TvSeries(
    id: id,
    name: name,
    posterPath: posterPath,
    overview: overview,
    backdropPath: null,
    voteAverage: 0,
    genreIds: const [],
  );
}
