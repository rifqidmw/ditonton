import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_popular_tv_series_test.mocks.dart';

void main() {
  late SearchTVSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SearchTVSeries(mockTvSeriesRepository);
  });

  final tTvSeries = <TVSeries>[];
  const tQuery = 'Demon Slayer';

  test('should get list of tv series from the repository', () async {
    when(
      mockTvSeriesRepository.searchTVSeries(tQuery),
    ).thenAnswer((_) async => Right(tTvSeries));
    final result = await usecase.execute(tQuery);
    expect(result, Right(tTvSeries));
    verify(mockTvSeriesRepository.searchTVSeries(tQuery));
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });
}
