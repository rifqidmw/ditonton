import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_popular_tv_series_test.mocks.dart';

void main() {
  late GetTopRatedTVSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetTopRatedTVSeries(mockRepository);
  });

  final tTvSeries = <TVSeries>[];

  test('should get list of top rated tv series from the repository', () async {
    when(
      mockRepository.getTopRatedTVSeries(),
    ).thenAnswer((_) async => Right(tTvSeries));

    final result = await usecase.execute();

    expect(result, Right(tTvSeries));
    verify(mockRepository.getTopRatedTVSeries());
    verifyNoMoreInteractions(mockRepository);
  });
}
