import 'package:ditonton/features/movies/domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    super.posterPath,
    super.backdropPath,
    required super.overview,
    required super.voteAverage,
    super.releaseDate,
    required super.genreIds,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    id: json['id'],
    title: json['title'],
    posterPath: json['poster_path'],
    backdropPath: json['backdrop_path'],
    overview: json['overview'],
    voteAverage: (json['vote_average'] as num).toDouble(),
    releaseDate: json['release_date'],
    genreIds: List<int>.from(json['genre_ids'].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'overview': overview,
    'vote_average': voteAverage,
    'release_date': releaseDate,
    'genre_ids': genreIds,
  };

  Movie toEntity() => Movie(
    id: id,
    title: title,
    posterPath: posterPath,
    backdropPath: backdropPath,
    overview: overview,
    voteAverage: voteAverage,
    releaseDate: releaseDate,
    genreIds: genreIds,
  );
}

class MovieResponse {
  final List<MovieModel> movieList;

  MovieResponse({required this.movieList});

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
    movieList: List<MovieModel>.from(
      (json['results'] as List).map((x) => MovieModel.fromJson(x)),
    ),
  );
}
