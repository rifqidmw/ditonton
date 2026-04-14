import 'package:equatable/equatable.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

enum RequestState { empty, loading, loaded, error }

class TVSeriesDetailState extends Equatable {
  final RequestState detailState;
  final TVSeriesDetail? tvSeriesDetail;
  final String detailMessage;

  final RequestState recommendationState;
  final List<TVSeries> recommendations;
  final String recommendationMessage;

  final bool isAddedToWatchlist;
  final String watchlistMessage;

  final RequestState seasonDetailState;
  final SeasonDetail? selectedSeasonDetail;
  final String seasonDetailMessage;

  const TVSeriesDetailState({
    this.detailState = RequestState.empty,
    this.tvSeriesDetail,
    this.detailMessage = '',
    this.recommendationState = RequestState.empty,
    this.recommendations = const [],
    this.recommendationMessage = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
    this.seasonDetailState = RequestState.empty,
    this.selectedSeasonDetail,
    this.seasonDetailMessage = '',
  });

  TVSeriesDetailState copyWith({
    RequestState? detailState,
    TVSeriesDetail? tvSeriesDetail,
    String? detailMessage,
    RequestState? recommendationState,
    List<TVSeries>? recommendations,
    String? recommendationMessage,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    RequestState? seasonDetailState,
    SeasonDetail? selectedSeasonDetail,
    String? seasonDetailMessage,
  }) {
    return TVSeriesDetailState(
      detailState: detailState ?? this.detailState,
      tvSeriesDetail: tvSeriesDetail ?? this.tvSeriesDetail,
      detailMessage: detailMessage ?? this.detailMessage,
      recommendationState: recommendationState ?? this.recommendationState,
      recommendations: recommendations ?? this.recommendations,
      recommendationMessage:
          recommendationMessage ?? this.recommendationMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      seasonDetailState: seasonDetailState ?? this.seasonDetailState,
      selectedSeasonDetail: selectedSeasonDetail ?? this.selectedSeasonDetail,
      seasonDetailMessage: seasonDetailMessage ?? this.seasonDetailMessage,
    );
  }

  @override
  List<Object?> get props => [
    detailState,
    tvSeriesDetail,
    detailMessage,
    recommendationState,
    recommendations,
    recommendationMessage,
    isAddedToWatchlist,
    watchlistMessage,
    seasonDetailState,
    selectedSeasonDetail,
    seasonDetailMessage,
  ];
}
