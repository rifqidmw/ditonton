import 'package:tv_series/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_search/tv_series_search_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_search/tv_series_search_state.dart';
import 'package:tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVSeriesSearchPage extends StatelessWidget {
  const TVSeriesSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<TVSeriesSearchBloc>().add(OnQueryChanged(query));
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            BlocBuilder<TVSeriesSearchBloc, TVSeriesSearchState>(
              builder: (context, state) {
                if (state.state == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.state == RequestState.loaded) {
                  final result = state.searchResult;
                  if (result.isEmpty) {
                    return const Expanded(
                      child: Center(child: Text('No results found')),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tvSeries = result[index];
                        return TVSeriesCard(tvSeries: tvSeries);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state.state == RequestState.error) {
                  return Expanded(
                    child: Center(
                      key: const Key('error_message'),
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(child: Text('Search for TV Series')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
