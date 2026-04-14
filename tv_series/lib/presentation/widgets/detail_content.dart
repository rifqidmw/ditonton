import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:tv_series/presentation/widgets/episode_list_sheet.dart';

class DetailContent extends StatelessWidget {
  final TVSeriesDetail tvSeries;
  final List<TVSeries> recommendations;
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
        _buildPoster(screenWidth),
        _buildScrollableContent(context),
        _buildBackButton(context),
      ],
    );
  }

  Widget _buildPoster(double screenWidth) {
    if (tvSeries.posterPath != null) {
      return CachedNetworkImage(
        imageUrl: ApiConstants.imageUrl(tvSeries.posterPath!),
        width: screenWidth,
        placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
        errorWidget: (_, _, _) => const Icon(Icons.error),
      );
    }
    return Container(width: screenWidth, height: 250, color: Colors.grey);
  }

  Widget _buildScrollableContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 48 + 8),
      child: DraggableScrollableSheet(
        minChildSize: 0.25,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Stack(
              children: [
                _buildSheetBody(context, scrollController),
                _buildDragHandle(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragHandle() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(color: Colors.white, height: 4, width: 48),
    );
  }

  Widget _buildSheetBody(
    BuildContext context,
    ScrollController scrollController,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tvSeries.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.black),
            ),
            _buildWatchlistButton(context),
            Text(
              _showGenres(tvSeries.genres),
              style: const TextStyle(color: Colors.black87),
            ),
            _buildRatingRow(),
            const SizedBox(height: 16),
            Text(
              'Overview',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.black),
            ),
            Text(
              tvSeries.overview,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              'Seasons & Episodes',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.black),
            ),
            Text(
              '${tvSeries.numberOfSeasons} Seasons, '
              '${tvSeries.numberOfEpisodes} Episodes',
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            _buildSeasonsSection(context),
            const SizedBox(height: 16),
            Text(
              'Recommendations',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.black),
            ),
            _buildRecommendationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchlistButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!isAddedWatchlist) {
          context.read<TVSeriesDetailBloc>().add(AddToWatchlist(tvSeries));
        } else {
          context.read<TVSeriesDetailBloc>().add(RemoveFromWatchlist(tvSeries));
        }
        await Future.delayed(const Duration(milliseconds: 100));
        if (context.mounted) {
          context.read<TVSeriesDetailBloc>().add(
            LoadWatchlistStatus(tvSeries.id),
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isAddedWatchlist ? const Icon(Icons.check) : const Icon(Icons.add),
          const Text('Watchlist'),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber),
        Text(
          tvSeries.voteAverage.toStringAsFixed(1),
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildSeasonsSection(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvSeries.seasons.length,
        itemBuilder: (context, index) {
          final season = tvSeries.seasons[index];
          return GestureDetector(
            onTap: () => _onSeasonTap(context, season),
            child: _buildSeasonCard(season),
          );
        },
      ),
    );
  }

  void _onSeasonTap(BuildContext context, Season season) {
    context.read<TVSeriesDetailBloc>().add(
      FetchSeasonDetail(tvSeries.id, season.seasonNumber),
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<TVSeriesDetailBloc>(),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.92,
          builder: (_, scrollController) => EpisodeListSheet(
            seasonName: season.name,
            scrollController: scrollController,
          ),
        ),
      ),
    );
  }

  Widget _buildSeasonCard(Season season) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: season.posterPath != null
                ? CachedNetworkImage(
                    imageUrl: ApiConstants.imageUrl(season.posterPath!),
                    height: 100,
                    width: 70,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 100,
                    width: 70,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported),
                  ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: SizedBox(
              width: 70,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return BlocBuilder<TVSeriesDetailBloc, TVSeriesDetailState>(
      builder: (context, state) {
        if (state.recommendationState == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.recommendationState == RequestState.error) {
          return Text(
            state.recommendationMessage,
            style: const TextStyle(color: Colors.black87),
          );
        }
        if (state.recommendationState == RequestState.loaded) {
          return _buildRecommendationsList(context);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildRecommendationsList(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final item = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () => context.push('/tv-series/${item.id}'),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: item.posterPath != null
                    ? CachedNetworkImage(
                        imageUrl: ApiConstants.imageUrl(item.posterPath!),
                      )
                    : Container(
                        width: 100,
                        color: Colors.grey,
                        child: const Icon(Icons.image_not_supported),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    if (genres.isEmpty) return '';
    return genres.map((g) => g.name).join(', ');
  }
}
