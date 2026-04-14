import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_state.dart';
import 'package:tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTVSeriesPage extends StatefulWidget {
  const PopularTVSeriesPage({super.key});

  @override
  State<PopularTVSeriesPage> createState() => _PopularTVSeriesPageState();
}

class _PopularTVSeriesPageState extends State<PopularTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TVSeriesListBloc>().add(FetchPopularTVSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TVSeriesListBloc, TVSeriesListState>(
          builder: (context, state) {
            if (state.popularState == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.popularState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.popularTVSeries[index];
                  return TVSeriesCard(tvSeries: tvSeries);
                },
                itemCount: state.popularTVSeries.length,
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
