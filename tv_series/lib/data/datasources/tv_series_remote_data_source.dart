import 'package:dio/dio.dart';
import 'package:core/constants/api_constants.dart';
import 'package:core/error/exceptions.dart';
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/data/models/tv_series_model.dart';
import 'package:tv_series/data/models/season_detail_model.dart';

abstract class TVSeriesRemoteDataSource {
  Future<List<TVSeriesModel>> getPopularTVSeries();
  Future<List<TVSeriesModel>> getTopRatedTVSeries();
  Future<List<TVSeriesModel>> getOnTheAirTVSeries();
  Future<TVSeriesDetailModel> getTVSeriesDetail(int id);
  Future<List<TVSeriesModel>> getTVSeriesRecommendations(int id);
  Future<List<TVSeriesModel>> searchTVSeries(String query);
  Future<SeasonDetailModel> getSeasonDetail(int tvId, int seasonNumber);
}

class TVSeriesRemoteDataSourceImpl implements TVSeriesRemoteDataSource {
  final Dio client;

  TVSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TVSeriesModel>> getPopularTVSeries() async {
    final response = await client.get(ApiConstants.popularTVSeries);

    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(response.data).tvSeriesList;
    } else {
      throw ServerException('Failed to load popular TV series');
    }
  }

  @override
  Future<List<TVSeriesModel>> getTopRatedTVSeries() async {
    final response = await client.get(ApiConstants.topRatedTVSeries);

    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(response.data).tvSeriesList;
    } else {
      throw ServerException('Failed to load top rated TV series');
    }
  }

  @override
  Future<List<TVSeriesModel>> getOnTheAirTVSeries() async {
    final response = await client.get(ApiConstants.onTheAirTVSeries);

    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(response.data).tvSeriesList;
    } else {
      throw ServerException('Failed to load on the air TV series');
    }
  }

  @override
  Future<TVSeriesDetailModel> getTVSeriesDetail(int id) async {
    final response = await client.get(ApiConstants.tvSeriesDetail(id));

    if (response.statusCode == 200) {
      return TVSeriesDetailModel.fromJson(response.data);
    } else {
      throw ServerException('Failed to load TV series detail');
    }
  }

  @override
  Future<List<TVSeriesModel>> getTVSeriesRecommendations(int id) async {
    final response = await client.get(ApiConstants.tvSeriesRecommendations(id));

    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(response.data).tvSeriesList;
    } else {
      throw ServerException('Failed to load TV series recommendations');
    }
  }

  @override
  Future<List<TVSeriesModel>> searchTVSeries(String query) async {
    final response = await client.get(ApiConstants.searchTVSeries(query));

    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(response.data).tvSeriesList;
    } else {
      throw ServerException('Failed to search TV series');
    }
  }

  @override
  Future<SeasonDetailModel> getSeasonDetail(int tvId, int seasonNumber) async {
    final response = await client.get(
      ApiConstants.tvSeasonDetail(tvId, seasonNumber),
    );

    if (response.statusCode == 200) {
      return SeasonDetailModel.fromJson(response.data);
    } else {
      throw ServerException('Failed to load season detail');
    }
  }
}
