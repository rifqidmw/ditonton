class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '2174d146bb9c0eab47529b2e77d6b526';

  static const String popularTvSeries = '$baseUrl/tv/popular?api_key=$apiKey';
  static const String topRatedTvSeries =
      '$baseUrl/tv/top_rated?api_key=$apiKey';
  static const String onTheAirTvSeries =
      '$baseUrl/tv/on_the_air?api_key=$apiKey';

  static String tvSeriesDetail(int id) => '$baseUrl/tv/$id?api_key=$apiKey';
  static String tvSeriesRecommendations(int id) =>
      '$baseUrl/tv/$id/recommendations?api_key=$apiKey';
  static String searchTvSeries(String query) =>
      '$baseUrl/search/tv?api_key=$apiKey&query=$query';

  // Image
  static const String baseImageUrl = 'https://image.tmdb.org/t/p/w500';
  static String imageUrl(String path) => '$baseImageUrl$path';
}
