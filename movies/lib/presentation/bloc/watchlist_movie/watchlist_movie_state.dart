import 'package:equatable/equatable.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';

class WatchlistMovieState extends Equatable {
  final MovieRequestState state;
  final List<Movie> watchlistMovies;
  final String message;

  const WatchlistMovieState({
    this.state = MovieRequestState.empty,
    this.watchlistMovies = const [],
    this.message = '',
  });

  WatchlistMovieState copyWith({
    MovieRequestState? state,
    List<Movie>? watchlistMovies,
    String? message,
  }) {
    return WatchlistMovieState(
      state: state ?? this.state,
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, watchlistMovies, message];
}
