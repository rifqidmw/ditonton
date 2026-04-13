import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_popular_tv_series_test.mocks.dart';

void main() {
  late GetWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetWatchlistTvSeries(mockRepository);
  });

  final tTvSeries = <TvSeries>[];

  test('should get watchlist tv series from the repository', () async {
    when(
      mockRepository.getWatchlistTvSeries(),
    ).thenAnswer((_) async => Right(tTvSeries));

    final result = await usecase.execute();

    expect(result, Right(tTvSeries));
    verify(mockRepository.getWatchlistTvSeries());
    verifyNoMoreInteractions(mockRepository);
  });
}
