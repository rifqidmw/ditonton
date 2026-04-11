import 'package:equatable/equatable.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';

enum RequestState { empty, loading, loaded, error }

class WatchlistTvSeriesState extends Equatable {
  final RequestState state;
  final List<TvSeries> watchlistTvSeries;
  final String message;

  const WatchlistTvSeriesState({
    this.state = RequestState.empty,
    this.watchlistTvSeries = const [],
    this.message = '',
  });

  WatchlistTvSeriesState copyWith({
    RequestState? state,
    List<TvSeries>? watchlistTvSeries,
    String? message,
  }) {
    return WatchlistTvSeriesState(
      state: state ?? this.state,
      watchlistTvSeries: watchlistTvSeries ?? this.watchlistTvSeries,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, watchlistTvSeries, message];
}
