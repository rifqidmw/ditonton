import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_event.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_state.dart';

class WatchlistTVSeriesBloc
    extends Bloc<WatchlistTVSeriesEvent, WatchlistTVSeriesState> {
  final GetWatchlistTVSeries getWatchlistTVSeries;

  WatchlistTVSeriesBloc({required this.getWatchlistTVSeries})
    : super(const WatchlistTVSeriesState()) {
    on<FetchWatchlistTVSeries>(_onFetchWatchlistTVSeries);
  }

  Future<void> _onFetchWatchlistTVSeries(
    FetchWatchlistTVSeries event,
    Emitter<WatchlistTVSeriesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));
    final result = await getWatchlistTVSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(state: RequestState.error, message: failure.message),
      ),
      (data) => emit(
        state.copyWith(state: RequestState.loaded, watchlistTVSeries: data),
      ),
    );
  }
}
