import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter_carros/data/api/api_result.dart';
import 'package:flutter_carros/data/api/upload_api.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/util/http_helper.dart' as http;

class CarApi {
  CarApi._();

  static Future<List<Car>> getCars(CarType type) async {
    final url =
        'https://carros-springboot.herokuapp.com/api/v1/carros/tipo/${_getCarTypePath(type)}';

    final response = await http.get(url);

    final String json = response.body;
    final int statusCode = response.statusCode;

    if (statusCode != 200) {
      throw Exception('Failed to load cars. ($statusCode)');
    }

    final List data = convert.json.decode(json);
    final List<Car> cars =
        data.map((jsonItem) => Car.fromMap(jsonItem)).toList();

    return cars;
  }

  static String _getCarTypePath(CarType type) {
    switch (type) {
      case CarType.classic:
        return 'classicos';
      case CarType.sport:
        return 'esportivos';
      case CarType.lux:
        return 'luxo';
      default:
        throw Exception('Unexpected car type received: $type');
    }
  }

  static Future<ApiResult<bool>> save(Car car, [File image]) async {
    try {
      final String pathCarId = car.id != null ? '/${car.id}' : '';
      final url =
          'https://carros-springboot.herokuapp.com/api/v1/carros$pathCarId';

      if (image != null) {
        final imageResponse = await UploadService.upload(image);
        if (imageResponse.data.isNotEmpty) {
          car.urlImage = imageResponse.data;
        }
      }

      final json = car.toJson();

      final response = car.id == null
          ? await http.post(
              url,
              body: json,
            )
          : await http.put(
              url,
              body: json,
            );

      final Map bodyResponse = convert.json.decode(response.body);
      if (bodyResponse == null || bodyResponse.isEmpty) {
        return ApiResult.failure(
            'O servidor não conseguiu retornar se o veículo foi salvo com sucesso.');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Car newCar = Car.fromMap(bodyResponse);
        print('Success! ID car: ${newCar.id}');
        return ApiResult.success(true);
      } else {
        return ApiResult.failure(bodyResponse['error']);
      }
    } on Exception catch (e) {
      print(e);
      return ApiResult.failure('Não foi possível salvar o carro.');
    }
  }

  static Future<ApiResult<bool>> delete(Car car) async {
    try {
      if (car == null || (car.id == null)) {
        throw Exception('O veículo não pode ser nulo e deve possuir ID.');
      }

      final url =
          'https://carros-springboot.herokuapp.com/api/v1/carros/${car.id}';

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return ApiResult.success(true);
      } else {
        String message = 'Não foi possível excluir o veículo.';
        if (response.body != null && response.body.isNotEmpty) {
          final json = convert.json.decode(response.body);
          final String error = json['error'];
          if (error.trim().isNotEmpty) {
            message = error;
          }
        }
        return ApiResult.failure(message);
      }
    } on Exception catch (e) {
      print(e);
      return ApiResult.failure('Não foi possível excluir o veículo.');
    }
  }
}

enum CarType { classic, sport, lux }

CarType getCarTypeByValue(String value) {
  if (value == 'classicos') {
    return CarType.classic;
  } else if (value == 'esportivos') {
    return CarType.sport;
  } else if (value == 'luxo') {
    return CarType.lux;
  } else {
    throw Exception(
        'Illegal argument exception! CarType $value does not exists.');
  }
}
