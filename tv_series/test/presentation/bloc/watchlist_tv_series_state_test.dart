import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_state.dart';

void main() {
  group('WatchlistTVSeriesState', () {
    final tTvSeries = TVSeries(
      id: 1,
      name: 'Test Series',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
      genreIds: const [],
    );

    test('default state should have correct initial values', () {
      const state = WatchlistTVSeriesState();
      expect(state.state, RequestState.empty);
      expect(state.watchlistTVSeries, isEmpty);
      expect(state.message, '');
    });

    test('copyWith should update provided fields', () {
      const state = WatchlistTVSeriesState();
      final updated = state.copyWith(
        state: RequestState.loaded,
        watchlistTVSeries: [tTvSeries],
        message: 'ok',
      );
      expect(updated.state, RequestState.loaded);
      expect(updated.watchlistTVSeries, [tTvSeries]);
      expect(updated.message, 'ok');
    });

    test('copyWith with no args should return equivalent state', () {
      const state = WatchlistTVSeriesState(
        state: RequestState.loading,
        message: 'msg',
      );
      final copy = state.copyWith();
      expect(copy, state);
    });

    test('props should contain all fields', () {
      const state = WatchlistTVSeriesState(
        state: RequestState.loading,
        watchlistTVSeries: [],
        message: 'msg',
      );
      expect(state.props, [RequestState.loading, <TVSeries>[], 'msg']);
    });
  });
}
