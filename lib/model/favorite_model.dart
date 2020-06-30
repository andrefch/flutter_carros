import 'package:flutter/material.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/service/favorite_service.dart';

class FavoriteModel extends ChangeNotifier {
  List<Car> _cars = [];

  List<Car> get cars => _cars;

  void fetchCars() async {
    _cars = await FavoriteService.getCars();
    notifyListeners();
  }
}