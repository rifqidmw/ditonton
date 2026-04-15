import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_season_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_popular_tv_series_test.mocks.dart';

void main() {
  late GetSeasonDetail usecase;
  late MockTVSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTVSeriesRepository();
    usecase = GetSeasonDetail(mockTvSeriesRepository);
  });

  const tTvId = 1;
  const tSeasonNumber = 1;

  const tSeasonDetail = SeasonDetail(
    id: 1,
    name: 'Season 1',
    seasonNumber: 1,
    overview: 'Season overview',
    episodes: [],
  );

  test('should get season detail from the repository', () async {
    when(
      mockTvSeriesRepository.getSeasonDetail(tTvId, tSeasonNumber),
    ).thenAnswer((_) async => const Right(tSeasonDetail));

    final result = await usecase.execute(tTvId, tSeasonNumber);

    expect(result, const Right(tSeasonDetail));
    verify(mockTvSeriesRepository.getSeasonDetail(tTvId, tSeasonNumber));
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });
}
