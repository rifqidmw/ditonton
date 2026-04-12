import 'package:equatable/equatable.dart';
import 'package:ditonton/features/movies/domain/entities/movie.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_state.dart';

class MovieSearchState extends Equatable {
  final MovieRequestState state;
  final List<Movie> searchResult;
  final String message;

  const MovieSearchState({
    this.state = MovieRequestState.empty,
    this.searchResult = const [],
    this.message = '',
  });

  MovieSearchState copyWith({
    MovieRequestState? state,
    List<Movie>? searchResult,
    String? message,
  }) {
    return MovieSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];
}
