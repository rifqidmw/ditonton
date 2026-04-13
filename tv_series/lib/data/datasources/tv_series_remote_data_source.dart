import 'package:dio/dio.dart';
import 'package:core/constants/api_constants.dart';
import 'package:core/error/exceptions.dart';
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/data/models/tv_series_model.dart';

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getTopRatedTvSeries();
  Future<List<TvSeriesModel>> getOnTheAirTvSeries();
  Future<TvSeriesDetailModel> getTvSeriesDetail(int id);
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id);
  Future<List<TvSeriesModel>> searchTvSeries(String query);
}

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  final Dio client;

  TvSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    final response = await client.get(ApiConstants.popularTvSeries);

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(response.data).tvSeriesList;
    } else {
      throw ServerException('Failed to load popular TV series');
    }
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    final response = await client.get(ApiConstants.topRatedTvSeries);

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(response.data).tvSeriesList;
    } else {
      throw ServerException('Failed to load top rated TV series');
    }
  }

  @override
  Future<List<TvSeriesModel>> getOnTheAirTvSeries() async {
    final response = await client.get(ApiConstants.onTheAirTvSeries);

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(response.data).tvSeriesList;
    } else {
      throw ServerException('Failed to load on the air TV series');
    }
  }

  @override
  Future<TvSeriesDetailModel> getTvSeriesDetail(int id) async {
    final response = await client.get(ApiConstants.tvSeriesDetail(id));

    if (response.statusCode == 200) {
      return TvSeriesDetailModel.fromJson(response.data);
    } else {
      throw ServerException('Failed to load TV series detail');
    }
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    final response = await client.get(ApiConstants.tvSeriesRecommendations(id));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(response.data).tvSeriesList;
    } else {
      throw ServerException('Failed to load TV series recommendations');
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    final response = await client.get(ApiConstants.searchTvSeries(query));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(response.data).tvSeriesList;
    } else {
      throw ServerException('Failed to search TV series');
    }
  }
}
