import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_popular_tv_series_test.mocks.dart';

void main() {
  late GetOnTheAirTVSeries usecase;
  late MockTVSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTVSeriesRepository();
    usecase = GetOnTheAirTVSeries(mockRepository);
  });

  final tTvSeries = <TVSeries>[];

  test('should get list of on-the-air tv series from the repository', () async {
    when(
      mockRepository.getOnTheAirTVSeries(),
    ).thenAnswer((_) async => Right(tTvSeries));

    final result = await usecase.execute();

    expect(result, Right(tTvSeries));
    verify(mockRepository.getOnTheAirTVSeries());
    verifyNoMoreInteractions(mockRepository);
  });
}
