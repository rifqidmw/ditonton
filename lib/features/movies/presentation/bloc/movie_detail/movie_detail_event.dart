import 'package:equatable/equatable.dart';
import 'package:ditonton/features/movies/domain/entities/movie_detail.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddMovieToWatchlist extends MovieDetailEvent {
  final MovieDetail movieDetail;

  const AddMovieToWatchlist(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class RemoveMovieFromWatchlist extends MovieDetailEvent {
  final MovieDetail movieDetail;

  const RemoveMovieFromWatchlist(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class LoadMovieWatchlistStatus extends MovieDetailEvent {
  final int id;

  const LoadMovieWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
