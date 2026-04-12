import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/features/movies/domain/usecases/get_watchlist_status_movie.dart';
import 'package:ditonton/features/movies/domain/usecases/save_watchlist_movie.dart';
import 'package:ditonton/features/movies/domain/usecases/remove_watchlist_movie.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchlistStatusMovie getWatchlistStatus;
  final SaveWatchlistMovie saveWatchlist;
  final RemoveWatchlistMovie removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchlistStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddMovieToWatchlist>(_onAddToWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadMovieWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        detailState: MovieRequestState.loading,
        watchlistMessage: '',
      ),
    );

    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult = await getMovieRecommendations.execute(
      event.id,
    );

    detailResult.fold(
      (failure) {
        emit(
          state.copyWith(
            detailState: MovieRequestState.error,
            detailMessage: failure.message,
          ),
        );
      },
      (movie) {
        emit(
          state.copyWith(
            detailState: MovieRequestState.loaded,
            movieDetail: movie,
            recommendationState: MovieRequestState.loading,
          ),
        );

        recommendationResult.fold(
          (failure) {
            emit(
              state.copyWith(
                recommendationState: MovieRequestState.error,
                recommendationMessage: failure.message,
              ),
            );
          },
          (recommendations) {
            emit(
              state.copyWith(
                recommendationState: MovieRequestState.loaded,
                recommendations: recommendations,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onAddToWatchlist(
    AddMovieToWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movieDetail);

    result.fold(
      (failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) {
        emit(
          state.copyWith(
            watchlistMessage: successMessage,
            isAddedToWatchlist: true,
          ),
        );
      },
    );
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movieDetail);

    result.fold(
      (failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) {
        emit(
          state.copyWith(
            watchlistMessage: successMessage,
            isAddedToWatchlist: false,
          ),
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadMovieWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getWatchlistStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
