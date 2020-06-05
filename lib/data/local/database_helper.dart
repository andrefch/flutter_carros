import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.getInstance();
  static Database _database;

  DatabaseHelper.getInstance();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDatabase();
    }
    return _database;
  }

  void close() async {
    final Database db = await this.database;
    return db.close();
  }

  Future<Database> _initializeDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, 'carros.db');

    print('Database path: $path');

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return database;
  }

  void _onCreate(Database db, int version) async {
    final data = await rootBundle.loadString('assets/sql/create.sql');
    final sqls = data.split(';');

    for (String sql in sqls) {
      if (sql.trim().isNotEmpty) {
        await db.execute(sql);
      }
    }
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");

    if(oldVersion == 1 && newVersion == 2) {
      await db.execute("alter table carro add column NOVA TEXT");
    }
  }
}
