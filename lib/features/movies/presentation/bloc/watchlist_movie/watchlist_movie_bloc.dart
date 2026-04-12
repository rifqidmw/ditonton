import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:ditonton/features/movies/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';
import 'package:ditonton/features/movies/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieBloc({required this.getWatchlistMovies})
    : super(const WatchlistMovieState()) {
    on<FetchWatchlistMovies>(_onFetchWatchlistMovies);
  }

  Future<void> _onFetchWatchlistMovies(
    FetchWatchlistMovies event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    emit(state.copyWith(state: MovieRequestState.loading));

    final result = await getWatchlistMovies.execute();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            state: MovieRequestState.error,
            message: failure.message,
          ),
        );
      },
      (movies) {
        emit(
          state.copyWith(
            state: MovieRequestState.loaded,
            watchlistMovies: movies,
          ),
        );
      },
    );
  }
}
