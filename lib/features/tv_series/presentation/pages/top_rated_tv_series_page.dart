import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_state.dart';
import 'package:ditonton/features/tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  const TopRatedTvSeriesPage({super.key});

  @override
  State<TopRatedTvSeriesPage> createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TvSeriesListBloc>().add(FetchTopRatedTvSeries()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeriesListBloc, TvSeriesListState>(
          builder: (context, state) {
            if (state.topRatedState == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.topRatedState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.topRatedTvSeries[index];
                  return TvSeriesCard(tvSeries: tvSeries);
                },
                itemCount: state.topRatedTvSeries.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(state.topRatedMessage),
              );
            }
          },
        ),
      ),
    );
  }
}
