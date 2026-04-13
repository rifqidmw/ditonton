import 'package:dartz/dartz.dart';
import 'package:core/error/failures.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/repositories/movie_repository.dart';

class GetWatchlistMovies {
  final MovieRepository repository;

  GetWatchlistMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getWatchlistMovies();
  }
}
