import 'package:equatable/equatable.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

enum RequestState { empty, loading, loaded, error }

class TVSeriesSearchState extends Equatable {
  final RequestState state;
  final List<TVSeries> searchResult;
  final String message;

  const TVSeriesSearchState({
    this.state = RequestState.empty,
    this.searchResult = const [],
    this.message = '',
  });

  TVSeriesSearchState copyWith({
    RequestState? state,
    List<TVSeries>? searchResult,
    String? message,
  }) {
    return TVSeriesSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];
}
