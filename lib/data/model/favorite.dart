import 'package:flutter_carros/data/model/entity.dart';

import 'car.dart';

class Favorite extends Entity {
  int id;
  String name;

  Favorite({this.id, this.name});

  Favorite.fromMap(Map<String, dynamic> data)
      : this(
          id: data['id'],
          name: data['nome'],
        );

  Favorite.fromCar(Car car)
      : this(
          id: car.id,
          name: car.name,
        );

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.name;
    return data;
  }
}
