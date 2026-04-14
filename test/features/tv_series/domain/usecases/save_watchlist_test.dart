import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_popular_tv_series_test.mocks.dart';

void main() {
  late SaveWatchlist usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SaveWatchlist(mockTvSeriesRepository);
  });

  const tTvSeriesDetail = TVSeriesDetail(
    id: 1,
    name: 'Test',
    overview: 'Test Overview',
    voteAverage: 8.0,
    genres: [],
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    seasons: [],
    status: 'Ended',
  );

  test('should save tv series to the repository', () async {
    when(
      mockTvSeriesRepository.saveWatchlist(tTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Added to Watchlist'));
    final result = await usecase.execute(tTvSeriesDetail);
    verify(mockTvSeriesRepository.saveWatchlist(tTvSeriesDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
