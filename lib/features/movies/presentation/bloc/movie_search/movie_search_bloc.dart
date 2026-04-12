import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/features/movies/domain/usecases/search_movies.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:rxdart/rxdart.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies})
    : super(const MovieSearchState()) {
    on<OnMovieQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onQueryChanged(
    OnMovieQueryChanged event,
    Emitter<MovieSearchState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(state.copyWith(state: MovieRequestState.empty, searchResult: []));
      return;
    }

    emit(state.copyWith(state: MovieRequestState.loading));

    final result = await searchMovies.execute(query);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            state: MovieRequestState.error,
            message: failure.message,
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(state: MovieRequestState.loaded, searchResult: data),
        );
      },
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
