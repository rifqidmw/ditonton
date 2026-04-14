import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_state.dart';
import 'package:tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTVSeriesPage extends StatefulWidget {
  const TopRatedTVSeriesPage({super.key});

  @override
  State<TopRatedTVSeriesPage> createState() => _TopRatedTVSeriesPageState();
}

class _TopRatedTVSeriesPageState extends State<TopRatedTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TVSeriesListBloc>().add(FetchTopRatedTVSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TVSeriesListBloc, TVSeriesListState>(
          builder: (context, state) {
            if (state.topRatedState == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.topRatedState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.topRatedTVSeries[index];
                  return TVSeriesCard(tvSeries: tvSeries);
                },
                itemCount: state.topRatedTVSeries.length,
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
