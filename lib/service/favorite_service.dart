import 'package:flutter/cupertino.dart';
import 'package:flutter_carros/data/local/favorite_dao.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/data/model/favorite.dart';
import 'package:flutter_carros/model/favorite_model.dart';
import 'package:provider/provider.dart';

class FavoriteService {
  static final FavoriteDao _dao = FavoriteDao();

  static Future<bool> toggleFavorite(BuildContext context, Car car) async {
    bool result;
    if (await _dao.exists(car.id)) {
      await _dao.delete(car.id);
      result = false;
    } else {
      final favorite = Favorite.fromCar(car);
      await _dao.save(favorite);
      result = true;
    }
    _updateFavoriteModel(context);
    return result;
  }

  static Future<List<Car>> getCars() async {
    return await _dao.findCars();
  }

  static Future<bool> isFavorite(Car car) async {
    return await _dao.exists(car.id);
  }

  static void _updateFavoriteModel(BuildContext context) {
    Provider.of<FavoriteModel>(context, listen: false).fetchCars();
  }
}
