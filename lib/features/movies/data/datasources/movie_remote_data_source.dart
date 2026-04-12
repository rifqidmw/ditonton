import 'package:dio/dio.dart';
import 'package:ditonton/core/constants/api_constants.dart';
import 'package:ditonton/core/error/exceptions.dart';
import 'package:ditonton/features/movies/data/models/movie_detail_model.dart';
import 'package:ditonton/features/movies/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailModel> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await client.get(ApiConstants.nowPlayingMovies);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(response.data).movieList;
    } else {
      throw ServerException('Failed to load now playing movies');
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await client.get(ApiConstants.popularMovies);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(response.data).movieList;
    } else {
      throw ServerException('Failed to load popular movies');
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await client.get(ApiConstants.topRatedMovies);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(response.data).movieList;
    } else {
      throw ServerException('Failed to load top rated movies');
    }
  }

  @override
  Future<MovieDetailModel> getMovieDetail(int id) async {
    final response = await client.get(ApiConstants.movieDetail(id));

    if (response.statusCode == 200) {
      return MovieDetailModel.fromJson(response.data);
    } else {
      throw ServerException('Failed to load movie detail');
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final response = await client.get(ApiConstants.movieRecommendations(id));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(response.data).movieList;
    } else {
      throw ServerException('Failed to load movie recommendations');
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get(ApiConstants.searchMovies(query));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(response.data).movieList;
    } else {
      throw ServerException('Failed to search movies');
    }
  }
}
