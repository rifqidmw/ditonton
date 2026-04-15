import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_popular_tv_series_test.mocks.dart';

void main() {
  late RemoveWatchlist usecase;
  late MockTVSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTVSeriesRepository();
    usecase = RemoveWatchlist(mockRepository);
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

  test('should remove tv series from the watchlist via repository', () async {
    when(
      mockRepository.removeWatchlist(tTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Removed from Watchlist'));

    final result = await usecase.execute(tTvSeriesDetail);

    expect(result, const Right('Removed from Watchlist'));
    verify(mockRepository.removeWatchlist(tTvSeriesDetail));
    verifyNoMoreInteractions(mockRepository);
  });
}
