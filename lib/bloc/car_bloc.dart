import 'dart:async';

import 'package:flutter_carros/data/api/car_api.dart';
import 'package:flutter_carros/data/local/car_dao.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/util/network.dart';

class CarBloc {

  StreamController<List<Car>> _streamController = StreamController<List<Car>>();

  Stream<List<Car>> get stream => _streamController.stream;

  final CarDao _dao = CarDao();

  Future<List<Car>> fetch(CarType type) async {
    try {
      List<Car> cars;
      if (await isConnected()) {
        cars = await CarApi.getCars(type);
        _dao.saveAll(cars);
      } else {
        cars = await _dao.findByType(type);
      }
      _streamController.add(cars);
      return Future.value(cars);
    } catch (error, stackTrace) {
      if (!_streamController.isClosed) {
        _streamController.addError(error, stackTrace);
      }
      return Future.value(null);
    }
  }

  void dispose() {
    _streamController.close();
  }
}