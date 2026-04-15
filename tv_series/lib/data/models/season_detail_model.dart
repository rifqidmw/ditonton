import 'package:tv_series/domain/entities/tv_series_detail.dart';

class EpisodeModel extends Episode {
  const EpisodeModel({
    required super.id,
    required super.name,
    required super.episodeNumber,
    required super.seasonNumber,
    required super.overview,
    super.stillPath,
    required super.voteAverage,
    super.airDate,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'],
      name: json['name'] ?? '',
      episodeNumber: json['episode_number'] ?? 0,
      seasonNumber: json['season_number'] ?? 0,
      overview: json['overview'] ?? '',
      stillPath: json['still_path'],
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      airDate: json['air_date'],
    );
  }
}

class SeasonDetailModel extends SeasonDetail {
  const SeasonDetailModel({
    required super.id,
    required super.name,
    required super.seasonNumber,
    super.posterPath,
    required super.overview,
    required super.episodes,
  });

  factory SeasonDetailModel.fromJson(Map<String, dynamic> json) {
    return SeasonDetailModel(
      id: json['id'],
      name: json['name'] ?? '',
      seasonNumber: json['season_number'] ?? 0,
      posterPath: json['poster_path'],
      overview: json['overview'] ?? '',
      episodes: (json['episodes'] as List<dynamic>? ?? [])
          .map((e) => EpisodeModel.fromJson(e))
          .toList(),
    );
  }
}
