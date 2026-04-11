import 'package:ditonton/features/tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_home_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_search_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/watchlist_tv_series_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TvSeriesHomePage()),
    GoRoute(
      path: '/tv-series/popular',
      builder: (context, state) => const PopularTvSeriesPage(),
    ),
    GoRoute(
      path: '/tv-series/top-rated',
      builder: (context, state) => const TopRatedTvSeriesPage(),
    ),
    GoRoute(
      path: '/tv-series/search',
      builder: (context, state) => const TvSeriesSearchPage(),
    ),
    GoRoute(
      path: '/tv-series/watchlist',
      builder: (context, state) => const WatchlistTvSeriesPage(),
    ),
    GoRoute(
      path: '/tv-series/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return TvSeriesDetailPage(id: id);
      },
    ),
  ],
);
