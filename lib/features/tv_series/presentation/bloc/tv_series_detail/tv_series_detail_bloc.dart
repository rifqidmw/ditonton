import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/features/tv_series/domain/usecases/save_watchlist.dart';
import 'package:ditonton/features/tv_series/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchlistStatus getWatchlistStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchlistStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const TvSeriesDetailState()) {
    on<FetchTvSeriesDetail>(_onFetchTvSeriesDetail);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchTvSeriesDetail(
    FetchTvSeriesDetail event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(
      state.copyWith(detailState: RequestState.loading, watchlistMessage: ''),
    );

    final detailResult = await getTvSeriesDetail.execute(event.id);
    final recommendationResult = await getTvSeriesRecommendations.execute(
      event.id,
    );

    detailResult.fold(
      (failure) {
        emit(
          state.copyWith(
            detailState: RequestState.error,
            detailMessage: failure.message,
          ),
        );
      },
      (tvSeries) {
        emit(
          state.copyWith(
            detailState: RequestState.loaded,
            tvSeriesDetail: tvSeries,
            recommendationState: RequestState.loading,
          ),
        );

        recommendationResult.fold(
          (failure) {
            emit(
              state.copyWith(
                recommendationState: RequestState.error,
                recommendationMessage: failure.message,
              ),
            );
          },
          (recommendations) {
            emit(
              state.copyWith(
                recommendationState: RequestState.loaded,
                recommendations: recommendations,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onAddToWatchlist(
    AddToWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.tvSeriesDetail);

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
    RemoveFromWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.tvSeriesDetail);

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
    LoadWatchlistStatus event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await getWatchlistStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
