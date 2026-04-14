import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:tv_series/presentation/widgets/detail_content.dart';

class TVSeriesDetailPage extends StatefulWidget {
  final int id;

  const TVSeriesDetailPage({super.key, required this.id});

  @override
  State<TVSeriesDetailPage> createState() => _TVSeriesDetailPageState();
}

class _TVSeriesDetailPageState extends State<TVSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TVSeriesDetailBloc>().add(FetchTVSeriesDetail(widget.id));
      context.read<TVSeriesDetailBloc>().add(LoadWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TVSeriesDetailBloc, TVSeriesDetailState>(
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
