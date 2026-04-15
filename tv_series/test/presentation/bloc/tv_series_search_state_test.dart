import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_search/tv_series_search_state.dart';

void main() {
  group('TVSeriesSearchState', () {
    final tTvSeries = TVSeries(
      id: 1,
      name: 'Test Series',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
      genreIds: const [],
    );

    test('default state should have correct initial values', () {
      const state = TVSeriesSearchState();
      expect(state.state, RequestState.empty);
      expect(state.searchResult, isEmpty);
      expect(state.message, '');
    });

    test('copyWith should update provided fields', () {
      const state = TVSeriesSearchState();
      final updated = state.copyWith(
        state: RequestState.loaded,
        searchResult: [tTvSeries],
        message: 'ok',
      );
      expect(updated.state, RequestState.loaded);
      expect(updated.searchResult, [tTvSeries]);
      expect(updated.message, 'ok');
    });

    test('copyWith with no args should return equivalent state', () {
      const state = TVSeriesSearchState(
        state: RequestState.loading,
        message: 'msg',
      );
      final copy = state.copyWith();
      expect(copy, state);
    });

    test('props should contain all fields', () {
      const state = TVSeriesSearchState(
        state: RequestState.loading,
        searchResult: [],
        message: 'msg',
      );
      expect(state.props, [RequestState.loading, <TVSeries>[], 'msg']);
    });
  });
}
