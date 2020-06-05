import 'package:flutter_carros/data/local/favorite_dao.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/data/model/favorite.dart';

class FavoriteService {
  static final FavoriteDao _dao = FavoriteDao();

  static Future<bool> toggleFavorite(Car car) async {
    if (await _dao.exists(car.id)) {
      await _dao.delete(car.id);
      return false;
    } else {
      final favorite = Favorite.fromCar(car);
      await _dao.save(favorite);
      return true;
    }
  }

  static Future<List<Car>> getCars() async {
    return await _dao.findCars();
  }

  static Future<bool> isFavorite(Car car) async {
    return await _dao.exists(car.id);
  }
}
