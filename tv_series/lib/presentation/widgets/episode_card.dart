import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';

class EpisodeCard extends StatelessWidget {
  final Episode episode;

  const EpisodeCard({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThumbnail(),
          const SizedBox(width: 12),
          Expanded(child: _buildInfo()),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: episode.stillPath != null
          ? CachedNetworkImage(
              imageUrl: ApiConstants.imageUrl(episode.stillPath!),
              width: 120,
              height: 70,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => _imagePlaceholder(),
            )
          : _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 120,
      height: 70,
      color: Colors.grey,
      child: const Icon(Icons.image_not_supported),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ep ${episode.episodeNumber}: ${episode.name}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.black,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (episode.airDate != null && episode.airDate!.isNotEmpty)
          Text(
            episode.airDate!,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        if (episode.overview.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              episode.overview,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (episode.voteAverage > 0) _buildRating(),
      ],
    );
  }

  Widget _buildRating() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(Icons.star, size: 14, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            episode.voteAverage.toStringAsFixed(1),
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
