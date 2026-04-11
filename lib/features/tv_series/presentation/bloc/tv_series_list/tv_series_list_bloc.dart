import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_state.dart';

class TvSeriesListBloc extends Bloc<TvSeriesListEvent, TvSeriesListState> {
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;
  final GetOnTheAirTvSeries getOnTheAirTvSeries;

  TvSeriesListBloc({
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
    required this.getOnTheAirTvSeries,
  }) : super(const TvSeriesListState()) {
    on<FetchPopularTvSeries>(_onFetchPopularTvSeries);
    on<FetchTopRatedTvSeries>(_onFetchTopRatedTvSeries);
    on<FetchOnTheAirTvSeries>(_onFetchOnTheAirTvSeries);
  }

  Future<void> _onFetchPopularTvSeries(
    FetchPopularTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(popularState: RequestState.loading));

    final result = await getPopularTvSeries.execute();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            popularState: RequestState.error,
            popularMessage: failure.message,
          ),
        );
      },
      (tvSeriesData) {
        emit(
          state.copyWith(
            popularState: RequestState.loaded,
            popularTvSeries: tvSeriesData,
          ),
        );
      },
    );
  }

  Future<void> _onFetchTopRatedTvSeries(
    FetchTopRatedTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(topRatedState: RequestState.loading));

    final result = await getTopRatedTvSeries.execute();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            topRatedState: RequestState.error,
            topRatedMessage: failure.message,
          ),
        );
      },
      (tvSeriesData) {
        emit(
          state.copyWith(
            topRatedState: RequestState.loaded,
            topRatedTvSeries: tvSeriesData,
          ),
        );
      },
    );
  }

  Future<void> _onFetchOnTheAirTvSeries(
    FetchOnTheAirTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(onTheAirState: RequestState.loading));

    final result = await getOnTheAirTvSeries.execute();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            onTheAirState: RequestState.error,
            onTheAirMessage: failure.message,
          ),
        );
      },
      (tvSeriesData) {
        emit(
          state.copyWith(
            onTheAirState: RequestState.loaded,
            onTheAirTvSeries: tvSeriesData,
          ),
        );
      },
    );
  }
}
