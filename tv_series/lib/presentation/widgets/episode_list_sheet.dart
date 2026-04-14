import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:tv_series/presentation/widgets/episode_card.dart';

class EpisodeListSheet extends StatelessWidget {
  final String seasonName;
  final ScrollController scrollController;

  const EpisodeListSheet({
    super.key,
    required this.seasonName,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TVSeriesDetailBloc, TVSeriesDetailState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildHandle(),
            _buildTitle(context),
            const Divider(height: 1),
            Expanded(child: _buildBody(state)),
          ],
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        seasonName,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBody(TVSeriesDetailState state) {
    if (state.seasonDetailState == RequestState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.seasonDetailState == RequestState.error) {
      return Center(child: Text(state.seasonDetailMessage));
    }
    if (state.seasonDetailState == RequestState.loaded &&
        state.selectedSeasonDetail != null) {
      final episodes = state.selectedSeasonDetail!.episodes;
      if (episodes.isEmpty) {
        return const Center(child: Text('No episodes available.'));
      }
      return ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: episodes.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, index) => EpisodeCard(episode: episodes[index]),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }
}
