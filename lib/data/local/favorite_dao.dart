import 'package:flutter_carros/data/local/base_dao.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/data/model/favorite.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteDao extends BaseDao<Favorite> {
  @override
  Favorite fromMap(Map<String, dynamic> data) => Favorite.fromMap(data);

  @override
  String get tableName => 'favorito';
  
  Future<List<Car>> findCars() async {
    final Database db = await database;
    final data = await db.rawQuery('SELECT carro.* FROM favorito INNER JOIN carro ON favorito.id = carro.id');
    return data.map((info) => Car.fromMap(info)).toList();
  }
}
