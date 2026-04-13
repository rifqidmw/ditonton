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

class TvSeriesDetail extends Equatable {
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

  const TvSeriesDetail({
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
