import 'package:flutter_carros/data/api/car_api.dart';
import 'package:flutter_carros/data/local/base_dao.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:sqflite/sqflite.dart';

class CarDao extends BaseDao<Car> {
  @override
  String get tableName => "carro";

  @override
  Car fromMap(Map<String, dynamic> map) => Car.fromMap(map);

  Future<List<Car>> findByType(CarType type) async {
    final Database db = await database;
    String valueType;
    switch (type) {
      case CarType.classic:
        valueType = "classicos";
        break;
      case CarType.sport:
        valueType = "esportivos";
        break;
      case CarType.lux:
        valueType = "luxo";
        break;
      default:
        throw Exception("Unexpected car type received: $type");
    }

    final json = await db.query(
      tableName,
      where: 'tipo = ?',
      whereArgs: [valueType],
    );

    return json.map((data) => fromMap(data)).toList();
  }
}
