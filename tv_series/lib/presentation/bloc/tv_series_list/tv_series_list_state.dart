import 'package:equatable/equatable.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

enum RequestState { empty, loading, loaded, error }

class TVSeriesListState extends Equatable {
  final RequestState popularState;
  final List<TVSeries> popularTVSeries;
  final String popularMessage;

  final RequestState topRatedState;
  final List<TVSeries> topRatedTVSeries;
  final String topRatedMessage;

  final RequestState onTheAirState;
  final List<TVSeries> onTheAirTVSeries;
  final String onTheAirMessage;

  const TVSeriesListState({
    this.popularState = RequestState.empty,
    this.popularTVSeries = const [],
    this.popularMessage = '',
    this.topRatedState = RequestState.empty,
    this.topRatedTVSeries = const [],
    this.topRatedMessage = '',
    this.onTheAirState = RequestState.empty,
    this.onTheAirTVSeries = const [],
    this.onTheAirMessage = '',
  });

  TVSeriesListState copyWith({
    RequestState? popularState,
    List<TVSeries>? popularTVSeries,
    String? popularMessage,
    RequestState? topRatedState,
    List<TVSeries>? topRatedTVSeries,
    String? topRatedMessage,
    RequestState? onTheAirState,
    List<TVSeries>? onTheAirTVSeries,
    String? onTheAirMessage,
  }) {
    return TVSeriesListState(
      popularState: popularState ?? this.popularState,
      popularTVSeries: popularTVSeries ?? this.popularTVSeries,
      popularMessage: popularMessage ?? this.popularMessage,
      topRatedState: topRatedState ?? this.topRatedState,
      topRatedTVSeries: topRatedTVSeries ?? this.topRatedTVSeries,
      topRatedMessage: topRatedMessage ?? this.topRatedMessage,
      onTheAirState: onTheAirState ?? this.onTheAirState,
      onTheAirTVSeries: onTheAirTVSeries ?? this.onTheAirTVSeries,
      onTheAirMessage: onTheAirMessage ?? this.onTheAirMessage,
    );
  }

  @override
  List<Object?> get props => [
    popularState,
    popularTVSeries,
    popularMessage,
    topRatedState,
    topRatedTVSeries,
    topRatedMessage,
    onTheAirState,
    onTheAirTVSeries,
    onTheAirMessage,
  ];
}
