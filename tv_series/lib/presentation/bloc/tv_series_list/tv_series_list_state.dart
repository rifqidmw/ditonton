import 'package:equatable/equatable.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

enum RequestState { empty, loading, loaded, error }

class TvSeriesListState extends Equatable {
  final RequestState popularState;
  final List<TvSeries> popularTvSeries;
  final String popularMessage;

  final RequestState topRatedState;
  final List<TvSeries> topRatedTvSeries;
  final String topRatedMessage;

  final RequestState onTheAirState;
  final List<TvSeries> onTheAirTvSeries;
  final String onTheAirMessage;

  const TvSeriesListState({
    this.popularState = RequestState.empty,
    this.popularTvSeries = const [],
    this.popularMessage = '',
    this.topRatedState = RequestState.empty,
    this.topRatedTvSeries = const [],
    this.topRatedMessage = '',
    this.onTheAirState = RequestState.empty,
    this.onTheAirTvSeries = const [],
    this.onTheAirMessage = '',
  });

  TvSeriesListState copyWith({
    RequestState? popularState,
    List<TvSeries>? popularTvSeries,
    String? popularMessage,
    RequestState? topRatedState,
    List<TvSeries>? topRatedTvSeries,
    String? topRatedMessage,
    RequestState? onTheAirState,
    List<TvSeries>? onTheAirTvSeries,
    String? onTheAirMessage,
  }) {
    return TvSeriesListState(
      popularState: popularState ?? this.popularState,
      popularTvSeries: popularTvSeries ?? this.popularTvSeries,
      popularMessage: popularMessage ?? this.popularMessage,
      topRatedState: topRatedState ?? this.topRatedState,
      topRatedTvSeries: topRatedTvSeries ?? this.topRatedTvSeries,
      topRatedMessage: topRatedMessage ?? this.topRatedMessage,
      onTheAirState: onTheAirState ?? this.onTheAirState,
      onTheAirTvSeries: onTheAirTvSeries ?? this.onTheAirTvSeries,
      onTheAirMessage: onTheAirMessage ?? this.onTheAirMessage,
    );
  }

  @override
  List<Object?> get props => [
    popularState,
    popularTvSeries,
    popularMessage,
    topRatedState,
    topRatedTvSeries,
    topRatedMessage,
    onTheAirState,
    onTheAirTvSeries,
    onTheAirMessage,
  ];
}
