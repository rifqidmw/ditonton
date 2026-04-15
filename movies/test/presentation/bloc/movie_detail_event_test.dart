import 'package:flutter_test/flutter_test.dart';
import 'package:movies/domain/entities/movie_detail.dart';
import 'package:movies/presentation/bloc/movie_detail/movie_detail_event.dart';

void main() {
  const tMovieDetail = MovieDetail(
    id: 1,
    title: 'Test Movie',
    overview: 'Overview',
    voteAverage: 8.0,
    genres: [],
    runtime: 120,
    status: 'Released',
  );

  group('FetchMovieDetail', () {
    test('props should contain id', () {
      // ignore: prefer_const_constructors
      final event = FetchMovieDetail(1);
      expect(event.props, [1]);
    });

    test('should support value equality', () {
      // ignore: prefer_const_constructors
      expect(FetchMovieDetail(1), FetchMovieDetail(1));
    });
  });

  group('AddMovieToWatchlist', () {
    test('props should contain movieDetail', () {
      // ignore: prefer_const_constructors
      final event = AddMovieToWatchlist(tMovieDetail);
      expect(event.props, [tMovieDetail]);
    });

    test('should support value equality', () {
      // ignore: prefer_const_constructors
      expect(
        AddMovieToWatchlist(tMovieDetail),
        AddMovieToWatchlist(tMovieDetail),
      );
    });
  });

  group('RemoveMovieFromWatchlist', () {
    test('props should contain movieDetail', () {
      // ignore: prefer_const_constructors
      final event = RemoveMovieFromWatchlist(tMovieDetail);
      expect(event.props, [tMovieDetail]);
    });

    test('should support value equality', () {
      // ignore: prefer_const_constructors
      expect(
        // ignore: prefer_const_constructors
        RemoveMovieFromWatchlist(tMovieDetail),
        // ignore: prefer_const_constructors
        RemoveMovieFromWatchlist(tMovieDetail),
      );
    });
  });

  group('LoadMovieWatchlistStatus', () {
    test('props should contain id', () {
      // ignore: prefer_const_constructors
      final event = LoadMovieWatchlistStatus(1);
      expect(event.props, [1]);
    });

    test('should support value equality', () {
      // ignore: prefer_const_constructors
      expect(LoadMovieWatchlistStatus(1), LoadMovieWatchlistStatus(1));
    });
  });
}
