import 'package:tv_series/domain/entities/tv_series_detail.dart';

class GenreModel extends Genre {
  const GenreModel({required super.id, required super.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      GenreModel(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  Genre toEntity() => Genre(id: id, name: name);
}

class SeasonModel extends Season {
  const SeasonModel({
    required super.id,
    required super.name,
    required super.episodeCount,
    required super.seasonNumber,
    super.posterPath,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
    id: json['id'],
    name: json['name'],
    episodeCount: json['episode_count'],
    seasonNumber: json['season_number'],
    posterPath: json['poster_path'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'episode_count': episodeCount,
    'season_number': seasonNumber,
    'poster_path': posterPath,
  };

  Season toEntity() => Season(
    id: id,
    name: name,
    episodeCount: episodeCount,
    seasonNumber: seasonNumber,
    posterPath: posterPath,
  );
}

class TVSeriesDetailModel extends TVSeriesDetail {
  const TVSeriesDetailModel({
    required super.id,
    required super.name,
    super.posterPath,
    super.backdropPath,
    required super.overview,
    required super.voteAverage,
    super.firstAirDate,
    required super.genres,
    required super.numberOfEpisodes,
    required super.numberOfSeasons,
    required super.seasons,
    required super.status,
  });

  factory TVSeriesDetailModel.fromJson(Map<String, dynamic> json) =>
      TVSeriesDetailModel(
        id: json['id'],
        name: json['name'],
        posterPath: json['poster_path'],
        backdropPath: json['backdrop_path'],
        overview: json['overview'],
        voteAverage: (json['vote_average'] as num).toDouble(),
        firstAirDate: json['first_air_date'],
        genres: List<GenreModel>.from(
          json['genres'].map((x) => GenreModel.fromJson(x)),
        ),
        numberOfEpisodes: json['number_of_episodes'],
        numberOfSeasons: json['number_of_seasons'],
        seasons: List<SeasonModel>.from(
          json['seasons'].map((x) => SeasonModel.fromJson(x)),
        ),
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'overview': overview,
    'vote_average': voteAverage,
    'first_air_date': firstAirDate,
    'genres': genres
        .map((genre) => {'id': genre.id, 'name': genre.name})
        .toList(),
    'number_of_episodes': numberOfEpisodes,
    'number_of_seasons': numberOfSeasons,
    'seasons': seasons
        .map(
          (season) => {
            'id': season.id,
            'name': season.name,
            'episode_count': season.episodeCount,
            'season_number': season.seasonNumber,
            'poster_path': season.posterPath,
          },
        )
        .toList(),
    'status': status,
  };

  TVSeriesDetail toEntity() => TVSeriesDetail(
    id: id,
    name: name,
    posterPath: posterPath,
    backdropPath: backdropPath,
    overview: overview,
    voteAverage: voteAverage,
    firstAirDate: firstAirDate,
    genres: genres
        .map((genre) => Genre(id: genre.id, name: genre.name))
        .toList(),
    numberOfEpisodes: numberOfEpisodes,
    numberOfSeasons: numberOfSeasons,
    seasons: seasons
        .map(
          (season) => Season(
            id: season.id,
            name: season.name,
            episodeCount: season.episodeCount,
            seasonNumber: season.seasonNumber,
            posterPath: season.posterPath,
          ),
        )
        .toList(),
    status: status,
  );
}
