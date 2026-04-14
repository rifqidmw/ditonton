import 'package:dartz/dartz.dart';
import 'package:core/error/failures.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/repositories/tv_series_repository.dart';

class RemoveWatchlist {
  final TVSeriesRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TVSeriesDetail tvSeries) {
    return repository.removeWatchlist(tvSeries);
  }
}
