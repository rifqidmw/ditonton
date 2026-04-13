import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_event.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc({required this.getWatchlistTvSeries})
    : super(const WatchlistTvSeriesState()) {
    on<FetchWatchlistTvSeries>(_onFetchWatchlistTvSeries);
  }

  Future<void> _onFetchWatchlistTvSeries(
    FetchWatchlistTvSeries event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));
    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(state: RequestState.error, message: failure.message),
      ),
      (data) => emit(
        state.copyWith(state: RequestState.loaded, watchlistTvSeries: data),
      ),
    );
  }
}
