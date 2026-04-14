import 'package:ditonton/presentation/pages/main_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:go_router/go_router.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:movies/presentation/pages/movie_search_page.dart';
import 'package:movies/presentation/pages/popular_movies_page.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';
import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:tv_series/presentation/pages/tv_series_search_page.dart';
import 'package:tv_series/presentation/pages/watchlist_tv_series_page.dart';

final router = GoRouter(
  initialLocation: '/',
  observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainPage()),
    GoRoute(
      path: '/tv-series/popular',
      builder: (context, state) => const PopularTVSeriesPage(),
    ),
    GoRoute(
      path: '/tv-series/top-rated',
      builder: (context, state) => const TopRatedTVSeriesPage(),
    ),
    GoRoute(
      path: '/tv-series/search',
      builder: (context, state) => const TVSeriesSearchPage(),
    ),
    GoRoute(
      path: '/tv-series/watchlist',
      builder: (context, state) => const WatchlistTVSeriesPage(),
    ),
    GoRoute(
      path: '/tv-series/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return TVSeriesDetailPage(id: id);
      },
    ),
    GoRoute(
      path: '/movies/popular',
      builder: (context, state) => const PopularMoviesPage(),
    ),
    GoRoute(
      path: '/movies/top-rated',
      builder: (context, state) => const TopRatedMoviesPage(),
    ),
    GoRoute(
      path: '/movies/search',
      builder: (context, state) => const MovieSearchPage(),
    ),
    GoRoute(
      path: '/movies/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return MovieDetailPage(id: id);
      },
    ),
  ],
);
