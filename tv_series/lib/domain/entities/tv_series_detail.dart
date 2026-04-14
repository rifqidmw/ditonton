import 'package:equatable/equatable.dart';

class Genre extends Equatable {
  final int id;
  final String name;

  const Genre({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

class Season extends Equatable {
  final int id;
  final String name;
  final int episodeCount;
  final int seasonNumber;
  final String? posterPath;

  const Season({
    required this.id,
    required this.name,
    required this.episodeCount,
    required this.seasonNumber,
    this.posterPath,
  });

  @override
  List<Object?> get props => [id, name, episodeCount, seasonNumber, posterPath];
}

class TVSeriesDetail extends Equatable {
  final int id;
  final String name;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final double voteAverage;
  final String? firstAirDate;
  final List<Genre> genres;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<Season> seasons;
  final String status;

  const TVSeriesDetail({
    required this.id,
    required this.name,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    required this.voteAverage,
    this.firstAirDate,
    required this.genres,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.seasons,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    posterPath,
    backdropPath,
    overview,
    voteAverage,
    firstAirDate,
    genres,
    numberOfEpisodes,
    numberOfSeasons,
    seasons,
    status,
  ];
}

class Episode extends Equatable {
  final int id;
  final String name;
  final int episodeNumber;
  final int seasonNumber;
  final String overview;
  final String? stillPath;
  final double voteAverage;
  final String? airDate;

  const Episode({
    required this.id,
    required this.name,
    required this.episodeNumber,
    required this.seasonNumber,
    required this.overview,
    this.stillPath,
    required this.voteAverage,
    this.airDate,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    episodeNumber,
    seasonNumber,
    overview,
    stillPath,
    voteAverage,
    airDate,
  ];
}

class SeasonDetail extends Equatable {
  final int id;
  final String name;
  final int seasonNumber;
  final String? posterPath;
  final String overview;
  final List<Episode> episodes;

  const SeasonDetail({
    required this.id,
    required this.name,
    required this.seasonNumber,
    this.posterPath,
    required this.overview,
    required this.episodes,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    seasonNumber,
    posterPath,
    overview,
    episodes,
  ];
}
