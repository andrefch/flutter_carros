import 'dart:async';

import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/service/favorite_service.dart';

class FavoriteBloc {

  StreamController<List<Car>> _streamController = StreamController<List<Car>>();

  Stream<List<Car>> get stream => _streamController.stream;

  Future<List<Car>> fetchCars() async {
    try {
      final List<Car> cars = await FavoriteService.getCars();
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