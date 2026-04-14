import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/search_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_search/tv_series_search_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_search/tv_series_search_state.dart';
import 'package:rxdart/rxdart.dart';

class TVSeriesSearchBloc
    extends Bloc<TVSeriesSearchEvent, TVSeriesSearchState> {
  final SearchTVSeries searchTVSeries;

  TVSeriesSearchBloc({required this.searchTVSeries})
    : super(const TVSeriesSearchState()) {
    on<OnQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onQueryChanged(
    OnQueryChanged event,
    Emitter<TVSeriesSearchState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(state.copyWith(state: RequestState.empty, searchResult: []));
      return;
    }

    emit(state.copyWith(state: RequestState.loading));

    final result = await searchTVSeries.execute(query);

    result.fold(
      (failure) => emit(
        state.copyWith(state: RequestState.error, message: failure.message),
      ),
      (data) =>
          emit(state.copyWith(state: RequestState.loaded, searchResult: data)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
