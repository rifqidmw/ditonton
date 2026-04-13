import 'package:movies/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movies/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:movies/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:movies/domain/entities/movie_detail.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:core/constants/api_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;

  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id));
      context.read<MovieDetailBloc>().add(LoadMovieWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MovieDetailBloc, MovieDetailState>(
        listenWhen: (previous, current) =>
            previous.watchlistMessage != current.watchlistMessage &&
            current.watchlistMessage.isNotEmpty,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.watchlistMessage),
              duration: const Duration(milliseconds: 500),
            ),
          );
        },
        builder: (context, state) {
          if (state.detailState == MovieRequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.detailState == MovieRequestState.loaded) {
            final movie = state.movieDetail!;
            return SafeArea(
              child: MovieDetailContent(
                movie,
                state.recommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state.detailState == MovieRequestState.error) {
            return Center(child: Text(state.detailMessage));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class MovieDetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const MovieDetailContent(
    this.movie,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        movie.posterPath != null
            ? CachedNetworkImage(
                imageUrl: ApiConstants.imageUrl(movie.posterPath!),
                width: screenWidth,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : Container(width: screenWidth, height: 250, color: Colors.grey),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(color: Colors.black),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context.read<MovieDetailBloc>().add(
                                    AddMovieToWatchlist(movie),
                                  );
                                } else {
                                  context.read<MovieDetailBloc>().add(
                                    RemoveMovieFromWatchlist(movie),
                                  );
                                }

                                await Future.delayed(
                                  const Duration(milliseconds: 100),
                                );
                                if (context.mounted) {
                                  context.read<MovieDetailBloc>().add(
                                    LoadMovieWatchlistStatus(movie.id),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(movie.genres),
                              style: const TextStyle(color: Colors.black87),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                Text(
                                  movie.voteAverage.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(width: 8),
                                if (movie.runtime > 0)
                                  Text(
                                    _formatRuntime(movie.runtime),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.black),
                            ),
                            Text(
                              movie.overview,
                              style: const TextStyle(color: Colors.black87),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.black),
                            ),
                            BlocBuilder<MovieDetailBloc, MovieDetailState>(
                              builder: (context, state) {
                                if (state.recommendationState ==
                                    MovieRequestState.loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state.recommendationState ==
                                    MovieRequestState.error) {
                                  return Text(
                                    state.recommendationMessage,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  );
                                } else if (state.recommendationState ==
                                    MovieRequestState.loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final rec = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              context.push('/movies/${rec.id}');
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: rec.posterPath != null
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          ApiConstants.imageUrl(
                                                            rec.posterPath!,
                                                          ),
                                                      width: 100,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      width: 100,
                                                      color: Colors.grey,
                                                      child: const Icon(
                                                        Icons.movie,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<MovieGenre> genres) {
    return genres.map((g) => g.name).join(', ');
  }

  String _formatRuntime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }
}
