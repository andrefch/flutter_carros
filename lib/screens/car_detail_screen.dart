import 'package:flutter/material.dart';
import 'package:flutter_carros/data/model/car.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  CarDetailScreen(this.car);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
      ),
      body: _createBody(),
    );
  }

  Widget _createBody() {
    return Center(
      child: car.urlImage != null
          ? Image.network(car.urlImage)
          : Image.asset("assets/images/placeholder_car.png"),
    );
  }
}
