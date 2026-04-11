import 'package:dartz/dartz.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/features/tv_series/domain/repositories/tv_series_repository.dart';

import 'get_popular_tv_series_test.mocks.dart';

@GenerateMocks([TvSeriesRepository])
void main() {
  late GetPopularTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetPopularTvSeries(mockTvSeriesRepository);
  });

  final tTvSeries = <TvSeries>[];

  test('should get list of tv series from the repository', () async {
    when(
      mockTvSeriesRepository.getPopularTvSeries(),
    ).thenAnswer((_) async => Right(tTvSeries));
    final result = await usecase.execute();
    expect(result, Right(tTvSeries));
    verify(mockTvSeriesRepository.getPopularTvSeries());
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });
}
