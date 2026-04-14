import 'package:equatable/equatable.dart';

abstract class WatchlistTVSeriesEvent extends Equatable {
  const WatchlistTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTVSeries extends WatchlistTVSeriesEvent {}
