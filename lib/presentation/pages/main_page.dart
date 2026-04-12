import 'package:ditonton/features/movies/presentation/pages/movie_home_page.dart';
import 'package:ditonton/features/movies/presentation/pages/watchlist_movie_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_home_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [TvSeriesHomePage(), MovieHomePage(), _WatchlistPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'TV Series'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
        ],
      ),
    );
  }
}

class _WatchlistPage extends StatelessWidget {
  const _WatchlistPage();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'TV Series'),
              Tab(text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [WatchlistTvSeriesBodyContent(), WatchlistMoviePage()],
        ),
      ),
    );
  }
}
