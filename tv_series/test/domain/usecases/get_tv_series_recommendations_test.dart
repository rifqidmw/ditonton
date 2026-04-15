import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_popular_tv_series_test.mocks.dart';

void main() {
  late GetTVSeriesRecommendations usecase;
  late MockTVSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTVSeriesRepository();
    usecase = GetTVSeriesRecommendations(mockRepository);
  });

  const tId = 1;
  final tTvSeries = <TVSeries>[];

  test('should get recommendations from the repository', () async {
    when(
      mockRepository.getTVSeriesRecommendations(tId),
    ).thenAnswer((_) async => Right(tTvSeries));

    final result = await usecase.execute(tId);

    expect(result, Right(tTvSeries));
    verify(mockRepository.getTVSeriesRecommendations(tId));
    verifyNoMoreInteractions(mockRepository);
  });
}
