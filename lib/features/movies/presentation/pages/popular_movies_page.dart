import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:ditonton/features/movies/presentation/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<MovieListBloc>().add(FetchPopularMovies()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieListBloc, MovieListState>(
          builder: (context, state) {
            if (state.popularState == MovieRequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.popularState == MovieRequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.popularMovies[index];
                  return MovieCard(movie: movie);
                },
                itemCount: state.popularMovies.length,
              );
            } else if (state.popularState == MovieRequestState.error) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.popularMessage),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
