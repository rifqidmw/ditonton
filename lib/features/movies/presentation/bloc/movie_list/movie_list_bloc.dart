import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const MovieListState()) {
    on<FetchNowPlayingMovies>(_onFetchNowPlayingMovies);
    on<FetchPopularMovies>(_onFetchPopularMovies);
    on<FetchTopRatedMovies>(_onFetchTopRatedMovies);
  }

  Future<void> _onFetchNowPlayingMovies(
    FetchNowPlayingMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(nowPlayingState: MovieRequestState.loading));

    final result = await getNowPlayingMovies.execute();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            nowPlayingState: MovieRequestState.error,
            nowPlayingMessage: failure.message,
          ),
        );
      },
      (movies) {
        emit(
          state.copyWith(
            nowPlayingState: MovieRequestState.loaded,
            nowPlayingMovies: movies,
          ),
        );
      },
    );
  }

  Future<void> _onFetchPopularMovies(
    FetchPopularMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(popularState: MovieRequestState.loading));

    final result = await getPopularMovies.execute();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            popularState: MovieRequestState.error,
            popularMessage: failure.message,
          ),
        );
      },
      (movies) {
        emit(
          state.copyWith(
            popularState: MovieRequestState.loaded,
            popularMovies: movies,
          ),
        );
      },
    );
  }

  Future<void> _onFetchTopRatedMovies(
    FetchTopRatedMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(topRatedState: MovieRequestState.loading));

    final result = await getTopRatedMovies.execute();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            topRatedState: MovieRequestState.error,
            topRatedMessage: failure.message,
          ),
        );
      },
      (movies) {
        emit(
          state.copyWith(
            topRatedState: MovieRequestState.loaded,
            topRatedMovies: movies,
          ),
        );
      },
    );
  }
}
