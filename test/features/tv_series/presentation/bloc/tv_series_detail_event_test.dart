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
      const event = FetchTVSeriesDetail(1);
      expect(event.props, [1]);
    });

    test('should support value equality', () {
      expect(const FetchTVSeriesDetail(1), const FetchTVSeriesDetail(1));
    });
  });

  group('AddToWatchlist', () {
    test('props should contain tvSeriesDetail', () {
      const event = AddToWatchlist(tTvSeriesDetail);
      expect(event.props, [tTvSeriesDetail]);
    });

    test('should support value equality', () {
      expect(
        const AddToWatchlist(tTvSeriesDetail),
        const AddToWatchlist(tTvSeriesDetail),
      );
    });
  });

  group('RemoveFromWatchlist', () {
    test('props should contain tvSeriesDetail', () {
      const event = RemoveFromWatchlist(tTvSeriesDetail);
      expect(event.props, [tTvSeriesDetail]);
    });

    test('should support value equality', () {
      expect(
        const RemoveFromWatchlist(tTvSeriesDetail),
        const RemoveFromWatchlist(tTvSeriesDetail),
      );
    });
  });

  group('LoadWatchlistStatus', () {
    test('props should contain id', () {
      const event = LoadWatchlistStatus(1);
      expect(event.props, [1]);
    });

    test('should support value equality', () {
      expect(const LoadWatchlistStatus(1), const LoadWatchlistStatus(1));
    });
  });

  group('FetchSeasonDetail', () {
    test('props should contain tvId and seasonNumber', () {
      const event = FetchSeasonDetail(1, 2);
      expect(event.props, [1, 2]);
    });

    test('should support value equality', () {
      expect(const FetchSeasonDetail(1, 2), const FetchSeasonDetail(1, 2));
    });
  });
}
