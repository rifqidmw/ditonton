import 'package:equatable/equatable.dart';
import 'package:movies/domain/entities/movie.dart';

enum MovieRequestState { empty, loading, loaded, error }

class MovieListState extends Equatable {
  final MovieRequestState nowPlayingState;
  final List<Movie> nowPlayingMovies;
  final String nowPlayingMessage;

  final MovieRequestState popularState;
  final List<Movie> popularMovies;
  final String popularMessage;

  final MovieRequestState topRatedState;
  final List<Movie> topRatedMovies;
  final String topRatedMessage;

  const MovieListState({
    this.nowPlayingState = MovieRequestState.empty,
    this.nowPlayingMovies = const [],
    this.nowPlayingMessage = '',
    this.popularState = MovieRequestState.empty,
    this.popularMovies = const [],
    this.popularMessage = '',
    this.topRatedState = MovieRequestState.empty,
    this.topRatedMovies = const [],
    this.topRatedMessage = '',
  });

  MovieListState copyWith({
    MovieRequestState? nowPlayingState,
    List<Movie>? nowPlayingMovies,
    String? nowPlayingMessage,
    MovieRequestState? popularState,
    List<Movie>? popularMovies,
    String? popularMessage,
    MovieRequestState? topRatedState,
    List<Movie>? topRatedMovies,
    String? topRatedMessage,
  }) {
    return MovieListState(
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      nowPlayingMessage: nowPlayingMessage ?? this.nowPlayingMessage,
      popularState: popularState ?? this.popularState,
      popularMovies: popularMovies ?? this.popularMovies,
      popularMessage: popularMessage ?? this.popularMessage,
      topRatedState: topRatedState ?? this.topRatedState,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      topRatedMessage: topRatedMessage ?? this.topRatedMessage,
    );
  }

  @override
  List<Object?> get props => [
    nowPlayingState,
    nowPlayingMovies,
    nowPlayingMessage,
    popularState,
    popularMovies,
    popularMessage,
    topRatedState,
    topRatedMovies,
    topRatedMessage,
  ];
}
