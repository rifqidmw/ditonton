import 'package:movies/domain/entities/movie_detail.dart';

class MovieGenreModel extends MovieGenre {
  const MovieGenreModel({required super.id, required super.name});

  factory MovieGenreModel.fromJson(Map<String, dynamic> json) =>
      MovieGenreModel(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  MovieGenre toEntity() => MovieGenre(id: id, name: name);
}

class MovieDetailModel extends MovieDetail {
  const MovieDetailModel({
    required super.id,
    required super.title,
    super.posterPath,
    super.backdropPath,
    required super.overview,
    required super.voteAverage,
    super.releaseDate,
    required super.genres,
    required super.runtime,
    required super.status,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      MovieDetailModel(
        id: json['id'],
        title: json['title'],
        posterPath: json['poster_path'],
        backdropPath: json['backdrop_path'],
        overview: json['overview'],
        voteAverage: (json['vote_average'] as num).toDouble(),
        releaseDate: json['release_date'],
        genres: List<MovieGenreModel>.from(
          json['genres'].map((x) => MovieGenreModel.fromJson(x)),
        ),
        runtime: json['runtime'] ?? 0,
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'overview': overview,
    'vote_average': voteAverage,
    'release_date': releaseDate,
    'genres': genres.map((g) => {'id': g.id, 'name': g.name}).toList(),
    'runtime': runtime,
    'status': status,
  };

  MovieDetail toEntity() => MovieDetail(
    id: id,
    title: title,
    posterPath: posterPath,
    backdropPath: backdropPath,
    overview: overview,
    voteAverage: voteAverage,
    releaseDate: releaseDate,
    genres: genres.map((g) => MovieGenre(id: g.id, name: g.name)).toList(),
    runtime: runtime,
    status: status,
  );
}
