import 'package:equatable/equatable.dart';

abstract class TvSeriesListEvent extends Equatable {
  const TvSeriesListEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTvSeries extends TvSeriesListEvent {}

class FetchTopRatedTvSeries extends TvSeriesListEvent {}

class FetchOnTheAirTvSeries extends TvSeriesListEvent {}
