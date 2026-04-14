import 'package:equatable/equatable.dart';

abstract class TVSeriesListEvent extends Equatable {
  const TVSeriesListEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTVSeries extends TVSeriesListEvent {}

class FetchTopRatedTVSeries extends TVSeriesListEvent {}

class FetchOnTheAirTVSeries extends TVSeriesListEvent {}
