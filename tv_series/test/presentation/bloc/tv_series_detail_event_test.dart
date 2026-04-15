import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';

void main() {
  const tTvSeriesDetail = TVSeriesDetail(
    id: 1,
    name: 'Test',
    overview: 'Overview',
    voteAverage: 8.0,
    genres: [],
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    seasons: [],
    status: 'Ended',
  );

  group('FetchTVSeriesDetail', () {
    test('props should contain id', () {
      // ignore: prefer_const_constructors
      final event = FetchTVSeriesDetail(1);
      expect(event.props, [1]);
    });

    test('should support value equality', () {
      // ignore: prefer_const_constructors
      expect(FetchTVSeriesDetail(1), FetchTVSeriesDetail(1));
    });
  });

  group('AddToWatchlist', () {
    test('props should contain tvSeriesDetail', () {
      // ignore: prefer_const_constructors
      final event = AddToWatchlist(tTvSeriesDetail);
      expect(event.props, [tTvSeriesDetail]);
    });

    test('should support value equality', () {
      // ignore: prefer_const_constructors
      expect(AddToWatchlist(tTvSeriesDetail), AddToWatchlist(tTvSeriesDetail));
    });
  });

  group('RemoveFromWatchlist', () {
    test('props should contain tvSeriesDetail', () {
      // ignore: prefer_const_constructors
      final event = RemoveFromWatchlist(tTvSeriesDetail);
      expect(event.props, [tTvSeriesDetail]);
    });

    test('should support value equality', () {
      // ignore: prefer_const_constructors
      expect(
        // ignore: prefer_const_constructors
        RemoveFromWatchlist(tTvSeriesDetail),
        // ignore: prefer_const_constructors
        RemoveFromWatchlist(tTvSeriesDetail),
      );
    });
  });

  group('LoadWatchlistStatus', () {
    test('props should contain id', () {
      // ignore: prefer_const_constructors
      final event = LoadWatchlistStatus(1);
      expect(event.props, [1]);
    });

    test('should support value equality', () {
      // ignore: prefer_const_constructors
      expect(LoadWatchlistStatus(1), LoadWatchlistStatus(1));
    });
  });

  group('FetchSeasonDetail', () {
    test('props should contain tvId and seasonNumber', () {
      // ignore: prefer_const_constructors
      final event = FetchSeasonDetail(1, 2);
      expect(event.props, [1, 2]);
    });

    test('should support value equality', () {
      // ignore: prefer_const_constructors
      expect(FetchSeasonDetail(1, 2), FetchSeasonDetail(1, 2));
    });
  });
}
