import 'package:equatable/equatable.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';

enum RequestState { empty, loading, loaded, error }

class TvSeriesDetailState extends Equatable {
  final RequestState detailState;
  final TvSeriesDetail? tvSeriesDetail;
  final String detailMessage;

  final RequestState recommendationState;
  final List<TvSeries> recommendations;
  final String recommendationMessage;

  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvSeriesDetailState({
    this.detailState = RequestState.empty,
    this.tvSeriesDetail,
    this.detailMessage = '',
    this.recommendationState = RequestState.empty,
    this.recommendations = const [],
    this.recommendationMessage = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  TvSeriesDetailState copyWith({
    RequestState? detailState,
    TvSeriesDetail? tvSeriesDetail,
    String? detailMessage,
    RequestState? recommendationState,
    List<TvSeries>? recommendations,
    String? recommendationMessage,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvSeriesDetailState(
      detailState: detailState ?? this.detailState,
      tvSeriesDetail: tvSeriesDetail ?? this.tvSeriesDetail,
      detailMessage: detailMessage ?? this.detailMessage,
      recommendationState: recommendationState ?? this.recommendationState,
      recommendations: recommendations ?? this.recommendations,
      recommendationMessage:
          recommendationMessage ?? this.recommendationMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
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
  ];
}
