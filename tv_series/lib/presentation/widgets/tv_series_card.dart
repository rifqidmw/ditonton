import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/constants/api_constants.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TVSeriesCard extends StatelessWidget {
  final TVSeries tvSeries;
  final VoidCallback? onTap;

  const TVSeriesCard({super.key, required this.tvSeries, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            context.push('/tv-series/${tvSeries.id}');
          },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tvSeries.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tvSeries.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, bottom: 16),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: tvSeries.posterPath != null
                    ? CachedNetworkImage(
                        imageUrl: ApiConstants.imageUrl(tvSeries.posterPath!),
                        width: 80,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Container(
                        width: 80,
                        height: 120,
                        color: Colors.grey,
                        child: const Icon(Icons.image_not_supported),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
