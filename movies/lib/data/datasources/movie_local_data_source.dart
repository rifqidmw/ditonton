import 'package:core/error/exceptions.dart' as core_exceptions;
import 'package:movies/data/models/movie_table.dart';
import 'package:sqflite/sqflite.dart';

abstract class MovieLocalDataSource {
  Future<String> insertWatchlist(MovieTable movie);
  Future<String> removeWatchlist(MovieTable movie);
  Future<MovieTable?> getMovieById(int id);
  Future<List<MovieTable>> getWatchlistMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Database database;

  MovieLocalDataSourceImpl({required this.database});

  @override
  Future<String> insertWatchlist(MovieTable movie) async {
    try {
      await database.insert('watchlist_movies', movie.toJson());
      return 'Added to Watchlist';
    } catch (e) {
      throw core_exceptions.DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(MovieTable movie) async {
    try {
      await database.delete(
        'watchlist_movies',
        where: 'id = ?',
        whereArgs: [movie.id],
      );
      return 'Removed from Watchlist';
    } catch (e) {
      throw core_exceptions.DatabaseException(e.toString());
    }
  }

  @override
  Future<MovieTable?> getMovieById(int id) async {
    final result = await database.query(
      'watchlist_movies',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return MovieTable.fromMap(result.first);
    } else {
      return null;
    }
  }

  @override
  Future<List<MovieTable>> getWatchlistMovies() async {
    final result = await database.query('watchlist_movies');
    return result.map((data) => MovieTable.fromMap(data)).toList();
  }
}
