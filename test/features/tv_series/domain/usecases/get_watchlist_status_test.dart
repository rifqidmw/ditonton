import 'package:ditonton/features/tv_series/domain/usecases/get_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_popular_tv_series_test.mocks.dart';

void main() {
  late GetWatchlistStatus usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetWatchlistStatus(mockRepository);
  });

  test('should get watchlist status from repository', () async {
    when(mockRepository.isAddedToWatchlist(1)).thenAnswer((_) async => true);
    final result = await usecase.execute(1);
    expect(result, true);
    verify(mockRepository.isAddedToWatchlist(1));
  });
}
