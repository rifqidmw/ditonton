import 'package:equatable/equatable.dart';

class MovieGenre extends Equatable {
  final int id;
  final String name;

  const MovieGenre({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

class MovieDetail extends Equatable {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final double voteAverage;
  final String? releaseDate;
  final List<MovieGenre> genres;
  final int runtime;
  final String status;

  const MovieDetail({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    required this.voteAverage,
    this.releaseDate,
    required this.genres,
    required this.runtime,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    posterPath,
    backdropPath,
    overview,
    voteAverage,
    releaseDate,
    genres,
    runtime,
    status,
  ];
}
