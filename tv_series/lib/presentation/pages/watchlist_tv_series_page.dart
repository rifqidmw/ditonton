import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_event.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_state.dart';
import 'package:tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WatchlistTvSeriesPage extends StatelessWidget {
  const WatchlistTvSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: WatchlistTvSeriesBodyContent(),
      ),
    );
  }
}

class WatchlistTvSeriesBodyContent extends StatefulWidget {
  const WatchlistTvSeriesBodyContent({super.key});

  @override
  State<WatchlistTvSeriesBodyContent> createState() =>
      _WatchlistTvSeriesBodyContentState();
}

class _WatchlistTvSeriesBodyContentState
    extends State<WatchlistTvSeriesBodyContent> {
  @override
  void initState() {
    super.initState();
    _fetchWatchlist();
  }

  void _fetchWatchlist() {
    context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeries());
  }

  Future<void> _onRefresh() async {
    _fetchWatchlist();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      builder: (context, state) {
        if (state.state == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == RequestState.loaded) {
          if (state.watchlistTvSeries.isEmpty) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                children: const [
                  SizedBox(
                    height: 400,
                    child: Center(child: Text('No watchlist yet')),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemBuilder: (context, index) {
                final tvSeries = state.watchlistTvSeries[index];
                return TvSeriesCard(
                  tvSeries: tvSeries,
                  onTap: () async {
                    await context.push('/tv-series/${tvSeries.id}');
                    if (mounted) {
                      _fetchWatchlist();
                    }
                  },
                );
              },
              itemCount: state.watchlistTvSeries.length,
            ),
          );
        } else if (state.state == RequestState.error) {
          return Center(
            key: const Key('error_message'),
            child: Text(state.message),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
