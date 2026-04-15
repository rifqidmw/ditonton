import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_event.dart';

void main() {
  group('FetchWatchlistTVSeries', () {
    test('props should be empty', () {
      expect(FetchWatchlistTVSeries().props, []);
    });

    test('should support value equality', () {
      expect(FetchWatchlistTVSeries(), FetchWatchlistTVSeries());
    });
  });
}
