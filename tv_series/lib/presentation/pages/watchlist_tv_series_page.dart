import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_event.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_state.dart';
import 'package:tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WatchlistTVSeriesPage extends StatelessWidget {
  const WatchlistTVSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: WatchlistTVSeriesBodyContent(),
      ),
    );
  }
}

class WatchlistTVSeriesBodyContent extends StatefulWidget {
  const WatchlistTVSeriesBodyContent({super.key});

  @override
  State<WatchlistTVSeriesBodyContent> createState() =>
      _WatchlistTVSeriesBodyContentState();
}

class _WatchlistTVSeriesBodyContentState
    extends State<WatchlistTVSeriesBodyContent> {
  @override
  void initState() {
    super.initState();
    _fetchWatchlist();
  }

  void _fetchWatchlist() {
    context.read<WatchlistTVSeriesBloc>().add(FetchWatchlistTVSeries());
  }

  Future<void> _onRefresh() async {
    _fetchWatchlist();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistTVSeriesBloc, WatchlistTVSeriesState>(
      builder: (context, state) {
        if (state.state == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == RequestState.loaded) {
          if (state.watchlistTVSeries.isEmpty) {
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
                final tvSeries = state.watchlistTVSeries[index];
                return TVSeriesCard(
                  tvSeries: tvSeries,
                  onTap: () async {
                    await context.push('/tv-series/${tvSeries.id}');
                    if (mounted) {
                      _fetchWatchlist();
                    }
                  },
                );
              },
              itemCount: state.watchlistTVSeries.length,
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
