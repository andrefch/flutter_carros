import 'dart:async';

import 'package:flutter_carros/data/api/car_api.dart';
import 'package:flutter_carros/data/model/car.dart';

class CarBloc {

  StreamController<List<Car>> _streamController = StreamController<List<Car>>();

  Stream<List<Car>> get stream => _streamController.stream;

  void fetch(CarType type) async {
    final List<Car> cars = await CarApi.getCars(type);
    _streamController.add(cars);
  }

  void dispose() {
    _streamController.close();
  }
}