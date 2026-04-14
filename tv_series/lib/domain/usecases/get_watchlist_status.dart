import 'package:tv_series/domain/repositories/tv_series_repository.dart';

class GetWatchlistStatus {
  final TVSeriesRepository repository;

  GetWatchlistStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
