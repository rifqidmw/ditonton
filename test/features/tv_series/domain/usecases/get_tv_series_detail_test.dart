import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_popular_tv_series_test.mocks.dart';

void main() {
  late GetTvSeriesDetail usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesDetail(mockTvSeriesRepository);
  });

  const tId = 1;
  const tTvSeriesDetail = TvSeriesDetail(
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

  test('should get tv series detail from the repository', () async {
    when(
      mockTvSeriesRepository.getTvSeriesDetail(tId),
    ).thenAnswer((_) async => const Right(tTvSeriesDetail));
    final result = await usecase.execute(tId);
    expect(result, const Right(tTvSeriesDetail));
    verify(mockTvSeriesRepository.getTvSeriesDetail(tId));
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });
}
