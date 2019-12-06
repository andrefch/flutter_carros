import 'dart:convert' as convert;

import 'package:flutter_carros/data/model/car.dart';
import 'package:http/http.dart' as http show get;

class CarApi {
  CarApi._();

  static Future<List<Car>> getCars(CarType type) async {
    final url = "https://carros-springboot.herokuapp.com/api/v1/carros/tipo/${_getCarTypePath(type)}";
    final response = await http.get(url);
    final String json = response.body;
    final List data = convert.json.decode(json);

    return data.map((jsonItem) => Car.fromJson(jsonItem)).toList();
  }

  static String _getCarTypePath(CarType type) {
    switch (type) {
      case CarType.classic:
        return "classicos";
      case CarType.sport:
        return "esportivos";
      case CarType.lux:
        return "luxo";
    }
  }
}

enum CarType {
  classic,
  sport,
  lux
}
