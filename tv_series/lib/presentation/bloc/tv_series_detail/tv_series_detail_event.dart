import 'package:equatable/equatable.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';

abstract class TVSeriesDetailEvent extends Equatable {
  const TVSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTVSeriesDetail extends TVSeriesDetailEvent {
  final int id;

  const FetchTVSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends TVSeriesDetailEvent {
  final TVSeriesDetail tvSeriesDetail;

  const AddToWatchlist(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class RemoveFromWatchlist extends TVSeriesDetailEvent {
  final TVSeriesDetail tvSeriesDetail;

  const RemoveFromWatchlist(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class LoadWatchlistStatus extends TVSeriesDetailEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class FetchSeasonDetail extends TVSeriesDetailEvent {
  final int tvId;
  final int seasonNumber;

  const FetchSeasonDetail(this.tvId, this.seasonNumber);

  @override
  List<Object> get props => [tvId, seasonNumber];
}
