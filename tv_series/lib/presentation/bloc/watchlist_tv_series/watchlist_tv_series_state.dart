import 'package:equatable/equatable.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

enum RequestState { empty, loading, loaded, error }

class WatchlistTVSeriesState extends Equatable {
  final RequestState state;
  final List<TVSeries> watchlistTVSeries;
  final String message;

  const WatchlistTVSeriesState({
    this.state = RequestState.empty,
    this.watchlistTVSeries = const [],
    this.message = '',
  });

  WatchlistTVSeriesState copyWith({
    RequestState? state,
    List<TVSeries>? watchlistTVSeries,
    String? message,
  }) {
    return WatchlistTVSeriesState(
      state: state ?? this.state,
      watchlistTVSeries: watchlistTVSeries ?? this.watchlistTVSeries,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, watchlistTVSeries, message];
}
