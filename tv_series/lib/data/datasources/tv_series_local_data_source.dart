import 'package:core/error/exceptions.dart' as core_exceptions;
import 'package:tv_series/data/models/tv_series_table.dart';
import 'package:sqflite/sqflite.dart';

abstract class TvSeriesLocalDataSource {
  Future<String> insertWatchlist(TvSeriesTable tvSeries);
  Future<String> removeWatchlist(TvSeriesTable tvSeries);
  Future<TvSeriesTable?> getTvSeriesById(int id);
  Future<List<TvSeriesTable>> getWatchlistTvSeries();
}

class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {
  final Database database;

  TvSeriesLocalDataSourceImpl({required this.database});

  @override
  Future<String> insertWatchlist(TvSeriesTable tvSeries) async {
    try {
      await database.insert('watchlist_tv', tvSeries.toJson());
      return 'Added to Watchlist';
    } catch (e) {
      throw core_exceptions.DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvSeriesTable tvSeries) async {
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
  Future<TvSeriesTable?> getTvSeriesById(int id) async {
    final result = await database.query(
      'watchlist_tv',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return TvSeriesTable.fromMap(result.first);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvSeriesTable>> getWatchlistTvSeries() async {
    final result = await database.query('watchlist_tv');
    return result.map((data) => TvSeriesTable.fromMap(data)).toList();
  }
}
