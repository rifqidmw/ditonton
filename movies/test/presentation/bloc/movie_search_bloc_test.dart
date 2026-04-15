import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/error/failures.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/search_movies.dart';
import 'package:movies/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:movies/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:movies/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:movies/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchMovies extends Mock implements SearchMovies {}

void main() {
  late MovieSearchBloc bloc;
  late MockSearchMovies mockSearchMovies;

  final tMovies = [
    Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
      genreIds: const [28],
    ),
  ];

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    bloc = MovieSearchBloc(searchMovies: mockSearchMovies);
  });

  tearDown(() => bloc.close());

  test('initial state should be MovieSearchState empty', () {
    expect(bloc.state, const MovieSearchState());
  });

  group('OnMovieQueryChanged', () {
    blocTest<MovieSearchBloc, MovieSearchState>(
      'should emit [loading, loaded] when query is non-empty and search succeeds',
      build: () {
        when(
          () => mockSearchMovies.execute('test'),
        ).thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (b) => b.add(const OnMovieQueryChanged('test')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const MovieSearchState(state: MovieRequestState.loading),
        MovieSearchState(
          state: MovieRequestState.loaded,
          searchResult: tMovies,
        ),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'should emit [loading, error] when search fails',
      build: () {
        when(
          () => mockSearchMovies.execute('test'),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (b) => b.add(const OnMovieQueryChanged('test')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const MovieSearchState(state: MovieRequestState.loading),
        const MovieSearchState(
          state: MovieRequestState.error,
          message: 'Server Error',
        ),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'should emit [empty] when query is empty',
      build: () => bloc,
      act: (b) => b.add(const OnMovieQueryChanged('')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const MovieSearchState(
          state: MovieRequestState.empty,
          searchResult: [],
        ),
      ],
    );
  });
}
