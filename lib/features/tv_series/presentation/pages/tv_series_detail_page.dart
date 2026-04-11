import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:ditonton/core/constants/api_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TvSeriesDetailPage extends StatefulWidget {
  final int id;

  const TvSeriesDetailPage({super.key, required this.id});

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesDetailBloc>().add(FetchTvSeriesDetail(widget.id));
      context.read<TvSeriesDetailBloc>().add(LoadWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TvSeriesDetailBloc, TvSeriesDetailState>(
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
          if (state.detailState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.detailState == RequestState.loaded) {
            final tvSeries = state.tvSeriesDetail!;
            return SafeArea(
              child: DetailContent(
                tvSeries,
                state.recommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state.detailState == RequestState.error) {
            return Center(child: Text(state.detailMessage));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(
    this.tvSeries,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        tvSeries.posterPath != null
            ? CachedNetworkImage(
                imageUrl: ApiConstants.imageUrl(tvSeries.posterPath!),
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
                              tvSeries.name,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(color: Colors.black),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context.read<TvSeriesDetailBloc>().add(
                                    AddToWatchlist(tvSeries),
                                  );
                                } else {
                                  context.read<TvSeriesDetailBloc>().add(
                                    RemoveFromWatchlist(tvSeries),
                                  );
                                }

                                // Reload watchlist status
                                await Future.delayed(
                                  const Duration(milliseconds: 100),
                                );
                                if (context.mounted) {
                                  context.read<TvSeriesDetailBloc>().add(
                                    LoadWatchlistStatus(tvSeries.id),
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
                              _showGenres(tvSeries.genres),
                              style: const TextStyle(color: Colors.black87),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                Text(
                                  tvSeries.voteAverage.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.black),
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
                              tvSeries.overview,
                              style: const TextStyle(color: Colors.black87),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seasons & Episodes',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.black),
                            ),
                            Text(
                              '${tvSeries.numberOfSeasons} Seasons, ${tvSeries.numberOfEpisodes} Episodes',
                              style: const TextStyle(color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: tvSeries.seasons.length,
                                itemBuilder: (context, index) {
                                  final season = tvSeries.seasons[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: season.posterPath != null
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      ApiConstants.imageUrl(
                                                        season.posterPath!,
                                                      ),
                                                  height: 100,
                                                  width: 70,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  height: 100,
                                                  width: 70,
                                                  color: Colors.grey,
                                                  child: const Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                                ),
                                        ),
                                        const SizedBox(height: 4),
                                        SizedBox(
                                          width: 70,
                                          child: Column(
                                            children: [
                                              Text(
                                                season.name,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '${season.episodeCount} Episodes',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black54,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.black),
                            ),
                            BlocBuilder<
                              TvSeriesDetailBloc,
                              TvSeriesDetailState
                            >(
                              builder: (context, state) {
                                if (state.recommendationState ==
                                    RequestState.loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state.recommendationState ==
                                    RequestState.error) {
                                  return Text(
                                    state.recommendationMessage,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  );
                                } else if (state.recommendationState ==
                                    RequestState.loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tvSeries = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              context.push(
                                                '/tv-series/${tvSeries.id}',
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                              child: tvSeries.posterPath != null
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          ApiConstants.imageUrl(
                                                            tvSeries
                                                                .posterPath!,
                                                          ),
                                                    )
                                                  : Container(
                                                      width: 100,
                                                      color: Colors.grey,
                                                      child: const Icon(
                                                        Icons
                                                            .image_not_supported,
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
                                  return Container();
                                }
                              },
                            ),
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
            minChildSize: 0.25,
            maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.pop();
              },
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
