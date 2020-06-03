import 'dart:convert' as convert;

import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/data/model/user.dart';
import 'package:http/http.dart' as http show get;

class CarApi {
  CarApi._();

  static Future<List<Car>> getCars(CarType type) async {
    final url =
        "https://carros-springboot.herokuapp.com/api/v2/carros/tipo/${_getCarTypePath(type)}";

    final user = await User.load();

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}",
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    final String json = response.body;
    final int statusCode = response.statusCode;

    if (statusCode != 200) {
      throw Exception("Failed to load cars. ($statusCode)");
    }

    final List data = convert.json.decode(json);
    final List<Car> cars = data.map((jsonItem) => Car.fromMap(jsonItem)).toList();

    return cars;
  }

  static String _getCarTypePath(CarType type) {
    switch (type) {
      case CarType.classic:
        return "classicos";
      case CarType.sport:
        return "esportivos";
      case CarType.lux:
        return "luxo";
      default:
        throw Exception("Unexpected car type received: $type");
    }
  }
}

enum CarType { classic, sport, lux }
