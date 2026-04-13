import 'package:dartz/dartz.dart';
import 'package:core/error/failures.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/repositories/movie_repository.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(int id) {
    return repository.getMovieRecommendations(id);
  }
}
