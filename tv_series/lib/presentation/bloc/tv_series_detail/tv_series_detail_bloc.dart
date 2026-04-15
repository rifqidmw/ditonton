import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_season_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';

class TVSeriesDetailBloc
    extends Bloc<TVSeriesDetailEvent, TVSeriesDetailState> {
  final GetTVSeriesDetail getTVSeriesDetail;
  final GetTVSeriesRecommendations getTVSeriesRecommendations;
  final GetWatchlistStatus getWatchlistStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;
  final GetSeasonDetail getSeasonDetail;

  TVSeriesDetailBloc({
    required this.getTVSeriesDetail,
    required this.getTVSeriesRecommendations,
    required this.getWatchlistStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getSeasonDetail,
  }) : super(const TVSeriesDetailState()) {
    on<FetchTVSeriesDetail>(_onFetchTVSeriesDetail);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
    on<FetchSeasonDetail>(_onFetchSeasonDetail);
  }

  Future<void> _onFetchTVSeriesDetail(
    FetchTVSeriesDetail event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    emit(
      state.copyWith(detailState: RequestState.loading, watchlistMessage: ''),
    );

    final detailResult = await getTVSeriesDetail.execute(event.id);
    final recommendationResult = await getTVSeriesRecommendations.execute(
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
    Emitter<TVSeriesDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.tvSeriesDetail);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
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
    Emitter<TVSeriesDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.tvSeriesDetail);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
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
    Emitter<TVSeriesDetailState> emit,
  ) async {
    final result = await getWatchlistStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }

  Future<void> _onFetchSeasonDetail(
    FetchSeasonDetail event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    emit(state.copyWith(seasonDetailState: RequestState.loading));
    final result = await getSeasonDetail.execute(
      event.tvId,
      event.seasonNumber,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            seasonDetailState: RequestState.error,
            seasonDetailMessage: failure.message,
          ),
        );
      },
      (seasonDetail) {
        emit(
          state.copyWith(
            seasonDetailState: RequestState.loaded,
            selectedSeasonDetail: seasonDetail,
          ),
        );
      },
    );
  }
}
