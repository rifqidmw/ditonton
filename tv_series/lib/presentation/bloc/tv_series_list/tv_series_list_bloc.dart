import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:tv_series/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_state.dart';

class TVSeriesListBloc extends Bloc<TVSeriesListEvent, TVSeriesListState> {
  final GetPopularTVSeries getPopularTVSeries;
  final GetTopRatedTVSeries getTopRatedTVSeries;
  final GetOnTheAirTVSeries getOnTheAirTVSeries;

  TVSeriesListBloc({
    required this.getPopularTVSeries,
    required this.getTopRatedTVSeries,
    required this.getOnTheAirTVSeries,
  }) : super(const TVSeriesListState()) {
    on<FetchPopularTVSeries>(_onFetchPopularTVSeries);
    on<FetchTopRatedTVSeries>(_onFetchTopRatedTVSeries);
    on<FetchOnTheAirTVSeries>(_onFetchOnTheAirTVSeries);
  }

  Future<void> _onFetchPopularTVSeries(
    FetchPopularTVSeries event,
    Emitter<TVSeriesListState> emit,
  ) async {
    emit(state.copyWith(popularState: RequestState.loading));
    final result = await getPopularTVSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          popularState: RequestState.error,
          popularMessage: failure.message,
        ),
      ),
      (tvSeriesData) => emit(
        state.copyWith(
          popularState: RequestState.loaded,
          popularTVSeries: tvSeriesData,
        ),
      ),
    );
  }

  Future<void> _onFetchTopRatedTVSeries(
    FetchTopRatedTVSeries event,
    Emitter<TVSeriesListState> emit,
  ) async {
    emit(state.copyWith(topRatedState: RequestState.loading));
    final result = await getTopRatedTVSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          topRatedState: RequestState.error,
          topRatedMessage: failure.message,
        ),
      ),
      (tvSeriesData) => emit(
        state.copyWith(
          topRatedState: RequestState.loaded,
          topRatedTVSeries: tvSeriesData,
        ),
      ),
    );
  }

  Future<void> _onFetchOnTheAirTVSeries(
    FetchOnTheAirTVSeries event,
    Emitter<TVSeriesListState> emit,
  ) async {
    emit(state.copyWith(onTheAirState: RequestState.loading));
    final result = await getOnTheAirTVSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          onTheAirState: RequestState.error,
          onTheAirMessage: failure.message,
        ),
      ),
      (tvSeriesData) => emit(
        state.copyWith(
          onTheAirState: RequestState.loaded,
          onTheAirTVSeries: tvSeriesData,
        ),
      ),
    );
  }
}
