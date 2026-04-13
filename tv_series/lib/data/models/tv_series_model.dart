import 'package:tv_series/domain/entities/tv_series.dart';

class TvSeriesModel extends TvSeries {
  const TvSeriesModel({
    required super.id,
    required super.name,
    super.posterPath,
    super.backdropPath,
    required super.overview,
    required super.voteAverage,
    super.firstAirDate,
    required super.genreIds,
  });

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) => TvSeriesModel(
    id: json['id'],
    name: json['name'],
    posterPath: json['poster_path'],
    backdropPath: json['backdrop_path'],
    overview: json['overview'],
    voteAverage: (json['vote_average'] as num).toDouble(),
    firstAirDate: json['first_air_date'],
    genreIds: List<int>.from(json['genre_ids'].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'overview': overview,
    'vote_average': voteAverage,
    'first_air_date': firstAirDate,
    'genre_ids': genreIds,
  };

  TvSeries toEntity() => TvSeries(
    id: id,
    name: name,
    posterPath: posterPath,
    backdropPath: backdropPath,
    overview: overview,
    voteAverage: voteAverage,
    firstAirDate: firstAirDate,
    genreIds: genreIds,
  );
}

class TvSeriesResponse {
  final List<TvSeriesModel> tvSeriesList;

  TvSeriesResponse({required this.tvSeriesList});

  factory TvSeriesResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesResponse(
        tvSeriesList: List<TvSeriesModel>.from(
          (json['results'] as List).map((x) => TvSeriesModel.fromJson(x)),
        ),
      );
}
