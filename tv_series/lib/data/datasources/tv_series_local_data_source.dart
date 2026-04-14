import 'package:core/error/exceptions.dart' as core_exceptions;
import 'package:tv_series/data/models/tv_series_table.dart';
import 'package:sqflite/sqflite.dart';

abstract class TVSeriesLocalDataSource {
  Future<String> insertWatchlist(TVSeriesTable tvSeries);
  Future<String> removeWatchlist(TVSeriesTable tvSeries);
  Future<TVSeriesTable?> getTVSeriesById(int id);
  Future<List<TVSeriesTable>> getWatchlistTVSeries();
}

class TVSeriesLocalDataSourceImpl implements TVSeriesLocalDataSource {
  final Database database;

  TVSeriesLocalDataSourceImpl({required this.database});

  @override
  Future<String> insertWatchlist(TVSeriesTable tvSeries) async {
    try {
      await database.insert('watchlist_tv', tvSeries.toJson());
      return 'Added to Watchlist';
    } catch (e) {
      throw core_exceptions.DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TVSeriesTable tvSeries) async {
    try {
      await database.delete(
        'watchlist_tv',
        where: 'id = ?',
        whereArgs: [tvSeries.id],
      );
      return 'Removed from Watchlist';
    } catch (e) {
      throw core_exceptions.DatabaseException(e.toString());
    }
  }

  @override
  Future<TVSeriesTable?> getTVSeriesById(int id) async {
    final result = await database.query(
      'watchlist_tv',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return TVSeriesTable.fromMap(result.first);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVSeriesTable>> getWatchlistTVSeries() async {
    final result = await database.query('watchlist_tv');
    return result.map((data) => TVSeriesTable.fromMap(data)).toList();
  }
}
