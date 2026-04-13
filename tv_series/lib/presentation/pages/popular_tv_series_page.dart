import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_state.dart';
import 'package:tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvSeriesPage extends StatefulWidget {
  const PopularTvSeriesPage({super.key});

  @override
  State<PopularTvSeriesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TvSeriesListBloc>().add(FetchPopularTvSeries()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeriesListBloc, TvSeriesListState>(
          builder: (context, state) {
            if (state.popularState == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.popularState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.popularTvSeries[index];
                  return TvSeriesCard(tvSeries: tvSeries);
                },
                itemCount: state.popularTvSeries.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(state.popularMessage),
              );
            }
          },
        ),
      ),
    );
  }
}
