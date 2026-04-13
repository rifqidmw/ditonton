import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/constants/api_constants.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<MovieListBloc>().add(FetchNowPlayingMovies());
      context.read<MovieListBloc>().add(FetchPopularMovies());
      context.read<MovieListBloc>().add(FetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/movies/search');
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (context, state) {
                  if (state.nowPlayingState == MovieRequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.nowPlayingState ==
                      MovieRequestState.loaded) {
                    return _MovieList(state.nowPlayingMovies);
                  } else if (state.nowPlayingState == MovieRequestState.error) {
                    return Center(child: Text(state.nowPlayingMessage));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => context.push('/movies/popular'),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (context, state) {
                  if (state.popularState == MovieRequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.popularState == MovieRequestState.loaded) {
                    return _MovieList(state.popularMovies);
                  } else if (state.popularState == MovieRequestState.error) {
                    return Center(child: Text(state.popularMessage));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => context.push('/movies/top-rated'),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (context, state) {
                  if (state.topRatedState == MovieRequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.topRatedState == MovieRequestState.loaded) {
                    return _MovieList(state.topRatedMovies);
                  } else if (state.topRatedState == MovieRequestState.error) {
                    return Center(child: Text(state.topRatedMessage));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class _MovieList extends StatelessWidget {
  final List<Movie> movies;

  const _MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                context.push('/movies/${movie.id}');
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: movie.posterPath != null
                    ? CachedNetworkImage(
                        imageUrl: ApiConstants.imageUrl(movie.posterPath!),
                        placeholder: (context, url) => const SizedBox(
                          width: 120,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Container(
                        width: 120,
                        color: Colors.grey,
                        child: const Icon(Icons.movie),
                      ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
