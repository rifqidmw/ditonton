import 'package:movies/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:movies/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:movies/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:movies/presentation/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieSearchPage extends StatelessWidget {
  const MovieSearchPage({super.key});

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
                context.read<MovieSearchBloc>().add(OnMovieQueryChanged(query));
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
            BlocBuilder<MovieSearchBloc, MovieSearchState>(
              builder: (context, state) {
                if (state.state == MovieRequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.state == MovieRequestState.loaded) {
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
                        final movie = result[index];
                        return MovieCard(movie: movie);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state.state == MovieRequestState.error) {
                  return Expanded(
                    child: Center(
                      key: const Key('error_message'),
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(child: Text('Search for Movies')),
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
