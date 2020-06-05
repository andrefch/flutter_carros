import 'package:flutter_carros/data/local/database_helper.dart';
import 'package:flutter_carros/data/model/entity.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDao<T extends Entity> {
  String get tableName;

  T fromMap(Map<String, dynamic> map);

  Future<Database> get database => DatabaseHelper.getInstance().database;

  Future<List<int>> saveAll(List<T> cars) async {
    final List<int> ids = new List();
    for (T t in cars) {
      int id;
      try {
        id = await save(t);
      } on Exception catch (_) {
        id = -1;
      }
      ids.add(id);
    }
    return ids;
  }

  Future<int> save(T t) async {
    final Database db = await database;
    final id = await db.insert(
      tableName,
      t.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<T>> findAll() async {
    final Database db = await database;
    final json = await db.query(tableName);
    return json.map((data) => fromMap(data)).toList();
  }

  Future<T> findById(int id) async {
    final Database db = await database;
    final json = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return json.isNotEmpty ? fromMap(json.first) : null;
  }

  Future<bool> exists(int id) async => await findById(id) != null;

  Future<int> count() async {
    final Database db = await database;
    final count = await db.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(count);
  }

  Future<int> delete(int id) async {
    final Database db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    final Database db = await database;
    return await db.delete(
      tableName,
    );
  }
}
