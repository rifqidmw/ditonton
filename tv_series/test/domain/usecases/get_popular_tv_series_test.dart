import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/repositories/tv_series_repository.dart';

import 'get_popular_tv_series_test.mocks.dart';

@GenerateMocks([TVSeriesRepository])
void main() {
  late GetPopularTVSeries usecase;
  late MockTVSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTVSeriesRepository();
    usecase = GetPopularTVSeries(mockTvSeriesRepository);
  });

  final tTvSeries = <TVSeries>[];

  test('should get list of tv series from the repository', () async {
    when(
      mockTvSeriesRepository.getPopularTVSeries(),
    ).thenAnswer((_) async => Right(tTvSeries));
    final result = await usecase.execute();
    expect(result, Right(tTvSeries));
    verify(mockTvSeriesRepository.getPopularTVSeries());
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });
}
