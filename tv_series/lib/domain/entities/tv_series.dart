import 'package:equatable/equatable.dart';

class TVSeries extends Equatable {
  final int id;
  final String name;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final double voteAverage;
  final String? firstAirDate;
  final List<int> genreIds;

  const TVSeries({
    required this.id,
    required this.name,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    required this.voteAverage,
    this.firstAirDate,
    required this.genreIds,
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
    genreIds,
  ];
}
