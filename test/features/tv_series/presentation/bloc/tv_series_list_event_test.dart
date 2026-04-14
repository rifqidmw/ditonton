import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';

void main() {
  group('FetchPopularTVSeries', () {
    test('props should be empty', () {
      expect(FetchPopularTVSeries().props, []);
    });

    test('should support value equality', () {
      expect(FetchPopularTVSeries(), FetchPopularTVSeries());
    });
  });

  group('FetchTopRatedTVSeries', () {
    test('props should be empty', () {
      expect(FetchTopRatedTVSeries().props, []);
    });

    test('should support value equality', () {
      expect(FetchTopRatedTVSeries(), FetchTopRatedTVSeries());
    });
  });

  group('FetchOnTheAirTVSeries', () {
    test('props should be empty', () {
      expect(FetchOnTheAirTVSeries().props, []);
    });

    test('should support value equality', () {
      expect(FetchOnTheAirTVSeries(), FetchOnTheAirTVSeries());
    });
  });
}
