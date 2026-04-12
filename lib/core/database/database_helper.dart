import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  static const String _tblWatchlistTv = 'watchlist_tv';
  static const String _tblWatchlistMovies = 'watchlist_movies';

  Future<Database> _initDb() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'ditonton.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tblWatchlistTv (
        id INTEGER PRIMARY KEY,
        name TEXT,
        posterPath TEXT,
        overview TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE $_tblWatchlistMovies (
        id INTEGER PRIMARY KEY,
        title TEXT,
        posterPath TEXT,
        overview TEXT
      );
    ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $_tblWatchlistMovies (
          id INTEGER PRIMARY KEY,
          title TEXT,
          posterPath TEXT,
          overview TEXT
        );
      ''');
    }
  }
}
