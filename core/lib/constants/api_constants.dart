class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '2174d146bb9c0eab47529b2e77d6b526';

  // TV Series
  static const String popularTVSeries = '$baseUrl/tv/popular?api_key=$apiKey';
  static const String topRatedTVSeries =
      '$baseUrl/tv/top_rated?api_key=$apiKey';
  static const String onTheAirTVSeries =
      '$baseUrl/tv/on_the_air?api_key=$apiKey';

  static String tvSeriesDetail(int id) => '$baseUrl/tv/$id?api_key=$apiKey';
  static String tvSeriesRecommendations(int id) =>
      '$baseUrl/tv/$id/recommendations?api_key=$apiKey';
  static String tvSeasonDetail(int tvId, int seasonNumber) =>
      '$baseUrl/tv/$tvId/season/$seasonNumber?api_key=$apiKey';
  static String searchTVSeries(String query) =>
      '$baseUrl/search/tv?api_key=$apiKey&query=$query';

  // Movies
  static const String nowPlayingMovies =
      '$baseUrl/movie/now_playing?api_key=$apiKey';
  static const String popularMovies = '$baseUrl/movie/popular?api_key=$apiKey';
  static const String topRatedMovies =
      '$baseUrl/movie/top_rated?api_key=$apiKey';

  static String movieDetail(int id) => '$baseUrl/movie/$id?api_key=$apiKey';
  static String movieRecommendations(int id) =>
      '$baseUrl/movie/$id/recommendations?api_key=$apiKey';
  static String searchMovies(String query) =>
      '$baseUrl/search/movie?api_key=$apiKey&query=$query';

  // Image
  static const String baseImageUrl = 'https://image.tmdb.org/t/p/w500';
  static String imageUrl(String path) => '$baseImageUrl$path';
}
