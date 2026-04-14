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
      const event = FetchMovieDetail(1);
      expect(event.props, [1]);
    });

    test('should support value equality', () {
      expect(const FetchMovieDetail(1), const FetchMovieDetail(1));
    });
  });

  group('AddMovieToWatchlist', () {
    test('props should contain movieDetail', () {
      const event = AddMovieToWatchlist(tMovieDetail);
      expect(event.props, [tMovieDetail]);
    });

    test('should support value equality', () {
      expect(
        const AddMovieToWatchlist(tMovieDetail),
        const AddMovieToWatchlist(tMovieDetail),
      );
    });
  });

  group('RemoveMovieFromWatchlist', () {
    test('props should contain movieDetail', () {
      const event = RemoveMovieFromWatchlist(tMovieDetail);
      expect(event.props, [tMovieDetail]);
    });

    test('should support value equality', () {
      expect(
        const RemoveMovieFromWatchlist(tMovieDetail),
        const RemoveMovieFromWatchlist(tMovieDetail),
      );
    });
  });

  group('LoadMovieWatchlistStatus', () {
    test('props should contain id', () {
      const event = LoadMovieWatchlistStatus(1);
      expect(event.props, [1]);
    });

    test('should support value equality', () {
      expect(
        const LoadMovieWatchlistStatus(1),
        const LoadMovieWatchlistStatus(1),
      );
    });
  });
}
