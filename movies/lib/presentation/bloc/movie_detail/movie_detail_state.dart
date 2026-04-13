import 'package:equatable/equatable.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/entities/movie_detail.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';

class MovieDetailState extends Equatable {
  final MovieRequestState detailState;
  final MovieDetail? movieDetail;
  final String detailMessage;

  final MovieRequestState recommendationState;
  final List<Movie> recommendations;
  final String recommendationMessage;

  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailState({
    this.detailState = MovieRequestState.empty,
    this.movieDetail,
    this.detailMessage = '',
    this.recommendationState = MovieRequestState.empty,
    this.recommendations = const [],
    this.recommendationMessage = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  MovieDetailState copyWith({
    MovieRequestState? detailState,
    MovieDetail? movieDetail,
    String? detailMessage,
    MovieRequestState? recommendationState,
    List<Movie>? recommendations,
    String? recommendationMessage,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      detailState: detailState ?? this.detailState,
      movieDetail: movieDetail ?? this.movieDetail,
      detailMessage: detailMessage ?? this.detailMessage,
      recommendationState: recommendationState ?? this.recommendationState,
      recommendations: recommendations ?? this.recommendations,
      recommendationMessage:
          recommendationMessage ?? this.recommendationMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    detailState,
    movieDetail,
    detailMessage,
    recommendationState,
    recommendations,
    recommendationMessage,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
