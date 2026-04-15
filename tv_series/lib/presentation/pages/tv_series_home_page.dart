import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_state.dart';

class TVSeriesHomePage extends StatefulWidget {
  const TVSeriesHomePage({super.key});

  @override
  State<TVSeriesHomePage> createState() => _TVSeriesHomePageState();
}

class _TVSeriesHomePageState extends State<TVSeriesHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TVSeriesListBloc>().add(FetchPopularTVSeries());
      context.read<TVSeriesListBloc>().add(FetchTopRatedTVSeries());
      context.read<TVSeriesListBloc>().add(FetchOnTheAirTVSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/tv-series/search');
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
              BlocBuilder<TVSeriesListBloc, TVSeriesListState>(
                builder: (context, state) {
                  if (state.onTheAirState == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.onTheAirState == RequestState.loaded) {
                    return TVSeriesList(state.onTheAirTVSeries);
                  } else if (state.onTheAirState == RequestState.error) {
                    return Center(child: Text(state.onTheAirMessage));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => context.push('/tv-series/popular'),
              ),
              BlocBuilder<TVSeriesListBloc, TVSeriesListState>(
                builder: (context, state) {
                  if (state.popularState == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.popularState == RequestState.loaded) {
                    return TVSeriesList(state.popularTVSeries);
                  } else if (state.popularState == RequestState.error) {
                    return Center(child: Text(state.popularMessage));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => context.push('/tv-series/top-rated'),
              ),
              BlocBuilder<TVSeriesListBloc, TVSeriesListState>(
                builder: (context, state) {
                  if (state.topRatedState == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.topRatedState == RequestState.loaded) {
                    return TVSeriesList(state.topRatedTVSeries);
                  } else if (state.topRatedState == RequestState.error) {
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

  Row _buildSubHeading({required String title, required Function() onTap}) {
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

class TVSeriesList extends StatelessWidget {
  final List<TVSeries> tvSeriesList;

  const TVSeriesList(this.tvSeriesList, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvSeries = tvSeriesList[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                context.push('/tv-series/${tvSeries.id}');
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: tvSeries.posterPath != null
                    ? CachedNetworkImage(
                        imageUrl: ApiConstants.imageUrl(tvSeries.posterPath!),
                        placeholder: (_, _) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (_, _, _) => const Icon(Icons.error),
                      )
                    : Container(
                        width: 120,
                        color: Colors.grey,
                        child: const Icon(Icons.image_not_supported),
                      ),
              ),
            ),
          );
        },
        itemCount: tvSeriesList.length,
      ),
    );
  }
}
