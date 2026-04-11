import 'package:equatable/equatable.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';

enum RequestState { empty, loading, loaded, error }

class TvSeriesSearchState extends Equatable {
  final RequestState state;
  final List<TvSeries> searchResult;
  final String message;

  const TvSeriesSearchState({
    this.state = RequestState.empty,
    this.searchResult = const [],
    this.message = '',
  });

  TvSeriesSearchState copyWith({
    RequestState? state,
    List<TvSeries>? searchResult,
    String? message,
  }) {
    return TvSeriesSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];
}
