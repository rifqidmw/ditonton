import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';
import 'package:movies/presentation/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WatchlistMoviePage extends StatefulWidget {
  const WatchlistMoviePage({super.key});

  @override
  State<WatchlistMoviePage> createState() => _WatchlistMoviePageState();
}

class _WatchlistMoviePageState extends State<WatchlistMoviePage> {
  @override
  void initState() {
    super.initState();
    _fetchWatchlist();
  }

  void _fetchWatchlist() {
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
  }

  Future<void> _onRefresh() async {
    _fetchWatchlist();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
      builder: (context, state) {
        if (state.state == MovieRequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == MovieRequestState.loaded) {
          if (state.watchlistMovies.isEmpty) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                children: const [
                  SizedBox(
                    height: 400,
                    child: Center(child: Text('No watchlist yet')),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.watchlistMovies[index];
                return MovieCard(
                  movie: movie,
                  onTap: () async {
                    await context.push('/movies/${movie.id}');
                    if (mounted) {
                      _fetchWatchlist();
                    }
                  },
                );
              },
              itemCount: state.watchlistMovies.length,
            ),
          );
        } else if (state.state == MovieRequestState.error) {
          return Center(
            key: const Key('error_message'),
            child: Text(state.message),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
